import 'package:intl/intl.dart';

// Argentina no tiene horario de verano: siempre UTC-3, vea la hora quien la vea.
DateTime _ar(DateTime d) => d.toUtc().subtract(const Duration(hours: 3));

String _clean(String s) => s.replaceAll('.', '').replaceAll(',', '');

/// "dom" · "29" · "nov"
({String weekday, String day, String month}) dateParts(DateTime d) {
  final ar = _ar(d);
  return (
    weekday: _clean(DateFormat('EEE', 'es_AR').format(ar)),
    day: '${ar.day}',
    month: _clean(DateFormat('MMM', 'es_AR').format(ar)),
  );
}

/// "dom 29 nov"
String shortDay(DateTime d) {
  final p = dateParts(d);
  return '${p.weekday} ${p.day} ${p.month}';
}

/// "domingo 29 de noviembre"
String longDay(DateTime d) => DateFormat("EEEE d 'de' MMMM", 'es_AR').format(_ar(d));

/// "17:00"
String hour(DateTime d) => DateFormat('HH:mm').format(_ar(d));

/// "20 de noviembre de 2026"
String fullDate(DateTime d) => DateFormat("d 'de' MMMM 'de' y", 'es_AR').format(_ar(d));

/// Fechas sin hora (vencimientos): se muestran tal cual vienen.
String plainDate(DateTime d) => DateFormat("d 'de' MMMM 'de' y", 'es_AR').format(d);
