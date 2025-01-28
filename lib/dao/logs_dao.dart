import 'package:drift/drift.dart' as drift;
import '../constants/common_constants.dart';
import '../drift_db/database.dart';

class LogsDao {
  AppDatabase database = AppDatabase();

  insertLogs(List<LogsCompanion> logsCompanion) async {
    if (logsCompanion.isNotEmpty) {
      try {
        database.batch((batch) {
          return batch.insertAllOnConflictUpdate(database.logs, logsCompanion);
        });
      } catch (e, s) {
        showLog("the error in album insert $e,$s");
      }
    }
  }

  Future<List<Log>> getLogs() async {
    return await (database.select(
      database.logs,
    )).get();
  }

  Future<List<Log>> getCallLog() async {
    return await (database.select(database.logs)
          ..orderBy([
            (t) => drift.OrderingTerm.desc(t.id)
            // Adjust 'id' to your primary key column name
          ])
          ..limit(1))
        .get();
  }

  Future<List<Log>> getLogsWhereNotSynced() async {
    return await (database.select(database.logs)
          ..where((tbl) => tbl.syncedStatus.equals(false)))
        .get();
  }

  Future<void> updateSyncedStatus(int id) async {
    await (database.update(database.logs)..where((tbl) => tbl.id.equals(id)))
        .write(const LogsCompanion(
      syncedStatus: drift.Value(true),
    ));
  }

  Future<void> deleteEventListenerTable() async {
    await (database.delete(database.eventListener)).go();
  }

  Future<void >deleteEventById(id) async {
    await (database.delete(database.eventListener)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

class CallLog1 {
  final String callLog;

  CallLog1(this.callLog);
}
