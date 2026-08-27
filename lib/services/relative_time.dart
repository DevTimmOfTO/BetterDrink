/// Formats [time] relative to now, e.g. "just now", "5m ago", "2h ago",
/// or a `D.M. HH:mm` timestamp once it's more than a day old.
String formatRelativeTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '${time.day}.${time.month}. $hour:$minute';
}
