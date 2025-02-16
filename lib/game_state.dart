// game_state.dart
// Barrett Koster 2025
// copying a game I saw.
// This file 

import "dart:io";
// import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:path_provider/path_provider.dart";
import "box_state.dart";

class GameState
{ 
  String filename = "001.txt";

  // board is a list of lists that represent a
  // Row of Columns of letters representing the board.
  // raster coordinates, from upper left.
  // The robot may not travel the entire rectangle.
  // 'w' is for wall.  "g" is for goal. These do not move
  // in a single puzzle, but we allow for loading new puzzles.
  // i.e., they are not hard wired like squares on a monopoly board.
  // 'r' is for robot's initial position and 'b' is box
  // initial position.  One more thing: 'c' is both box
  // and goal.  's' is robot on the goal ('r' and 'g')
  List<List<String>> board = [];

  // note that the columns and rows are interchanged from 
  // the way they appear here.
  GameState() 
  : board = 
    [ [ 'w','w','w','w','w','w','w'],
      [ 'w',' ','r','b','g',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w',' ',' ',' ',' ',' ','w'],
      [ 'w','w','w','w','w','w','w'],
    ]
  ;

  GameState.loaded( this.board );
  GameState.loaded2( this.board, this.filename );
}

class GameCubit extends Cubit<GameState>
{
  GameCubit() : super( GameState() );

  GameCubit.loaded( List<List<String>> gs ) : super( GameState.loaded(gs) );

  void loadFromFile( String filename, BoxCubit bc ) async
  {
    List<List<String>> theBoard = await readFile( filename );
    // emit( GameState.loaded(theBoard) );
    emit( GameState.loaded2(theBoard,filename) );
    bc.reset( state.board );
  }

  void load(  BoxCubit bc ) async
  {
    List<List<String>> theBoard = await readFile( state.filename );
    emit( GameState.loaded(theBoard) );
    bc.reset( state.board );
  }

  Future<String> whereAmI() async
  {
    Directory mainDir = await getApplicationDocumentsDirectory();
    String mainDirPath = mainDir.path;
    // String mainDirPath = "/Users/bkoster/Documents/courses/USC/368/shared";
    // print("mainDirPath is $mainDirPath");
    return mainDirPath;
  }
  
  Future<List<List<String>>> readFile( String filename ) async
  { // await Future.delayed( const Duration(seconds:2) ); // adds drama
    String myStuff = await whereAmI();
    String filePath = "$myStuff/puzzles/$filename";
    File fodder = File(filePath);
    List<String> halfway = await fodder.readAsLines();
    List<List<String>> theBoard = [];
    for ( String line in halfway )
    { theBoard.add( line.split(' ') );
    }
    // print("----------------------- $theBoard");
    return theBoard;
  }
/*
  static Future<List<String>> dirList() async
  { List<String> theList = [];

    await Future.delayed( const Duration(seconds:2) );

    Directory mainDir = await getApplicationDocumentsDirectory();
    String puzzlePath = "${mainDir.path}/puzzles";
    theList = await Directory(puzzlePath).list().map((entry) => entry.path).toList();

    return theList;
  }
*/
}
