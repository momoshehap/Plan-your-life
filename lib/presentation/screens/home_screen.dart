import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/business_logic/cubit/cubit.dart';
import 'package:todo/business_logic/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class HomeScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();

  TextEditingController titlectrl = TextEditingController();
  TextEditingController timectrl = TextEditingController();
  TextEditingController datectrl = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit()..createDB(),
      child: BlocConsumer<TaskCubit, TaskStates>(
        listener: (BuildContext context, TaskStates state) {
          if (state is InsertToDbState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, TaskStates state) => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.black87,
            centerTitle: true,
            title: Text(
              "Plan your Life",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black87,
            child: Icon(TaskCubit.get(context).floaticon),
            onPressed: () {
              if (TaskCubit.get(context).isBootomsheetshowen) {
                if (formkey.currentState!.validate()) {
                  TaskCubit.get(context)
                      .insertToDB(titlectrl.text, datectrl.text, timectrl.text)
                      .then((value) {
                    TaskCubit.get(context)
                        .changeBottomsheetButton(false, Icons.edit);
                  });
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet((context) => Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Task Title",
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: titlectrl,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Task Time",
                                      prefixIcon: Icon(
                                        Icons.watch_later_outlined,
                                      )),
                                  // keyboardType: TextInputType.datetime,
                                  controller: timectrl,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timectrl.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Task date",
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                      )),
                                  controller: datectrl,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2022-04-29"),
                                    ).then((value) {
                                      datectrl.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  TaskCubit.get(context)
                      .changeBottomsheetButton(false, Icons.edit);
                });

                TaskCubit.get(context).changeBottomsheetButton(true, Icons.add);
              }
            },
          ),
          body: ConditionalBuilder(
            condition: state is! GetDataFromDbLoadingState,
            builder: (context) => TaskCubit.get(context)
                .screens[TaskCubit.get(context).navBarindex],
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                color: Colors.red,
                semanticsLabel: "red",
                semanticsValue: "blue",
                strokeWidth: 8,
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            selectedFontSize: 18,
            type: BottomNavigationBarType.fixed,
            elevation: 50,
            currentIndex: TaskCubit.get(context).navBarindex,
            onTap: (index) {
              TaskCubit.get(context).changeNavBar(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: 'done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: 'Archived',
              )
            ],
          ),
        ),
      ),
    );
  }
}
