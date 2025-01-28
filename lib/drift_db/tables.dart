import 'package:drift/drift.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 6, max: 32)();

  TextColumn get content => text().named('body')();

  IntColumn get category =>
      integer().nullable().references(TodoCategory, #id)();

  DateTimeColumn get createdAt => dateTime().nullable()();
}

class TodoCategory extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();
}

class EventListener extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get outTime => text().named('out_time')();
  TextColumn get inTime => text().named('in_time')();

  BoolColumn get sync =>
      boolean().named('sync').withDefault(const Constant(false))();
}


class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get callLog =>
      text().named('call_log')();

  BoolColumn get syncedStatus =>
      boolean().named('sync_status').withDefault(const Constant(false))();
}

