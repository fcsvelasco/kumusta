import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './view_activity_details.dart';
import './delete_activity.dart';
import '../styling/app_theme_data.dart';
import '../models/activity.dart';
import './add_activity_form.dart';

enum ActivityUnitMode {
  editing,
  viewing,
  recording,
  verify,
  showResults,
}

class ActivityUnit extends ConsumerWidget {
  const ActivityUnit({
    required this.activity,
    required this.mode,
    this.isSelected,
    this.selectActivity,
    this.unselectActivity,
    this.trackerId,
    Key? key,
  }) : super(key: key);

  final Activity activity;
  final ActivityUnitMode mode;
  final bool? isSelected;
  final Function? selectActivity;
  final Function? unselectActivity;
  final int? trackerId;

  void _startEditActivity(BuildContext context, Activity activity) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: AddActivityForm(
              hasStartedTracking: false,
              activity: activity,
            ),
          );
        });
  }

  void _startDeleteActivity(BuildContext context, Activity activity) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: DeleteActivity(
              activity: activity,
            ),
          );
        });
  }

  void _showActivityDetails(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: ViewActivityDetails(activity: activity),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int resultsRecordedObservations = 0;
    if (mode == ActivityUnitMode.showResults) {
      final activities = ref.read(resultsActivitiesProvider);
      for (final a in activities) {
        resultsRecordedObservations += a.count;
      }
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      color: mode == ActivityUnitMode.recording
          ? isSelected!
              ? Theme.of(context).primaryColor
              : null
          : null,
      child: ListTile(
        onTap: mode == ActivityUnitMode.recording
            ? () {
                if (isSelected!) {
                  unselectActivity!();
                } else {
                  selectActivity!(activity);
                }
              }
            : null,
        selected: isSelected ?? false,
        selectedColor: Colors.white,
        leading: Column(
          children: [
            Expanded(
              child: Icon(
                ICONS[activity.iconId],
                color: mode == ActivityUnitMode.recording
                    ? isSelected!
                        ? null
                        : Theme.of(context).accentColor
                    : Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
        title: Text(
          activity.name,
        ),
        subtitle: mode == ActivityUnitMode.showResults ||
                activity.description != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activity.description != '') Text(activity.description),
                  if (mode == ActivityUnitMode.showResults)
                    Text(resultsRecordedObservations > 0
                        ? 'Count: ${activity.count} out of $resultsRecordedObservations (${(100 * activity.count / resultsRecordedObservations).toStringAsFixed(1)}%)'
                        : 'Count: ${activity.count}'),
                ],
              )
            : null,
        trailing: mode == ActivityUnitMode.showResults ||
                mode == ActivityUnitMode.verify
            ? null
            : mode == ActivityUnitMode.editing
                ? Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    IconButton(
                        onPressed: () {
                          _startEditActivity(context, activity);
                        },
                        icon: Icon(
                          Icons.edit_rounded,
                          color: Theme.of(context).accentColor,
                        )),
                    IconButton(
                        onPressed: () {
                          _startDeleteActivity(context, activity);
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context).accentColor,
                        )),
                  ])
                : mode == ActivityUnitMode.viewing
                    ? IconButton(
                        onPressed: () => _showActivityDetails(context),
                        icon: Icon(
                          Icons.view_list_rounded,
                          color: Theme.of(context).accentColor,
                        ))
                    : null,
      ),
    );
  }
}
