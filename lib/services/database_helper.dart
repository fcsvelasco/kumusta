import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/day.dart';
import '../models/observation.dart';
import '../models/tracker.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    //print('_database == null? ${_database == null}');
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    //print('_initDatabase()');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'kumusta.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<bool> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentsDirectory.path, 'trackers.db'); //old database name
    databaseFactory.deleteDatabase(path);
    return true;
  }

  Future<void> _onCreate(Database db, int version) async {
    //print('_onCreate()');
    await db.execute(
        'CREATE TABLE trackers(id INTEGER PRIMARY KEY, isSameTimeForAllDays INTEGER, isWithBreakTime INTEGER, isNightShift INTEGER, isActivitiesCategorized INTEGER, trackerMode INTEGER, status INTEGER, startDate TEXT, endDate TEXT)');
    await db.execute(
        'CREATE TABLE activities(trackerId INTEGER, id TEXT, name TEXT, description TEXT, category INTEGER, iconId INTEGER, count INTEGER, PRIMARY KEY(trackerId, id))');
    await db.execute(
        'CREATE TABLE observations(trackerId INTEGER, observationId TEXT, dateTime TEXT, activityName TEXT, status INTEGER, dateTimeUpdated TEXT, PRIMARY KEY(trackerId, observationId))');
    await db.execute(
        'CREATE TABLE days(trackerId INTEGER, dayId INTEGER,isSelected INTEGER, observationStartTimeHr INTEGER, observationStartTimeMin INTEGER, observationEndTimeHr INTEGER,observationEndTimeMin INTEGER, breakStartTimeHr INTEGER, breakStartTimeMin INTEGER, breakEndTimeHr INTEGER, breakEndTimeMin INTEGER, PRIMARY KEY(trackerId, dayId))');
  }

  Future<List<Activity>> getActivitiesList() async {
    Database db = await instance.database;
    var activities = await db.query('activities');
    List<Activity> activitiesList = activities.isNotEmpty
        ? activities.map((e) => Activity.fromMap(e)).toList()
        : [];

    return activitiesList;
  }

  Future<List<Activity>> getActivitiesListOfTracker(int trackerId) async {
    List<Activity> allActivities = await getActivitiesList();
    return allActivities.where((a) => a.trackerId == trackerId).toList();
  }

  Future<List<Observation>> getObservationsListOfTracker(int trackerId) async {
    Database db = await instance.database;
    var observations = await db.query('observations');
    List<Observation> observationsList = observations.isNotEmpty
        ? observations
            .map<Observation>((e) => Observation.fromMap(e))
            .where((o) => o.trackerId == trackerId)
            .toList()
        : [];
    return observationsList;
  }

  Future<List<Day>> getDaysOfTracker(int trackerId) async {
    Database db = await instance.database;
    var days = await db.query('days');
    List<Day> daysList = days.isNotEmpty
        ? days
            .map<Day>((e) => Day.fromMap(e))
            .where((o) => o.trackerId == trackerId)
            .toList()
        : [];
    return daysList;
  }

  Future<List<Tracker>> getTrackersList() async {
    //print('getTrackersList()');
    Database db = await instance.database;
    //print('getTrackersList() db is null? ${db == null}');

    var trackers = await db.query('trackers');
    //print('getTrackersList() trackers is null? ${trackers == null}');
    //print(trackers);

    List<Tracker> trackersList = trackers.isNotEmpty
        ? trackers.map((e) => Tracker.fromMap(e)).toList()
        : [];

    //print('Tracker.fromMap() finished');
    //print('Tracker id from getTrackersList(): ${trackersList[0].id}');
    return trackersList;
  }

  Future<Tracker> getCurrentTracker() async {
    //print('getCurrentTracker()');
    return await getTrackersList().then((value) => value.lastWhere((element) {
          //print('getTrackersList().then()');
          return element.status == TrackerStatus.current;
        }));
  }

  Future<Tracker> getLatestFinishedTracker() async {
    return await getTrackersList().then((value) => value.lastWhere((element) {
          //print('getTrackersList().then()');
          return element.status == TrackerStatus.finished;
        }));
  }

  Future<Tracker> getTrackerFromList(int trackerId) async {
    //print('getTrackerFromList()');
    return await getTrackersList().then((value) => value.firstWhere((element) {
          return element.id == trackerId;
        }));
  }

  Future<void> insertTracker(Tracker tracker) async {
    //print('insertTracker()');
    Database db = await instance.database;
    //print(db.toString()[0].toString());
    int id = await db.insert(
      'trackers',
      tracker.toMap(true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertActivity(Activity activity) async {
    //print('insertActivity()');
    Database db = await instance.database;

    await db.insert(
      'activities',
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertObservation(Observation observation) async {
    //print('insertObservation()');
    Database db = await instance.database;

    await db.insert(
      'observations',
      observation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertDay(Day day) async {
    Database db = await instance.database;
    await db.insert('days', day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> insertNewTracker(WidgetRef ref) async {
    try {
      final oldTrackers = await getTrackersList();
      for (final t in oldTrackers) {
        if (t.status == TrackerStatus.current) {
          await unfinishTracker(t);
        }
      }
      Tracker tracker = ref.read(trackerProvider);
      final trackerFrequency = tracker.trackerFrequency;
      await insertTracker(tracker);
      tracker = await getCurrentTracker();
      //print('Tracker start date: ${tracker.startDate.toIso8601String()}');
      //print('Tracker end date: ${tracker.endDate.toIso8601String()}');

      List<Day> selectedDays =
          ref.read(daysProvider).where((day) => day.isSelected).toList();

      for (Day d in selectedDays) {
        await insertDay(d.copyWith(trackerId: tracker.id));
      }

      final activities = ref.read(activitiesProvider);
      for (Activity a in activities) {
        await insertActivity(a.copyWith(trackerId: tracker.id));
      }

      await tracker.generateObservations(
        selectedDays,
        ref,
        trackerFrequency,
      );
      final observations = ref.read(observationsProvider);
      for (Observation o in observations) {
        await insertObservation(o);
      }
      return true;
    } catch (e) {
      //print('insertNewTracker() error: $e');
      return false;
    }
  }

  Future<void> updateActivity(int trackerId, Activity activity) async {
    final db = await database;
    final tracker = await getTrackerFromList(trackerId);
    if (tracker.status != TrackerStatus.finished) {
      await db.update(
        'activities',
        activity.toMap(),
        where: 'trackerId = ? AND id = ?',
        whereArgs: [trackerId, activity.id],
      );
    }
  }

  Future<void> updateObservation(int trackerId, Observation observation) async {
    final db = await database;
    final tracker = await getTrackerFromList(trackerId);
    if (tracker.status != TrackerStatus.finished) {
      await db.update('observations', observation.toMap(),
          where: 'trackerId = ? AND observationId = ?',
          whereArgs: [trackerId, observation.id]);
    }
  }

  Future<bool> isWithCurrentTracker() async {
    try {
      List<Tracker> trackersList = await getTrackersList();
      return trackersList.indexWhere(
              (element) => element.status == TrackerStatus.current) !=
          -1;
    } catch (e) {
      //print('isWithCurrentTracker() error: $e');
      return false;
    }
  }

  Future<bool> isWithFinishedTracker() async {
    try {
      List<Tracker> trackersList = await getTrackersList();

      return trackersList.indexWhere(
              (element) => element.status == TrackerStatus.finished) !=
          -1;
    } catch (e) {
      //print('isWithCurrentTracker() error: $e');
      return false;
    }
  }

  Future<bool> loadLatestFinishedDataToNotifiers(WidgetRef ref) async {
    try {
      Tracker tracker = await getLatestFinishedTracker();
      List<Tracker> trackersList = await getTrackersList();
      List<Activity> activities = await getActivitiesListOfTracker(tracker.id);
      List<Observation> observations =
          await getObservationsListOfTracker(tracker.id);
      List<Day> selectedDays = await getDaysOfTracker(tracker.id);

      ref.read(trackerProvider.notifier).loadTrackerToNotifier(tracker);
      ref
          .read(trackersListProvider.notifier)
          .loadTrackersToNotifier(trackersList);
      ref
          .read(activitiesProvider.notifier)
          .loadActivitiesToNotifier(activities);
      ref
          .read(observationsProvider.notifier)
          .loadObservationsToNotifier(observations);
      ref.read(selectedDaysProvider.notifier).loadDaysToNotifier(selectedDays);
      return true;
    } catch (e) {
      //print('loadDataToNotifiers() error: $e');
      return false;
    }
  }

  Future<bool> loadCurrentDataToNotifiers(WidgetRef ref) async {
    try {
      Tracker tracker = await getCurrentTracker();
      List<Tracker> trackersList = await getTrackersList();
      List<Activity> activities = await getActivitiesListOfTracker(tracker.id);
      List<Observation> observations =
          await getObservationsListOfTracker(tracker.id);
      List<Day> selectedDays = await getDaysOfTracker(tracker.id);

      ref.read(trackerProvider.notifier).loadTrackerToNotifier(tracker);
      ref
          .read(trackersListProvider.notifier)
          .loadTrackersToNotifier(trackersList);
      ref
          .read(activitiesProvider.notifier)
          .loadActivitiesToNotifier(activities);
      ref
          .read(observationsProvider.notifier)
          .loadObservationsToNotifier(observations);

      ref.read(selectedDaysProvider.notifier).loadDaysToNotifier(selectedDays);
      return true;
    } catch (e) {
      //print('loadDataToNotifiers() error: $e');
      return false;
    }
  }

  Future<void> updateTracker(Tracker tracker) async {
    final db = await database;
    final trackerFromDb = await getTrackerFromList(tracker.id);
    if (trackerFromDb.status != TrackerStatus.finished) {
      await db.update(
        'trackers',
        tracker.toMap(false),
        where: 'id = ?',
        whereArgs: [tracker.id],
      );
    }
  }

  Future<void> unfinishTracker(Tracker tracker) async {
    try {
      await updateTracker(tracker.copyWith(
        status: TrackerStatus.unfinished,
        endDate: DateTime.now(),
      ));
    } catch (e) {
      //print('unfinishTracker() error $e');
    }
  }

  Future<bool> saveAndStartTracking(WidgetRef ref) async {
    final isTrackerSaved = await insertNewTracker(ref);
    if (isTrackerSaved) {
      return await loadCurrentDataToNotifiers(ref);
    } else {
      return false;
    }
  }

  Future<bool> deleteTracker(int trackerId, WidgetRef ref) async {
    try {
      final db = await database;
      await db.delete(
        'trackers',
        where: 'id = ?',
        whereArgs: [trackerId],
      );

      await deleteActivities(trackerId);
      await deleteObservations(trackerId);
      await deleteDays(trackerId);

      final trackersList = await getTrackersList();
      ref
          .read(trackersListProvider.notifier)
          .loadTrackersToNotifier(trackersList);
      return true;
    } catch (e) {
      //print('deleteTracker() error: $e');
      return false;
    }
  }

  Future<void> deleteObservations(int trackerId) async {
    try {
      final db = await database;
      await db.delete(
        'observations',
        where: 'trackerId = ?',
        whereArgs: [trackerId],
      );
    } catch (e) {
      //print('deleteObservations() error: $e');
    }
  }

  Future<void> deleteActivities(int trackerId) async {
    try {
      final db = await database;
      await db.delete(
        'activities',
        where: 'trackerId = ?',
        whereArgs: [trackerId],
      );
    } catch (e) {
      //print('deleteActivities() error: $e');
    }
  }

  Future<void> deleteDays(int trackerId) async {
    try {
      final db = await database;
      await db.delete(
        'days',
        where: 'trackerId = ?',
        whereArgs: [trackerId],
      );
    } catch (e) {
      //print('deleteDays() error: $e');
    }
  }

  Future<int?> countOfTrackersRows() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM trackers'));
  }

  Future<int?> countOfActivitiesRows() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM activities'));
  }

  Future<int?> countOfObservationsRows() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM observations'));
  }

  Future<int?> countOfDaysRows() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM days'));
  }
}
