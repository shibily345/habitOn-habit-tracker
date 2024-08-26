import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/config/default/widgets/text_fields.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/user_provider.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/data/model/habit_model.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/widgets.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/update_value.dart';
import 'package:provider/provider.dart';

class UpdateHabitPage extends StatefulWidget {
  const UpdateHabitPage({super.key, required this.habitData});
  final HabitEntity habitData;

  @override
  State<UpdateHabitPage> createState() => _UpdateHabitPageState();
}

class _UpdateHabitPageState extends State<UpdateHabitPage> {
  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.text = widget.habitData.name;
      context.read<HUProvider>().updateName(widget.habitData.name);
      context.read<HUProvider>().updateIcon(widget.habitData.icon);
      context.read<HUProvider>().updateColor(widget.habitData.color);
      context.read<HUProvider>().updateallDays(widget.habitData.days);
      context.read<HUProvider>().updateAllReminders(widget.habitData.reminders);
      context.read<HUProvider>().updateTimer(widget.habitData.timer);
      context.read<HUProvider>().updateDoneDates(widget.habitData.doneDates);

      context.read<HUProvider>().updateGoal(widget.habitData.goal);
      context.read<HUProvider>().updateStreak(widget.habitData.streak);
      context
          .read<HUProvider>()
          .updateRepeatPerDay(widget.habitData.repeatPerDay);
      context.read<HUProvider>().updateEndDate(widget.habitData.endDate);
      context.read<HUProvider>().updateEndByDays(widget.habitData.endByDays);
      context
          .read<HUProvider>()
          .updateTrackingData(widget.habitData.trackingData);
      context.read<HUProvider>().updateCategory(widget.habitData.category);
      context.read<HUProvider>().updateIsPaused(widget.habitData.isPaused);
      context.read<HUProvider>().updateCreatedAt(widget.habitData.createdAt);
      context.read<HUProvider>().updateUpdatedAt(widget.habitData.updatedAt);
      context.read<HUProvider>().updateHasEnd(widget.habitData.hasEnd);
      context
          .read<HUProvider>()
          .updateDescription(widget.habitData.description);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).user!.uid;
    final hup = context.watch<HUProvider>().habitData;

    HabitModel data = HabitModel(
      id: widget.habitData.id,
      name: hup.name,
      icon: hup.icon,
      color: hup.color,
      days: hup.days,
      repeatMode: hup.repeatMode,
      timer: hup.timer,
      doneDates: hup.doneDates,
      missedDates: hup.missedDates,
      goal: hup.goal,
      streak: hup.streak,
      reminders: hup.reminders,
      repeatPerDay: hup.repeatPerDay,
      endDate: hup.endDate,
      endByDays: hup.endByDays,
      trackingData: hup.trackingData,
      category: hup.category,
      isPaused: hup.isPaused,
      createdAt: hup.createdAt,
      updatedAt: DateTime.now(),
      hasEnd: hup.hasEnd,
      description: hup.description,
    );
    final List<String> allCategories = [
      'New Habit',
      'Health',
      'Fitness',
      'Productivity',
      'Education',
      'Hobbies',
      'Social',
      'Work',
      'Personal Development',
      'Finance',
      'Spirituality',
    ];
    var size = MediaQuery.of(context).size;
    var th = Theme.of(context);

    return Consumer<HUProvider>(
      builder: (context, hup, state) {
        return PopScope(
          onPopInvokedWithResult: (bool? didpop, Object? result) {
            hup.clearAll();
            print("worked");
          },
          child: Scaffold(
            appBar: _buildAppBar(context, userId, data),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const TextDef(
                  'Select a Icon',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SpaceY(20),
                const IconSelector(
                  availableIcons: <String>[
                    "assets/images/habits/1.png",
                    "assets/images/habits/2.png",
                    "assets/images/habits/3.png",
                    "assets/images/habits/4.png",
                    "assets/images/habits/5.png",
                    "assets/images/2.png",
                    "assets/images/3.png",
                    "assets/images/4.png",
                  ],
                ),
                const SpaceY(30),
                const TextDef(
                  'Name',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SpaceY(20),
                CustomTextField(
                  controller: nameController,
                  onChanged: (value) {
                    hup.updateName(value);
                  },
                ),
                const SpaceY(30),
                const TextDef(
                  'Color Theme',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SpaceY(20),
                const ColorSelector(),
                const SpaceY(30),
                ButtonDef(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      hup.updateReminders(pickedTime.toString());
                    }
                  },
                  things: const TextDef('Add Reminders'),
                ),
                const SpaceY(20),
                hup.habitData.reminders.isEmpty
                    ? const Text('No times selected')
                    : Wrap(
                        children: hup.habitData.reminders.map((time) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 10),
                            child: CustomContainer(
                              ontap: () {
                                hup.deleteReminders(time);
                              },
                              width: 110,
                              height: 30,
                              borderRadius: BorderRadius.circular(5),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextDef(
                                      time.substring(time.indexOf('(') + 1,
                                          time.indexOf(')')),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Icon(Icons.delete_outline_outlined)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                const SpaceY(30),
                const TextDef(
                  'Repeat Per Day',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SpaceY(20),
                TextDef(
                  '${hup.habitData.repeatPerDay} Times',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                Slider(
                  value: hup.habitData.repeatPerDay.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: hup.habitData.repeatPerDay.round().toString(),
                  onChanged: (double newValue) {
                    hup.updateRepeatPerDay(newValue.toInt());
                  },
                ),
                const TextDef(
                  'Repeat by Days',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SpaceY(20),
                DaySelector(),
                const SpaceY(30),
                const Text(
                  'Select Categories:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: allCategories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: hup.habitData.category.contains(category),
                      onSelected: (selected) {
                        hup.updateCategory(category);
                      },
                    );
                  }).toList(),
                ),
                const SpaceY(30),
                const TextDef(
                  'End',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          const Text('End By Date:'),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null &&
                                  pickedDate != hup.habitData.endDate) {
                                hup.updateEndDate(pickedDate);
                              }
                            },
                            child: Text(
                                hup.habitData.endDate == DateTime.utc(2030)
                                    ? 'Pick Date'
                                    : hup.habitData.endDate
                                        .toLocal()
                                        .toShortDateString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SpaceY(60),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String userId, HabitModel data) {
    return AppBar(
      title: const TextDef(
        "Update Habit",
        fontWeight: FontWeight.bold,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            context
                .read<HabitProvider>()
                .updateHabit(
                    userId: userId, habitId: data.id, updates: data.toMap())
                .then((value) async {
              Navigator.pushReplacementNamed(context, "/");
              context.read<HabitProvider>().scheduleAllRemindersForHabit(data);

              context.read<HUProvider>().clearAll();
            });
          },
          child: const TextDef("Update"),
        ),
      ],
    );
  }
}

extension DateFormatting on DateTime {
  String toShortDateString() {
    return "$day/$month/$year";
  }
}
