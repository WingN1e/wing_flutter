import 'package:flutter/material.dart';

void main() {
  runApp(WareHouseApp());
}

class WareHouseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WarehouseGrid(),
    );
  }
}

class WarehouseGrid extends StatefulWidget {
  @override
  _WarehouseGridState createState() => _WarehouseGridState();
}

class _WarehouseGridState extends State<WarehouseGrid> {
  final int rows = 5;
  final int cols = 5;
  int robotRow = 2;
  int robotCol = 2;

  void moveUp() {
    setState(() {
      if (robotRow > 0) {
        robotRow--;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (robotRow < rows - 1) {
        robotRow++;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (robotCol > 0) {
        robotCol--;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (robotCol < cols - 1) {
        robotCol++;
      }
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robot Warehouse'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: 2.5,
              ), 
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                final row = index ~/ cols;
                final col = index % cols;
                return Container(
                  margin: EdgeInsets.all(2.0),
                  color: row == robotRow && col == robotCol
                    ? Colors.blue
                    : Colors.grey[300],
                  child: Center (
                    child: row == robotRow && col == robotCol 
                      ? Text (
                        'R',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                      ) 
                      : null,
                  ),
                );
              },
            ),
          ),
          Padding (
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: moveUp, 
                  child: Text('Up')
                ),
                ElevatedButton(
                  onPressed: moveLeft, 
                  child: Text('Left')
                ),
                ElevatedButton(
                  onPressed: moveRight, 
                  child: Text('Right')
                ),
                ElevatedButton(
                  onPressed: moveDown, 
                  child: Text('Down')
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}