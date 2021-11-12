import 'dart:collection';
import 'services.dart';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.

var _kEventSource = Map.fromIterable(getAllCars(),
    key: (item) => DateTime.parse(item['date'].toString()), value: (item) => getAllCars().where((element) => element['date'] == item['date']).map((e) => Event(e['ref'])).toList());

var kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

void reset() {
  _kEventSource = Map.fromIterable(getAllCars(),
      key: (item) => DateTime.parse(item['date'].toString()), value: (item) => getAllCars().where((element) => element['date'] == item['date']).map((e) => Event(e['ref'])).toList());
  kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(_kEventSource);
}
