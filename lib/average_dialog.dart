import 'loading.dart';
import 'package:flutter/material.dart';
import 'grade_average.dart';
import 'dart:async';

class AverageDialog extends StatelessWidget {
  final bool add;

  AverageDialog(this.add);

  Future<List<Widget>> _buildAverageElements(context) async {
    List averages = await gradeAverageState.getAverages();
    var list = <Widget>[];
    for(var i = 0; i < averages.length; i++) {
      list.add(new SimpleDialogOption(
        child: new Row(
          children: <Widget>[
            new Text(
              averages[i]['name'],
              style: new TextStyle(
                fontSize: 18.0
              )
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context, averages[i]['id']);
        },
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _buildAverageElements(context),
      builder: (BuildContext context, future) => new SimpleDialog(
        title: new Text('Select Average'),
        children: <Widget>[
          new Divider(),
          new Column(
            children: <Widget>[
              new Column(
                children: _getMenu(future),
              ),
            ],
          ),
          add ? new Divider() : new Container(),
          add ? new SimpleDialogOption(
            child: new Row(
              children: <Widget>[
                new Icon(Icons.add),
                new Text(
                  ' Add Average',
                  style: new TextStyle(
                    fontSize: 18.0
                  )
                ),
              ],
            ),
            onPressed: () {
              Navigator.pop(context, -1);
            },
          ) : new Container(),
        ]
      ),
    ); 
  }

  _getMenu(future) {
    if(future.data == null) {
      return [new Loading()];
    } else {
      return future.data;
    }
  }
}

class AverageEditDialog extends StatefulWidget {
  final String _name;
  final bool _new;

  AverageEditDialog(this._name,this._new);

  @override
  State createState() => AverageEditDialogState(_name,_new);
}

class AverageEditDialogState extends State<AverageEditDialog> {
  String _name;
  bool _new;

  AverageEditDialogState(this._name,this._new);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(_name),
      content: new TextField(
        controller: new TextEditingController(
          text: _name,
        ),
        onChanged: (result) {
          _name = result;
        },
      ),
      actions: <Widget>[
        _new ? new Container() :
        new FlatButton(
          child: new Text('DELETE'),
          onPressed: () {
            Navigator.pop(context, {'name': _name, 'delete': true});
          },
        ),
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context, {'name': _name, 'delete': false});
          },
        ),
        new FlatButton(
          child: _new ? new Text('ADD') : new Text('UPDATE'),
          onPressed: () {
            Navigator.pop(context, {'name': _name,'delete': false});
          },
        ),
      ],
    );
  }
}