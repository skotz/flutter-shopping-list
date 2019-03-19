import 'package:flutter/material.dart';
import 'list.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StoresPage(),
    );
  }
}

class StoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersistedList(
      title: 'Shopping List',
      listId: 'stores',
      onTapItem: (listId, storeName) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemsPage(
                    title: storeName,
                    listId: listId,
                  ),
            ),
          ),
      itemType: 'Store',
      example: 'Pick \'n Save',
    );
  }
}

class ItemsPage extends StatefulWidget {
  ItemsPage({
    Key key,
    this.title,
    this.listId,
  }) : super(key: key);

  final String title;
  final String listId;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return PersistedList(
      title: widget.title,
      listId: widget.listId,
      onTapItem: (x, y) => print(x + ' - ' + y),
      itemType: 'Item',
      example: 'Broccoli',
    );
  }
}
