import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class PersistedList extends StatefulWidget {
  PersistedList({
    Key key,
    this.title,
    this.itemType,
    this.example,
    this.listId,
    this.onTapItem,
  }) : super(key: key);

  final String title;
  final String itemType;
  final String example;
  final String listId;
  final void Function(String, String) onTapItem;

  @override
  _PersistedListState createState() => _PersistedListState();
}

class _PersistedListState extends State<PersistedList> {
  List<String> items = [];

  final newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => setState(() {
          var saved = prefs.getStringList(widget.listId);
          if (saved != null && saved.length > 0) {
            items = saved;
          }
          print(widget.title);
          print(widget.listId);
          print(items);
        }));
  }

  @override
  void dispose() {
    newItemController.dispose();
    super.dispose();
  }

  void _updateItems() {
    SharedPreferences.getInstance()
        .then((prefs) async => await prefs.setStringList(widget.listId, items));
  }

  // Add a new store
  void _showNewItemDialog() {
    newItemController.text = "";
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: newItemController,
                  decoration: new InputDecoration(
                    labelText: widget.itemType + ' Name',
                    hintText: 'e.g., ' + widget.example,
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                if (newItemController.text.length > 0) {
                  setState(() {
                    var rng = new Random();
                    items.add(newItemController.text + '~' + rng.nextDouble().toString());
                    _updateItems();
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _getName(String item)
  {
    if (item.contains('~')) {
      return item.split('~')[0];
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      widgets.add(SizedBox(
        key: ObjectKey(items[i]),
        child: Card(
          child: ListTile(
            title: Text(_getName(items[i])),
            onTap: () => widget.onTapItem(items[i], _getName(items[i])),
          ),
        ),
      ));
    }

    if (widgets.length == 0) {
      widgets.add(ListTile(
        title: Text('Add ' + widget.itemType + 's by Clicking the + Button'),
        key: Key('key'),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ReorderableListView(
        children: widgets,
        onReorder: (before, after) {
          if (after > items.length) after = items.length;
          if (before < after) after--;
          String data = items[before];
          items.removeAt(before);
          items.insert(after, data);
          _updateItems();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewItemDialog,
        tooltip: 'Add ' + widget.itemType,
        child: Icon(Icons.add),
      ),
    );
  }
}
