// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/business_logic/cubit/cubit.dart';
import 'package:todo/business_logic/cubit/states.dart';

import '../widgets/sharedWidget.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: TaskCubit.get(context).newTaskmodel.length > 0,
              builder: (context) => ListView.separated(
                  itemBuilder: (context, index) => bulidtaskmodel(
                      TaskCubit.get(context).newTaskmodel[index], context),
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey,
                    );
                  },
                  itemCount: TaskCubit.get(context).newTaskmodel.length),
              fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const Text(
                          "No Tasks Yet, Please Add Some Tasks",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ));
        });
  }
}
