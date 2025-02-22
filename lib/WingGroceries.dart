import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      home: ListScreen(),
    );
  }
}

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = (prefs.getStringList('items') ?? []);
    });
  }

  Future<void> _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', _items);
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _items.add(controller.text);
                });
                _saveList();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grocery List')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_items[index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
