import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/database_helper.dart';
import './choose_icon_form.dart';
import '../../models/tracker.dart';
import '../../styling/page_heading.dart';
import '../../styling/app_theme_data.dart';
import '../../models/activity.dart';

class AddActivityForm extends ConsumerStatefulWidget {
  AddActivityForm({
    required this.hasStartedTracking,
    this.activity,
    Key? key,
  }) : super(key: key);

  Activity? activity;
  bool hasStartedTracking;

  @override
  ConsumerState<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends ConsumerState<AddActivityForm> {
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  ActivityCategory? _category;
  bool _isForEditing = false;
  int _selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.activity == null) {
      _isForEditing = false;
      _selectedIconIndex = 0;
      widget.activity = Activity(
        trackerId: ref.read(trackerProvider).id,
        id: DateTime.now().toIso8601String() +
            Random().nextInt(1000).toString(),
        name: '',
        description: '',
        category: ActivityCategory.uncategorized,
        iconId: 0,
        count: 0,
      );
      if (ref.read(trackerProvider).isActivitiesCategorized) {
        _category = ActivityCategory.productive;
      } else {
        _category = ActivityCategory.uncategorized;
      }
    } else {
      _selectedIconIndex = widget.activity!.iconId;
      _isForEditing = true;
      _category = widget.activity!.category;
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _unfocusNodes() {
    _nameFocusNode.unfocus();
    _descriptionFocusNode.unfocus();
  }

  void _startEditIcon() {
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return const ChooseIconForm();
      }),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedIconIndex = value;
        });
      }
    });
  }

  void showSnackBar(TrackerMode trackerMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      MySnackBar(
        context: context,
        child: Text(
          trackerMode == TrackerMode.activitySampling
              ? _isForEditing
                  ? 'Activity saved!'
                  : 'Activity added!'
              : _isForEditing
                  ? 'Mood saved!'
                  : 'Mood added!',
        ),
      ),
    );
  }

  void saveForm(TrackerMode trackerMode) async {
    //final _activities = ref.watch(activitiesProvider);
    final activitiesNotifier = ref.read(activitiesProvider.notifier);
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    widget.activity = widget.activity!.copyWith(category: _category);

    if (_isForEditing) {
      activitiesNotifier.updateActivity(
        trackerId: ref.read(trackerProvider).id,
        id: widget.activity!.id,
        name: widget.activity!.name,
        description: widget.activity!.description,
        iconId: _selectedIconIndex,
        category: widget.activity!.category,
      );
      Navigator.of(context).pop();
      showSnackBar(trackerMode);
    } else {
      final newActivity = Activity(
        trackerId: ref.read(trackerProvider).id,
        id: widget.activity!.id,
        name: widget.activity!.name,
        description: widget.activity!.description,
        category: widget.activity!.category,
        iconId: _selectedIconIndex,
        count: 0,
      );
      activitiesNotifier.addActivity(newActivity);
      if (widget.hasStartedTracking) {
        DatabaseHelper.instance.insertActivity(newActivity).then((value) {
          showSnackBar(trackerMode);
        });
        Navigator.pop(context, newActivity);
      } else {
        showSnackBar(trackerMode);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tracker = ref.watch(trackerProvider);
    final trackerMode = tracker.trackerMode;

    return Form(
      key: _form,
      autovalidateMode: AutovalidateMode.always,
      child: ThemedFormContainer(
        height: tracker.isActivitiesCategorized
            ? mq.size.height * 0.62
            : mq.size.height * 0.4,
        width: mq.size.width * 0.8,
        child: Stack(
          children: [
            ListView(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: PageHeading(
                        pageTitle: trackerMode == TrackerMode.activitySampling
                            ? _isForEditing
                                ? 'Edit Activity'
                                : 'Add Activity'
                            : _isForEditing
                                ? 'Edit Mood'
                                : 'Add Mood')),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextFormField(
                    initialValue: _isForEditing ? widget.activity!.name : null,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onEditingComplete: () {
                      _nameFocusNode.unfocus();
                    },
                    focusNode: _nameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input name';
                      }
                      if (value.length > Activity.maxActivityNameLength) {
                        return 'Name is too long.';
                      }
                      if (!_isForEditing ||
                          (_isForEditing && value != widget.activity!.name)) {
                        if (ref.watch(activitiesProvider).indexWhere(
                                (element) => element.name == value) !=
                            -1) {
                          return 'Name already taken.';
                        }
                        return null;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.activity = widget.activity!.copyWith(name: value);
                    },
                  ),
                  trailing: InkWell(
                    onTap: () {
                      _unfocusNodes();
                      _startEditIcon();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        //color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Icon(
                        ICONS[_selectedIconIndex],
                        color: Theme.of(context).accentColor,
                        //size: 60,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  initialValue: _isForEditing
                      ? widget.activity!.description == ''
                          ? null
                          : widget.activity!.description
                      : null,
                  decoration: const InputDecoration(
                      labelText: 'Description (optional)'),
                  focusNode: _descriptionFocusNode,
                  onEditingComplete: () {
                    _descriptionFocusNode.unfocus();
                  },
                  validator: (value) {
                    if (value != null &&
                        value.length > Activity.maxDescriptionLength) {
                      return 'Description is too long.';
                    }
                  },
                  onSaved: (value) {
                    widget.activity =
                        widget.activity!.copyWith(description: value);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (tracker.isActivitiesCategorized)
                  Text(
                    'Choose Category:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                if (tracker.isActivitiesCategorized)
                  ListTile(
                    title: Text(trackerMode == TrackerMode.activitySampling
                        ? 'Productive'
                        : 'Positive'),
                    leading: Radio<ActivityCategory>(
                      groupValue: _category,
                      value: ActivityCategory.productive,
                      onChanged: (val) {
                        setState(() {
                          _category = val;
                        });
                        _unfocusNodes();
                      },
                    ),
                  ),
                if (tracker.isActivitiesCategorized)
                  ListTile(
                    title: Text(trackerMode == TrackerMode.activitySampling
                        ? 'Necessary'
                        : 'Neutral'),
                    leading: Radio<ActivityCategory>(
                      groupValue: _category,
                      value: ActivityCategory.necessary,
                      onChanged: (val) {
                        setState(() {
                          _category = val;
                        });
                        _unfocusNodes();
                      },
                    ),
                  ),
                if (tracker.isActivitiesCategorized)
                  ListTile(
                    title: Text(trackerMode == TrackerMode.activitySampling
                        ? 'Waste'
                        : 'Negative'),
                    leading: Radio<ActivityCategory>(
                      groupValue: _category,
                      value: ActivityCategory.waste,
                      onChanged: (val) {
                        setState(() {
                          _category = val;
                        });
                        _unfocusNodes();
                      },
                    ),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ThemedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ThemedButton(
                        child: _isForEditing
                            ? const Text('Save')
                            : const Text('Add'),
                        onPressed: () {
                          saveForm(trackerMode);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
