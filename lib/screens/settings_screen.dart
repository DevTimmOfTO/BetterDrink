import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool _initializedFromState = false;

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
    _messageController.text = settings.message;
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

  Future<void> _save() async {
    final interval = int.tryParse(_intervalController.text);
    if (interval == null || interval <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a reminder interval in minutes')),
      );
      return;
    }
    if (_activeStartMinutes >= _activeEndMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Active start time must be before end time')),
      );
      return;
    }
    final dailyGoalMl = int.tryParse(_dailyGoalController.text);
    if (dailyGoalMl == null || dailyGoalMl <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a daily hydration goal in ml')),
      );
      return;
    }
    final age = int.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    if (age == null || age <= 0 || weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid age and weight')),
      );
      return;
    }

    final message = _messageController.text.trim();
    await ref.read(settingsProvider.notifier).update(
          ReminderSettings(
            intervalMinutes: interval,
            activeStartMinutes: _activeStartMinutes,
            activeEndMinutes: _activeEndMinutes,
            message: message.isEmpty
                ? ReminderSettings.defaults.message
                : message,
            dailyGoalMl: dailyGoalMl,
          ),
        );
    await ref.read(profileProvider.notifier).update(
          UserProfile(sex: _sex, age: age, weightKg: weight),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(profileProvider);
    if (!_initializedFromState) {
      _syncFromSettings(settings);
      _syncFromProfile(profile);
      _initializedFromState = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Reminder interval', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _intervalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffixText: 'minutes',
                hintText: 'e.g. 45',
              ),
            ),
            const SizedBox(height: 28),
            Text('Active hours', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Reminders only fire during this window, so you won\'t be '
              'woken up at night.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TimeField(
                    label: 'From',
                    minutes: _activeStartMinutes,
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _TimeField(
                    label: 'Until',
                    minutes: _activeEndMinutes,
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Daily hydration goal', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Used to track goal-hit achievements on the Leaderboard tab.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dailyGoalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                suffixText: 'ml',
                hintText: 'e.g. 2000',
              ),
            ),
            const SizedBox(height: 28),
            Text('Notification message', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Time to drink some water 💧',
              ),
            ),
            const SizedBox(height: 28),
            Text('Alcohol profile', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Used only to personalize the blood-alcohol estimate on the '
              'Alcohol tab — it never leaves your device.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SegmentedButton<Sex>(
              segments: const [
                ButtonSegment(value: Sex.male, label: Text('Male')),
                ButtonSegment(value: Sex.female, label: Text('Female')),
                ButtonSegment(value: Sex.other, label: Text('Other')),
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
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      suffixText: 'years',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      suffixText: 'kg',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Save'),
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
