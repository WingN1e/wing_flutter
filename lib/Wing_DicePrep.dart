// DicePrep.dart

// Wing Nie
// Your Name Here (replace mine, this is just demos
// of stuff anyone can use).

import "dart:math";

import "package:flutter/material.dart";

void main() // 23
{
  runApp(Yahtzee());
}

class Yahtzee extends StatelessWidget
{
  Yahtzee({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "yahtzee",
      home: YahtzeeHome(),
    );
  }
}

class YahtzeeHome extends StatefulWidget
{
  @override
  State<YahtzeeHome> createState() => YahtzeeHomeState();
}

class YahtzeeHomeState extends State<YahtzeeHome>
{
  List<int> diceNumbers = List.generate(5, (_)=>1);

  void rollDice() {
    setState(() {
      diceNumbers = List.generate(5, (_)=> Random().nextInt(6) + 1);
    });
  }

  @override
  Widget build( BuildContext context )
  { return Scaffold
    ( 
      appBar: AppBar(
        title: const Text("yahtzee"),
      ),
      backgroundColor: Colors.purple,
      body: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: diceNumbers
              .map((number) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$number",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
              .toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: rollDice, 
            child: const Text(
              "Roll Dice",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

