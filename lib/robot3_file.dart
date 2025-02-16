// robot3_file.dart
// Barrett Koster
// This version of Robot is supposed to
// read a puzzle file to start.  

// 1. detect when you have succeeded
// 2. reset to try again
// 3. move counter?

import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:path_provider/path_provider.dart";

import "game_state.dart";
import "box_state.dart";
import "boxy.dart";


void main() 
{ 
 runApp(Robot());
}

  Future<List<String>> dirList() async
  { List<String> theList = [];

    // await Future.delayed( const Duration(seconds:2) );

    Directory mainDir = await getApplicationDocumentsDirectory();
    String puzzlePath = "${mainDir.path}/puzzles";
    theList = await Directory(puzzlePath).list().map((entry) => entry.path).toList();

    return theList;
  }

class Robot extends StatelessWidget
{ 
  Robot({super.key});

  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: "robot",
      home: BlocProvider<GameCubit>
      ( create: (context) => GameCubit(),
        child: BlocBuilder<GameCubit,GameState>
        ( builder: (context, gstate) =>
          BlocProvider<BoxCubit>
          ( create: (context) => BoxCubit( gstate.board ),
            child: BlocBuilder<BoxCubit,BoxState>
            ( builder: (context,bstate) => Robot2(),
            ),
          ),
        ),
      ),
    );
  }
}

class Robot2 extends StatelessWidget
{ 
  Robot2({super.key});

  @override
  Widget build( BuildContext context )
  {
    GameCubit gc = BlocProvider.of<GameCubit>(context);
    GameState gs = gc.state;
    BoxCubit  bc = BlocProvider.of<BoxCubit>(context);
    BoxState  bs = bc.state;
    int sizeX = gs.board.length;
    int sizeY = gs.board[0].length;

    // translate the two states (GameState.board and BoxState.boxes)
    // into visual grid, Rows and Columns of Boxys.
    // Note: we are using the letter code in game_state.dart
    // to show what is what.  It would be better to show it as
    // colors, wall=black, robot=red, goal as a border?
    Row theGrid = Row(children:[]);
    for ( int i=0; i<sizeX; i++ )
    { Column c = Column(children:[]);
      for ( int j=0; j<sizeY; j++ )
      { String letter = " ";
        String glet = gs.board[i][j];
        String blet = bs.boxes[i][j];
        if ( glet=="w" ) { letter = "w"; } // wall is wall
        else if ( glet == "g" || glet=="c" || glet=="s" ) 
        { // goal, must check if robot or box is on top
          letter = "g";
          if      (blet=="r") { letter = "s"; } 
          else if (blet=="b") { letter = "c"; }
        }
        else // board is just blank, so show robot or box
        {
          if      (blet=="r") { letter = "r"; } 
          else if (blet=="b") { letter = "b"; }
        }
        c.children.add( Boxy(40,40, letter)  );
      }
      theGrid.children.add(c);
    }

    return Scaffold
    ( appBar: AppBar(title:Text("Robot")),
      body: Column
      ( children:
        [ loadGameButton( gc, bc ),
          theGrid,
          Row
          ( children: 
            [ moveButton("up",0,-1, context),
              moveButton("left",-1,0, context),
              moveButton("right",1,0, context),
              moveButton("down",0,1, context),
            ]
          ),
        ],
      ),
    );
  }

  // FloatingActionButton 
  Row loadGameButton( GameCubit gc, BoxCubit bc )
  { // print("gs------ ${gc.state.board}");
    return Row
    ( children:
      [     DropdownButton<String>
            (
              value: gc.state.filename, // "001.txt",
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              items: ["001.txt","002.txt",]
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (value) { gc.loadFromFile(value!,bc); },
            ),
        FloatingActionButton // obviated by dropdown
        ( onPressed: ()
          { String filename =  gc.state.filename; // "001.txt";
            gc.loadFromFile( filename, bc );
            // bc.reset( gc.state.board ); does not work here first time.
            // gc.loadFromFile is async, so this bc plows ahead without
            // new stuff.  Do it from inside gc.loadFromFile after waiting
            // for the board to load from the file.
          },
          child: Text("load", style:TextStyle(fontSize:20)),
        ),
      ],
    );
  }

  // return a button with the 'what' as the label that moves
  // the robot deltaX,deltaY. Neds context to access state.
  FloatingActionButton moveButton
  ( String what, int deltaX, int deltaY,
    BuildContext context
  )
  { return FloatingActionButton
    ( onPressed: ()
      { 
        GameCubit gc = BlocProvider.of<GameCubit>(context);
        GameState gs = gc.state;
        BoxCubit  bc = BlocProvider.of<BoxCubit>(context);
        BoxState  bs = bc.state;
        int sizeX = gs.board.length;
        int sizeY = gs.board[0].length;

        // find the robot
        Coords robotAt = Coords(1,1);
        bool found = false;
        for ( int i=0; !found && i<sizeX; i++ )
        { for ( int j=0; !found && j<sizeY; j++ )
          { if (bs.boxes[i][j]=="r")
            { robotAt = Coords(i,j); found = true; }
          }
        }

        // compute next cell and one after that
        Coords b1 = robotAt.bump( deltaX, deltaY );
        Coords b2 =       b1.bump( deltaX, deltaY );

        // if next cell is open, just move
        if (gs.board[b1.x][b1.y]!="w" && bs.boxes[b1.x][b1.y]==" ")
        { bs.boxes[robotAt.x][robotAt.y] = " ";
          bs.boxes[b1.x][b1.y] = "r";
          bc.update(bs.boxes);
        }
        // else if next cell is box and the one after is open, push
        else if (   bs.boxes[b1.x][b1.y]=="b"
                 && gs.board[b2.x][b2.y]!="w" 
                 && bs.boxes[b2.x][b2.y]==" "
                )
        { bs.boxes[robotAt.x][robotAt.y] = " ";
          bs.boxes[b1.x][b1.y] = "r";
          bs.boxes[b2.x][b2.y] = "b";
          bc.update(bs.boxes);
        }
      },
      child: Text(what),
    );
  }
}

class Coords
{
  int x;
  int y;

  Coords( this.x, this.y );

  // return true if this Coords is the same as c
  bool equals( Coords c )
  { return c.x == x && c.y == y;
  }

  // sets this coords to C (but keeps the same object)
  void set( Coords  c )
  { x = c.x;
    y = c.y;
  }

  // return a Coords which is one over in the give direction
  Coords bump(int deltaX, int deltaY)
  {
    Coords d = Coords(x,y);
    d.x += deltaX;
    d.y += deltaY;
    return d;
  }
}



