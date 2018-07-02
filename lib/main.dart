import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './grade_average.dart';
import './gpa_calculator.dart';
import './settings.dart';
import './utils/auth.dart';
import 'loading.dart';
import 'dart:async';

double version = 0.5;
bool average = true;

void main() {
  runApp(new GrAdeApp());
}

class GrAdeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'GrAde',
      home: new MainView(),
      routes: <String, WidgetBuilder> {
        '/settings': (BuildContext context) => new Settings(),
      },
    );
  }
}

class MainView extends StatefulWidget {
  @override
  State createState() => new MainViewState();
}


class MainViewState extends State<MainView> {
  GradeAverage gradeAverage;
  GPACalculator gpaCalculator;
  Widget _page = new Loading();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    signInWithGoogle(false).then((result) {
      gradeAverage =  new GradeAverage(new Key(userID), userID);
      gpaCalculator = new GPACalculator();
      _changePage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('GrAde'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          average ? new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              openAverageEditDialog(context);
            },
          ) : new Container(),
          average ? new IconButton(
            icon: new Icon(Icons.subject),
            onPressed: () {
              openAverageDialog(context);
            },
          ) : new Container(),
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              openSettings();
            }),
        ],
      ),
      body: _page,
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          new BottomNavigationBarItem(icon: new Icon(Icons.timeline), title: new Text('Average')),
          new BottomNavigationBarItem(icon: new Icon(Icons.school), title: new Text('GPA')),
        ],
        fixedColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: _changePage,
      ),
      floatingActionButton: new GradeAverageFAB(),
    );
  }

  void openSettings() async {
    await Navigator.of(context).pushNamed('/settings');
    _updateUser();
  }

  void _changePage(int index) {
    setState(() {
      if(index == 0) {
        _page = gradeAverage;
        _currentIndex = 0;
        average = true;
      } else {
        _page = gpaCalculator;
        _currentIndex = 1;
        average = false;
      }
    });
  }

  void _updateUser() {
    setState(() {
      if(_currentIndex == 0) {
        _page = new GradeAverage(new Key(userID),userID);
        _currentIndex = 0;
        average = true;
      } else {
        _page = new GPACalculator();
        _currentIndex = 1;
        average = false;
      }
    });
  }
}