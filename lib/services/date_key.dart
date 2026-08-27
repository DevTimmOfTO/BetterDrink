/// Formats [date] as a `YYYY-MM-DD` key. Shared by hydration history and
/// alcohol trend aggregation so both bucket days identically, and by
/// [HydrationService] for its own daily-reset bookkeeping.
String dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
