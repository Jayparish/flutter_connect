import 'package:drift/drift.dart' as drift;
import '../constants/common_constants.dart';
import '../drift_db/database.dart';

class EventListenerDao {
  AppDatabase database = AppDatabase();

  Future<int?> insertEvents(
      List<EventListenerCompanion> eventListenerCompanion) async {
    if (eventListenerCompanion.isNotEmpty) {
      try {
        database.batch((batch) {
          return batch.insertAllOnConflictUpdate(
              database.eventListener, eventListenerCompanion);
        });
      } catch (e,s) {
        showLog("the error in album insert $e,$s");
      }
    }
  }

  Future<List<EventListenerData>> getEvents() async {
    return await (database.select(database.eventListener)).get();
  }

  Future<List<EventListenerData>> getEventsWhereNotSynced() async {
    return await (database.select(database.eventListener)
          ..where((tbl) => tbl.sync.equals(false)))
        .get();
  }

  Future<List<EventListenerData>> getEventsLimit() async {
    return await (database.select(database.eventListener)
          ..orderBy([
            (t) => drift.OrderingTerm.desc(t.id)
            // Adjust 'id' to your primary key column name
          ])
          ..limit(2))
        .get();
  }
  Future<void> updateSyncedStatus(int id)async {
    await (database.update(database.eventListener)
      ..where((tbl) => tbl.id.equals(id)))
        .write(const EventListenerCompanion(
      sync: drift.Value(true),
    ));
  }



  Future<void> deleteEventListenerTable() async {
    await (database.delete(database.eventListener)).go();
  }
}
