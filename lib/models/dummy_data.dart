import './day.dart';
import './observation.dart';
import './activity.dart';

const SELECTED_DAYS = [
  Day.monday(0),
  Day.tuesday(0),
  Day.wednesday(0),
  Day.thursday(0),
  Day.friday(0),
];

const ACTIVITIES = [
  Activity(
    trackerId: 0,
    id: 'In a meeting',
    name: 'In a meeting',
    description: '',
    category: ActivityCategory.productive,
    iconId: 13,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Resting',
    name: 'Resting',
    description: '',
    category: ActivityCategory.necessary,
    iconId: 55,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Breaktime',
    name: 'Breaktime',
    description: '',
    category: ActivityCategory.necessary,
    iconId: 65,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Idle',
    name: 'Idle',
    description: '',
    category: ActivityCategory.waste,
    iconId: 8,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Waiting',
    name: 'Waiting',
    description: '',
    category: ActivityCategory.waste,
    iconId: 62,
    count: 0,
  ),
];

const MOODS = [
  Activity(
    trackerId: 0,
    id: 'Happy',
    name: 'Happy',
    description: '',
    category: ActivityCategory.productive,
    iconId: 0,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Excited',
    name: 'Excited',
    description: '',
    category: ActivityCategory.productive,
    iconId: 2,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'At Peace',
    name: 'At Peace',
    description: '',
    category: ActivityCategory.productive,
    iconId: 63,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Doing Better',
    name: 'Doing Better',
    description: '',
    category: ActivityCategory.productive,
    iconId: 6,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Keeping Up',
    name: 'Keeping Up',
    description: '',
    category: ActivityCategory.productive,
    iconId: 7,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Busy',
    name: 'Busy',
    description: '',
    category: ActivityCategory.necessary,
    iconId: 18,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Okay',
    name: 'Okay',
    description: '',
    category: ActivityCategory.necessary,
    iconId: 9,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Down',
    name: 'Down',
    description: '',
    category: ActivityCategory.waste,
    iconId: 10,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Sad',
    name: 'Sad',
    description: '',
    category: ActivityCategory.waste,
    iconId: 1,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Anxious',
    name: 'Anxious',
    description: '',
    category: ActivityCategory.waste,
    iconId: 22,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Angry',
    name: 'Angry',
    description: '',
    category: ActivityCategory.waste,
    iconId: 4,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Stressed',
    name: 'Stressed',
    description: '',
    category: ActivityCategory.waste,
    iconId: 12,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Annoyed',
    name: 'Annoyed',
    description: '',
    category: ActivityCategory.waste,
    iconId: 3,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'Empty',
    name: 'Empty',
    description: '',
    category: ActivityCategory.waste,
    iconId: 70,
    count: 0,
  ),
  Activity(
    trackerId: 0,
    id: 'In Pain',
    name: 'In Pain',
    description: '',
    category: ActivityCategory.waste,
    iconId: 17,
    count: 0,
  ),
];

// List<Observation> OBSERVATIONS = [
//   Observation(
//     trackerId: 0,
//     id: 'obs1',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[0].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs2',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[0].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs3',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[0].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs4',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[0].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs5',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[0].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs6',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[0].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs7',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[1].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs8',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[1].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs9',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[1].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs10',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[1].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs11',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[2].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs12',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[2].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs13',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[3].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs14',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[4].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs15',
//     dateTime: DateTime.now(),
//     activityName: ACTIVITIES[5].name,
//     status: ObservationStatus.recorded,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs16',
//     dateTime: DateTime.now().add(const Duration(seconds: 10)),
//     activityName: null,
//     status: ObservationStatus.waiting,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs17',
//     dateTime: DateTime.now().add(const Duration(seconds: 30)),
//     activityName: null,
//     status: ObservationStatus.waiting,
//   ),
//   Observation(
//     trackerId: 0,
//     id: 'obs18',
//     dateTime: DateTime.now().add(const Duration(seconds: 50)),
//     activityName: null,
//     status: ObservationStatus.waiting,
//   ),
// ];
