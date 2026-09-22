import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/reminder_settings.dart';
import '../models/theme_preferences.dart';
import '../models/user_profile.dart';
import '../providers/health_connect_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../services/alcohol_service.dart';
import '../services/health_connect_service.dart';

/// Settings tab: hydration reminder configuration (interval, active hours,
/// notification message) plus the alcohol profile (sex, age, weight) used
/// to personalize the BAC estimate on the Alcohol tab.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _intervalController;
  late final TextEditingController _messageController;
  late final TextEditingController _dailyGoalController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late int _activeStartMinutes;
  late int _activeEndMinutes;
  late Sex _sex;
  bool _settingsInitialized = false;
  bool _profileInitialized = false;
  bool _isImportingFromHealthConnect = false;

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController();
    _messageController = TextEditingController();
    _dailyGoalController = TextEditingController()..addListener(_onDailyGoalChanged);
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _activeStartMinutes = ReminderSettings.defaults.activeStartMinutes;
    _activeEndMinutes = ReminderSettings.defaults.activeEndMinutes;
    _sex = UserProfile.defaults.sex;
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _messageController.dispose();
    _dailyGoalController.removeListener(_onDailyGoalChanged);
    _dailyGoalController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  /// Rebuilds on every keystroke so the field's red border/error text
  /// tracks the value live instead of only surfacing on Save.
  void _onDailyGoalChanged() => setState(() {});

  /// Null when the daily-goal field is empty (not yet edited, or cleared
  /// mid-edit) or holds a valid in-range value — the field only shows an
  /// error once there's actually invalid text to complain about.
  String? _dailyGoalError(AppLocalizations loc) {
    final text = _dailyGoalController.text;
    if (text.isEmpty) return null;
    final value = int.tryParse(text);
    if (value != null &&
        value >= ReminderSettings.minDailyGoalMl &&
        value <= ReminderSettings.maxDailyGoalMl) {
      return null;
    }
    return loc.errorDailyGoalRange(
      ReminderSettings.minDailyGoalMl,
      ReminderSettings.maxDailyGoalMl,
    );
  }

  void _syncFromSettings(ReminderSettings settings) {
    _intervalController.text = settings.intervalMinutes.toString();
    _messageController.text = settings.message ?? '';
    _dailyGoalController.text = settings.dailyGoalMl.toString();
    _activeStartMinutes = settings.activeStartMinutes;
    _activeEndMinutes = settings.activeEndMinutes;
  }

  void _syncFromProfile(UserProfile profile) {
    _sex = profile.sex;
    _ageController.text = profile.age.toString();
    _weightController.text = profile.weightKg.toStringAsFixed(0);
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = TimeOfDay(
      hour: (isStart ? _activeStartMinutes : _activeEndMinutes) ~/ 60,
      minute: (isStart ? _activeStartMinutes : _activeEndMinutes) % 60,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      final minutes = picked.hour * 60 + picked.minute;
      if (isStart) {
        _activeStartMinutes = minutes;
      } else {
        _activeEndMinutes = minutes;
      }
    });
  }

  Future<void> _save(AppLocalizations loc) async {
    final interval = int.tryParse(_intervalController.text);
    if (interval == null || interval <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorEnterInterval)),
      );
      return;
    }
    if (_activeStartMinutes >= _activeEndMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorActiveWindowOrder)),
      );
      return;
    }
    final dailyGoalMl = int.tryParse(_dailyGoalController.text);
    if (dailyGoalMl == null ||
        dailyGoalMl < ReminderSettings.minDailyGoalMl ||
        dailyGoalMl > ReminderSettings.maxDailyGoalMl) {
      // The field already shows this inline via _dailyGoalError's red
      // border/error text, so no SnackBar needed here too.
      return;
    }
    final age = int.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    if (age == null || age <= 0 || weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorAgeWeight)),
      );
      return;
    }

    final message = _messageController.text.trim();
    await ref.read(settingsProvider.notifier).update(
          ReminderSettings(
            intervalMinutes: interval,
            activeStartMinutes: _activeStartMinutes,
            activeEndMinutes: _activeEndMinutes,
            message: message.isEmpty ? null : message,
            dailyGoalMl: dailyGoalMl,
          ),
        );
    await ref.read(profileProvider.notifier).update(
          UserProfile(sex: _sex, age: age, weightKg: weight),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.settingsSaved)),
      );
    }
  }

  String _sexLabel(AppLocalizations loc, Sex sex) => switch (sex) {
        Sex.male => loc.maleLabel,
        Sex.female => loc.femaleLabel,
        Sex.other => loc.otherLabel,
      };

  /// Shows a checkbox picker for whichever fields Health Connect actually
  /// has data for, pre-checked. Returns the fields the user confirmed
  /// importing, or null if they cancelled.
  Future<HealthConnectProfileFields?> _showImportSelectionDialog(
    AppLocalizations loc,
    HealthConnectProfileFields available,
  ) {
    bool importSex = available.sex != null;
    bool importAge = available.age != null;
    bool importWeight = available.weightKg != null;

    return showDialog<HealthConnectProfileFields>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final anySelected = importSex || importAge || importWeight;
          return AlertDialog(
            title: Text(loc.healthConnectImportDialogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (available.sex != null)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(loc.sexLabel),
                    subtitle: Text(_sexLabel(loc, available.sex!)),
                    value: importSex,
                    onChanged: (value) =>
                        setDialogState(() => importSex = value ?? false),
                  ),
                if (available.age != null)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(loc.ageLabel),
                    subtitle: Text('${available.age} ${loc.yearsUnit}'),
                    value: importAge,
                    onChanged: (value) =>
                        setDialogState(() => importAge = value ?? false),
                  ),
                if (available.weightKg != null)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(loc.weightLabel),
                    subtitle: Text(
                      '${available.weightKg!.toStringAsFixed(0)} ${loc.kgUnit}',
                    ),
                    value: importWeight,
                    onChanged: (value) =>
                        setDialogState(() => importWeight = value ?? false),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(loc.cancel),
              ),
              FilledButton(
                onPressed: anySelected
                    ? () => Navigator.of(dialogContext).pop(
                          HealthConnectProfileFields(
                            sex: importSex ? available.sex : null,
                            age: importAge ? available.age : null,
                            weightKg: importWeight ? available.weightKg : null,
                          ),
                        )
                    : null,
                child: Text(loc.import),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _importFromHealthConnect(AppLocalizations loc) async {
    setState(() => _isImportingFromHealthConnect = true);

    try {
      final available =
          await AlcoholService.instance.requestProfileFieldsFromHealthConnect();

      if (!mounted) return;

      if (available == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.healthConnectProfileNoData)),
        );
        return;
      }

      final selected = await _showImportSelectionDialog(loc, available);
      if (selected == null || !mounted) return;

      final updated = UserProfile(
        sex: selected.sex ?? _sex,
        age: selected.age ?? (int.tryParse(_ageController.text) ?? UserProfile.defaults.age),
        weightKg: selected.weightKg ??
            (double.tryParse(_weightController.text) ?? UserProfile.defaults.weightKg),
      );
      _syncFromProfile(updated);
      _profileInitialized = true;

      await ref.read(profileProvider.notifier).update(updated);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.healthConnectProfileImportSuccess)),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.healthConnectProfileImportFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isImportingFromHealthConnect = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(profileProvider);
    // The notifiers return a synchronous placeholder (.defaults) from
    // build() and only replace it with the real persisted values a tick
    // later, once their async load resolves (see CLAUDE.md). Syncing on
    // the very first build would seed these controllers from that
    // placeholder instead — identical() reliably tells them apart, since
    // load() always constructs a fresh instance rather than returning the
    // const .defaults singleton, even when the persisted values happen to
    // match it.
    if (!_settingsInitialized && !identical(settings, ReminderSettings.defaults)) {
      _syncFromSettings(settings);
      _settingsInitialized = true;
    }
    if (!_profileInitialized && !identical(profile, UserProfile.defaults)) {
      _syncFromProfile(profile);
      _profileInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _SettingsSection(
              icon: Icons.palette_rounded,
              title: loc.appearanceTitle,
              children: const [_AppearanceSectionBody()],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              icon: Icons.health_and_safety_rounded,
              title: loc.healthConnectTitle,
              children: [
                Text(
                  loc.importFromHealthConnectDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isImportingFromHealthConnect
                      ? null
                      : () => _importFromHealthConnect(loc),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(loc.importFromHealthConnect),
                ),
                if (_isImportingFromHealthConnect) ...[
                  const SizedBox(height: 8),
                  const Center(child: CircularProgressIndicator()),
                ],
                const SizedBox(height: 20),
                const _HealthConnectSectionBody(),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              icon: Icons.notifications_active_rounded,
              title: loc.reminderIntervalTitle,
              children: [
                Text(
                  loc.reminderIntervalChangeNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _intervalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: loc.minutesUnit,
                    hintText: loc.intervalHint,
                  ),
                ),
                const SizedBox(height: 20),
                Text(loc.activeHoursTitle, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  loc.activeHoursDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _TimeField(
                        label: loc.fromLabel,
                        minutes: _activeStartMinutes,
                        onTap: () => _pickTime(true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TimeField(
                        label: loc.untilLabel,
                        minutes: _activeEndMinutes,
                        onTap: () => _pickTime(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(loc.notificationMessageTitle, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: loc.notificationDefaultMessage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              icon: Icons.local_drink_rounded,
              title: loc.dailyGoalTitle,
              children: [
                Text(
                  loc.dailyGoalDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dailyGoalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: loc.mlUnit,
                    hintText: loc.dailyGoalHint,
                    errorText: _dailyGoalError(loc),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              icon: Icons.wine_bar_rounded,
              title: loc.alcoholProfileTitle,
              children: [
                Text(
                  loc.alcoholProfileDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                SegmentedButton<Sex>(
                  segments: [
                    ButtonSegment(value: Sex.male, label: Text(loc.maleLabel)),
                    ButtonSegment(value: Sex.female, label: Text(loc.femaleLabel)),
                    ButtonSegment(value: Sex.other, label: Text(loc.otherLabel)),
                  ],
                  selected: {_sex},
                  onSelectionChanged: (selection) =>
                      setState(() => _sex = selection.first),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: loc.ageLabel,
                          suffixText: loc.yearsUnit,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: loc.weightLabel,
                          suffixText: loc.kgUnit,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _save(loc),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(loc.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One collapsible, icon-labelled settings group -- the Flutter equivalent
/// of a Qt QToolBox pane. Independent of its siblings: each section keeps
/// its own expanded/collapsed state rather than acting as an accordion.
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        initiallyExpanded: false,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.minutes,
    required this.onTap,
  });

  final String label;
  final int minutes;
  final VoidCallback onTap;

  String get _formatted {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(_formatted, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

/// Appearance options (device accent color, font). Applies immediately on
/// change rather than being gated behind the Save button, matching how a
/// live theme preview is normally expected to behave.
class _AppearanceSectionBody extends ConsumerWidget {
  const _AppearanceSectionBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final theme = ref.watch(themeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(loc.useDynamicColorTitle),
          subtitle: Text(loc.useDynamicColorDescription),
          value: theme.useDynamicColor,
          onChanged: (value) => ref.read(themeProvider.notifier).update(
                ThemePreferences(
                  useDynamicColor: value,
                  fontFamily: theme.fontFamily,
                ),
              ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: theme.fontFamily,
          decoration: InputDecoration(labelText: loc.fontFamilyTitle),
          items: [
            DropdownMenuItem(value: null, child: Text(loc.fontFamilyDefault)),
            DropdownMenuItem(value: 'serif', child: Text(loc.fontFamilySerif)),
            DropdownMenuItem(
              value: 'sans-serif-condensed',
              child: Text(loc.fontFamilyCondensed),
            ),
            DropdownMenuItem(
              value: 'monospace',
              child: Text(loc.fontFamilyMonospace),
            ),
          ],
          onChanged: (value) => ref.read(themeProvider.notifier).update(
                ThemePreferences(
                  useDynamicColor: theme.useDynamicColor,
                  fontFamily: value,
                ),
              ),
        ),
      ],
    );
  }
}

/// Opt-in toggle for mirroring logged water intake into Google Health
/// Connect. Applies immediately, same as [_AppearanceSectionBody] -- there's
/// nothing to gate behind the Save button since this doesn't affect the
/// reminder/profile fields in the other sections.
class _HealthConnectSectionBody extends ConsumerWidget {
  const _HealthConnectSectionBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final enabled = ref.watch(healthConnectProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.healthConnectDescription,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(loc.healthConnectSyncTitle),
          value: enabled,
          onChanged: (value) async {
            final result =
                await ref.read(healthConnectProvider.notifier).setEnabled(value);
            if (!context.mounted) return;
            final message = switch (result) {
              HealthConnectSyncResult.needsHealthConnectInstall =>
                loc.healthConnectNeedsInstallMessage,
              HealthConnectSyncResult.permissionDenied =>
                loc.healthConnectPermissionDeniedMessage,
              HealthConnectSyncResult.enabled ||
              HealthConnectSyncResult.disabled =>
                null,
            };
            if (message != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            }
          },
        ),
      ],
    );
  }
}
