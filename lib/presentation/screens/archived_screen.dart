import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/business_logic/cubit/cubit.dart';
import 'package:todo/business_logic/cubit/states.dart';
import 'package:todo/presentation/widgets/sharedWidget.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: TaskCubit.get(context).archiveTaskmodel.length > 0,
              builder: (context) => ListView.separated(
                  itemBuilder: (context, index) => bulidtaskmodel(
                      TaskCubit.get(context).archiveTaskmodel[index], context),
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey,
                    );
                  },
                  itemCount: TaskCubit.get(context).archiveTaskmodel.length),
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
