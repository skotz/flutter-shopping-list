import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorePage extends StatefulWidget {
  StorePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  // Stores saved by the user
  List<String> storeNames = [];

  final storeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => setState(() {
          var names = prefs.getStringList('storeNames');
          if (names != null && names.length > 0) {
            storeNames = names;
          }
        }));
  }

  @override
  void dispose() {
    storeNameController.dispose();
    super.dispose();
  }

  void _updateStores() {
    SharedPreferences.getInstance().then(
        (prefs) async => await prefs.setStringList('storeNames', storeNames));
  }

  // Add a new store
  void _showAddStoreDialog() {
    storeNameController.text = "";
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: storeNameController,
                  decoration: new InputDecoration(
                    labelText: 'Store Name',
                    hintText: 'eg. Pick \'n Save',
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
                if (storeNameController.text.length > 0) {
                  setState(() {
                    storeNames.add(storeNameController.text);
                    _updateStores();
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

  @override
  Widget build(BuildContext context) {
    var storeWidgets = <Widget>[];
    for (int i = 0; i < storeNames.length; i++) {
      storeWidgets.add(SizedBox(
        key: ObjectKey(storeNames[i]),
        child: Card(
          child: ListTile(
            title: Text(storeNames[i]),
          ),
        ),
      ));
    }

    if (storeWidgets.length == 0) {
      storeWidgets
          .add(ListTile(title: Text("Add stores by clicking the + button"), key: Key('key')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ReorderableListView(
        children: storeWidgets,
        onReorder: (before, after) {
          if (after > storeNames.length) after = storeNames.length;
          if (before < after) after--;
          String data = storeNames[before];
          storeNames.removeAt(before);
          storeNames.insert(after, data);
          _updateStores();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStoreDialog,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
