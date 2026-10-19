const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Formats a date and time like `Sat, 7 Nov 2026 · 10:00`.
String formatEventDateTime(DateTime dateTime) {
  final weekday = _weekdays[dateTime.weekday - 1];
  final month = _months[dateTime.month - 1];
  final time = '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
  return '$weekday, ${dateTime.day} $month ${dateTime.year} · $time';
}
