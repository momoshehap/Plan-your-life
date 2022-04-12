import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo/business_logic/cubit/states.dart';
import 'package:todo/presentation/screens/archived_screen.dart';
import 'package:todo/presentation/screens/doneTasks_screen.dart';
import 'package:todo/presentation/screens/newTasks_screen.dart';

class TaskCubit extends Cubit<TaskStates> {
  int navBarindex = 0;
  Database? dB;
  List<Map> newTaskmodel = [];
  List<Map> doneTaskmodel = [];
  List<Map> archiveTaskmodel = [];

  bool isBootomsheetshowen = false;
  IconData floaticon = Icons.edit;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedScreen(),
  ];
  TaskCubit() : super(TaskinitState());

  static TaskCubit get(context) => BlocProvider.of(context);

  void createDB() {
    var databasesPath = getDatabasesPath();
    String path = '${databasesPath}todo.db';
    openDatabase(
      path,
      version: 1,
      onCreate: (dB, version) async {
        await dB
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT, status TEXT)')
            .then((value) {
          print('db is created');
        }).catchError((e) {
          print('error when db is created');
        });
      },
      onOpen: (dB) {
        getDatafromDB(dB);
      },
    ).then((value) {
      dB = value;
      emit(CreateDbState());
    });
  }

  insertToDB(String title, String date, String time) async {
    await dB?.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks (title, date, time,status) VALUES(?, ?, ?,?)',
          [title, date, time, 'new']).then((value) {
        emit(InsertToDbState());
        getDatafromDB(dB!);

        print('$value inserted succsessfuly');
      }).catchError((erorr) {
        print('$erorr inserted faild');
      });
    });
  }

  void getDatafromDB(Database dataBase) async {
    newTaskmodel = [];
    doneTaskmodel = [];
    archiveTaskmodel = [];
    return await dataBase.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTaskmodel.add(element);
        } else if (element['status'] == 'done') {
          doneTaskmodel.add(element);
        } else {
          archiveTaskmodel.add(element);
        }
        emit(GetDataFromDbState());
      });
    });
    // List<Map> expectedList = [
    //   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
    //   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    // ];
    // print(list);
    // print(expectedList);
// assert(const DeepCollectionEquality().equals(list, expectedList));
  }

  void upDateDatafromDb(String status, int id) {
    dB!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(UpdateDataToDbState());
      getDatafromDB(dB!);
    });
  }

  void deleteDatafromDb(int id) async {
    await dB!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(DeleteDatafromDbState());
      getDatafromDB(dB!);
    });
  }

  void changeNavBar(int index) {
    navBarindex = index;
    emit(ChangeBottomNavebarState());
  }

  void changeBottomsheetButton(bool isShow, IconData icon) {
    isBootomsheetshowen = isShow;
    floaticon = icon;
    emit(ChangeBottomsheetButtonState());
  }
}
