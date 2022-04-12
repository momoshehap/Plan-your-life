import 'package:flutter/material.dart';
import 'package:todo/business_logic/cubit/cubit.dart';

Widget bulidtaskmodel(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      TaskCubit.get(context).deleteDatafromDb(model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 40,
                child: Text("${model['time']}"),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${model['date']}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  TaskCubit.get(context).upDateDatafromDb("done", model['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.amber,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  TaskCubit.get(context)
                      .upDateDatafromDb("archived", model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black45,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  TaskCubit.get(context).deleteDatafromDb(model['id']);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
