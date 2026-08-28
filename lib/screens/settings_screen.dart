import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/reminder_settings.dart';
import '../models/user_profile.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _intervalController = TextEditingController();
    _messageController = TextEditingController();
    _dailyGoalController = TextEditingController();
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
    _dailyGoalController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.errorDailyGoalRange(
              ReminderSettings.minDailyGoalMl,
              ReminderSettings.maxDailyGoalMl,
            ),
          ),
        ),
      );
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
          padding: const EdgeInsets.all(24),
          children: [
            Text(loc.reminderIntervalTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _intervalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: loc.minutesUnit,
                hintText: loc.intervalHint,
              ),
            ),
            const SizedBox(height: 28),
            Text(loc.activeHoursTitle, style: Theme.of(context).textTheme.titleMedium),
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
            const SizedBox(height: 28),
            Text(loc.dailyGoalTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
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
              ),
            ),
            const SizedBox(height: 28),
            Text(loc.notificationMessageTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: loc.notificationDefaultMessage,
              ),
            ),
            const SizedBox(height: 28),
            Text(loc.alcoholProfileTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
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
            const SizedBox(height: 32),
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
