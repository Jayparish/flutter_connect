// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EventListenerTable extends EventListener
    with TableInfo<$EventListenerTable, EventListenerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventListenerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _outTimeMeta =
      const VerificationMeta('outTime');
  @override
  late final GeneratedColumn<String> outTime = GeneratedColumn<String>(
      'out_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inTimeMeta = const VerificationMeta('inTime');
  @override
  late final GeneratedColumn<String> inTime = GeneratedColumn<String>(
      'in_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncMeta = const VerificationMeta('sync');
  @override
  late final GeneratedColumn<bool> sync = GeneratedColumn<bool>(
      'sync', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("sync" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, outTime, inTime, sync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_listener';
  @override
  VerificationContext validateIntegrity(Insertable<EventListenerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('out_time')) {
      context.handle(_outTimeMeta,
          outTime.isAcceptableOrUnknown(data['out_time']!, _outTimeMeta));
    } else if (isInserting) {
      context.missing(_outTimeMeta);
    }
    if (data.containsKey('in_time')) {
      context.handle(_inTimeMeta,
          inTime.isAcceptableOrUnknown(data['in_time']!, _inTimeMeta));
    } else if (isInserting) {
      context.missing(_inTimeMeta);
    }
    if (data.containsKey('sync')) {
      context.handle(
          _syncMeta, sync.isAcceptableOrUnknown(data['sync']!, _syncMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventListenerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventListenerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      outTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}out_time'])!,
      inTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}in_time'])!,
      sync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sync'])!,
    );
  }

  @override
  $EventListenerTable createAlias(String alias) {
    return $EventListenerTable(attachedDatabase, alias);
  }
}

class EventListenerData extends DataClass
    implements Insertable<EventListenerData> {
  final int id;
  final String outTime;
  final String inTime;
  final bool sync;
  const EventListenerData(
      {required this.id,
      required this.outTime,
      required this.inTime,
      required this.sync});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['out_time'] = Variable<String>(outTime);
    map['in_time'] = Variable<String>(inTime);
    map['sync'] = Variable<bool>(sync);
    return map;
  }

  EventListenerCompanion toCompanion(bool nullToAbsent) {
    return EventListenerCompanion(
      id: Value(id),
      outTime: Value(outTime),
      inTime: Value(inTime),
      sync: Value(sync),
    );
  }

  factory EventListenerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventListenerData(
      id: serializer.fromJson<int>(json['id']),
      outTime: serializer.fromJson<String>(json['outTime']),
      inTime: serializer.fromJson<String>(json['inTime']),
      sync: serializer.fromJson<bool>(json['sync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'outTime': serializer.toJson<String>(outTime),
      'inTime': serializer.toJson<String>(inTime),
      'sync': serializer.toJson<bool>(sync),
    };
  }

  EventListenerData copyWith(
          {int? id, String? outTime, String? inTime, bool? sync}) =>
      EventListenerData(
        id: id ?? this.id,
        outTime: outTime ?? this.outTime,
        inTime: inTime ?? this.inTime,
        sync: sync ?? this.sync,
      );
  EventListenerData copyWithCompanion(EventListenerCompanion data) {
    return EventListenerData(
      id: data.id.present ? data.id.value : this.id,
      outTime: data.outTime.present ? data.outTime.value : this.outTime,
      inTime: data.inTime.present ? data.inTime.value : this.inTime,
      sync: data.sync.present ? data.sync.value : this.sync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventListenerData(')
          ..write('id: $id, ')
          ..write('outTime: $outTime, ')
          ..write('inTime: $inTime, ')
          ..write('sync: $sync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, outTime, inTime, sync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventListenerData &&
          other.id == this.id &&
          other.outTime == this.outTime &&
          other.inTime == this.inTime &&
          other.sync == this.sync);
}

class EventListenerCompanion extends UpdateCompanion<EventListenerData> {
  final Value<int> id;
  final Value<String> outTime;
  final Value<String> inTime;
  final Value<bool> sync;
  const EventListenerCompanion({
    this.id = const Value.absent(),
    this.outTime = const Value.absent(),
    this.inTime = const Value.absent(),
    this.sync = const Value.absent(),
  });
  EventListenerCompanion.insert({
    this.id = const Value.absent(),
    required String outTime,
    required String inTime,
    this.sync = const Value.absent(),
  })  : outTime = Value(outTime),
        inTime = Value(inTime);
  static Insertable<EventListenerData> custom({
    Expression<int>? id,
    Expression<String>? outTime,
    Expression<String>? inTime,
    Expression<bool>? sync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (outTime != null) 'out_time': outTime,
      if (inTime != null) 'in_time': inTime,
      if (sync != null) 'sync': sync,
    });
  }

  EventListenerCompanion copyWith(
      {Value<int>? id,
      Value<String>? outTime,
      Value<String>? inTime,
      Value<bool>? sync}) {
    return EventListenerCompanion(
      id: id ?? this.id,
      outTime: outTime ?? this.outTime,
      inTime: inTime ?? this.inTime,
      sync: sync ?? this.sync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (outTime.present) {
      map['out_time'] = Variable<String>(outTime.value);
    }
    if (inTime.present) {
      map['in_time'] = Variable<String>(inTime.value);
    }
    if (sync.present) {
      map['sync'] = Variable<bool>(sync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventListenerCompanion(')
          ..write('id: $id, ')
          ..write('outTime: $outTime, ')
          ..write('inTime: $inTime, ')
          ..write('sync: $sync')
          ..write(')'))
        .toString();
  }
}

class $LogsTable extends Logs with TableInfo<$LogsTable, Log> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _callLogMeta =
      const VerificationMeta('callLog');
  @override
  late final GeneratedColumn<String> callLog = GeneratedColumn<String>(
      'call_log', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedStatusMeta =
      const VerificationMeta('syncedStatus');
  @override
  late final GeneratedColumn<bool> syncedStatus = GeneratedColumn<bool>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("sync_status" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, callLog, syncedStatus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logs';
  @override
  VerificationContext validateIntegrity(Insertable<Log> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('call_log')) {
      context.handle(_callLogMeta,
          callLog.isAcceptableOrUnknown(data['call_log']!, _callLogMeta));
    } else if (isInserting) {
      context.missing(_callLogMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncedStatusMeta,
          syncedStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncedStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Log map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Log(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      callLog: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}call_log'])!,
      syncedStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $LogsTable createAlias(String alias) {
    return $LogsTable(attachedDatabase, alias);
  }
}

class Log extends DataClass implements Insertable<Log> {
  final int id;
  final String callLog;
  final bool syncedStatus;
  const Log(
      {required this.id, required this.callLog, required this.syncedStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['call_log'] = Variable<String>(callLog);
    map['sync_status'] = Variable<bool>(syncedStatus);
    return map;
  }

  LogsCompanion toCompanion(bool nullToAbsent) {
    return LogsCompanion(
      id: Value(id),
      callLog: Value(callLog),
      syncedStatus: Value(syncedStatus),
    );
  }

  factory Log.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Log(
      id: serializer.fromJson<int>(json['id']),
      callLog: serializer.fromJson<String>(json['callLog']),
      syncedStatus: serializer.fromJson<bool>(json['syncedStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'callLog': serializer.toJson<String>(callLog),
      'syncedStatus': serializer.toJson<bool>(syncedStatus),
    };
  }

  Log copyWith({int? id, String? callLog, bool? syncedStatus}) => Log(
        id: id ?? this.id,
        callLog: callLog ?? this.callLog,
        syncedStatus: syncedStatus ?? this.syncedStatus,
      );
  Log copyWithCompanion(LogsCompanion data) {
    return Log(
      id: data.id.present ? data.id.value : this.id,
      callLog: data.callLog.present ? data.callLog.value : this.callLog,
      syncedStatus: data.syncedStatus.present
          ? data.syncedStatus.value
          : this.syncedStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Log(')
          ..write('id: $id, ')
          ..write('callLog: $callLog, ')
          ..write('syncedStatus: $syncedStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, callLog, syncedStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          other.id == this.id &&
          other.callLog == this.callLog &&
          other.syncedStatus == this.syncedStatus);
}

class LogsCompanion extends UpdateCompanion<Log> {
  final Value<int> id;
  final Value<String> callLog;
  final Value<bool> syncedStatus;
  const LogsCompanion({
    this.id = const Value.absent(),
    this.callLog = const Value.absent(),
    this.syncedStatus = const Value.absent(),
  });
  LogsCompanion.insert({
    this.id = const Value.absent(),
    required String callLog,
    this.syncedStatus = const Value.absent(),
  }) : callLog = Value(callLog);
  static Insertable<Log> custom({
    Expression<int>? id,
    Expression<String>? callLog,
    Expression<bool>? syncedStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (callLog != null) 'call_log': callLog,
      if (syncedStatus != null) 'sync_status': syncedStatus,
    });
  }

  LogsCompanion copyWith(
      {Value<int>? id, Value<String>? callLog, Value<bool>? syncedStatus}) {
    return LogsCompanion(
      id: id ?? this.id,
      callLog: callLog ?? this.callLog,
      syncedStatus: syncedStatus ?? this.syncedStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (callLog.present) {
      map['call_log'] = Variable<String>(callLog.value);
    }
    if (syncedStatus.present) {
      map['sync_status'] = Variable<bool>(syncedStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsCompanion(')
          ..write('id: $id, ')
          ..write('callLog: $callLog, ')
          ..write('syncedStatus: $syncedStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventListenerTable eventListener = $EventListenerTable(this);
  late final $LogsTable logs = $LogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [eventListener, logs];
}

typedef $$EventListenerTableCreateCompanionBuilder = EventListenerCompanion
    Function({
  Value<int> id,
  required String outTime,
  required String inTime,
  Value<bool> sync,
});
typedef $$EventListenerTableUpdateCompanionBuilder = EventListenerCompanion
    Function({
  Value<int> id,
  Value<String> outTime,
  Value<String> inTime,
  Value<bool> sync,
});

class $$EventListenerTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventListenerTable,
    EventListenerData,
    $$EventListenerTableFilterComposer,
    $$EventListenerTableOrderingComposer,
    $$EventListenerTableCreateCompanionBuilder,
    $$EventListenerTableUpdateCompanionBuilder> {
  $$EventListenerTableTableManager(_$AppDatabase db, $EventListenerTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$EventListenerTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$EventListenerTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> outTime = const Value.absent(),
            Value<String> inTime = const Value.absent(),
            Value<bool> sync = const Value.absent(),
          }) =>
              EventListenerCompanion(
            id: id,
            outTime: outTime,
            inTime: inTime,
            sync: sync,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String outTime,
            required String inTime,
            Value<bool> sync = const Value.absent(),
          }) =>
              EventListenerCompanion.insert(
            id: id,
            outTime: outTime,
            inTime: inTime,
            sync: sync,
          ),
        ));
}

class $$EventListenerTableFilterComposer
    extends FilterComposer<_$AppDatabase, $EventListenerTable> {
  $$EventListenerTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get outTime => $state.composableBuilder(
      column: $state.table.outTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get inTime => $state.composableBuilder(
      column: $state.table.inTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get sync => $state.composableBuilder(
      column: $state.table.sync,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$EventListenerTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $EventListenerTable> {
  $$EventListenerTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get outTime => $state.composableBuilder(
      column: $state.table.outTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get inTime => $state.composableBuilder(
      column: $state.table.inTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get sync => $state.composableBuilder(
      column: $state.table.sync,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LogsTableCreateCompanionBuilder = LogsCompanion Function({
  Value<int> id,
  required String callLog,
  Value<bool> syncedStatus,
});
typedef $$LogsTableUpdateCompanionBuilder = LogsCompanion Function({
  Value<int> id,
  Value<String> callLog,
  Value<bool> syncedStatus,
});

class $$LogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LogsTable,
    Log,
    $$LogsTableFilterComposer,
    $$LogsTableOrderingComposer,
    $$LogsTableCreateCompanionBuilder,
    $$LogsTableUpdateCompanionBuilder> {
  $$LogsTableTableManager(_$AppDatabase db, $LogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LogsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LogsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> callLog = const Value.absent(),
            Value<bool> syncedStatus = const Value.absent(),
          }) =>
              LogsCompanion(
            id: id,
            callLog: callLog,
            syncedStatus: syncedStatus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String callLog,
            Value<bool> syncedStatus = const Value.absent(),
          }) =>
              LogsCompanion.insert(
            id: id,
            callLog: callLog,
            syncedStatus: syncedStatus,
          ),
        ));
}

class $$LogsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LogsTable> {
  $$LogsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get callLog => $state.composableBuilder(
      column: $state.table.callLog,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get syncedStatus => $state.composableBuilder(
      column: $state.table.syncedStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LogsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LogsTable> {
  $$LogsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get callLog => $state.composableBuilder(
      column: $state.table.callLog,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get syncedStatus => $state.composableBuilder(
      column: $state.table.syncedStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventListenerTableTableManager get eventListener =>
      $$EventListenerTableTableManager(_db, _db.eventListener);
  $$LogsTableTableManager get logs => $$LogsTableTableManager(_db, _db.logs);
}
