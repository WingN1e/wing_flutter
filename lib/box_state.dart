import "package:flutter_bloc/flutter_bloc.dart";

class BoxState
{ // same size rectangular grid as board.  raster coordinates.
  // This one has just 'b' for box and 'r' for 
  // robot.  This state changes as you play.
  List<List<String>> boxes = [];

  // takes the game state letter list-grid and extracts just
  // the box and robot info.
  BoxState.first( List<List<String>> gs )
  { boxes = [];
    int sizeX = gs.length;
    int sizeY = gs[0].length;

    for ( int i=0; i<sizeX; i++ )
    { List<String> c = [];
      for ( int j=0; j<sizeY; j++ )
      { String glet = gs[i][j];
        String letter = " ";
        if      (glet=="r" || glet=="s") { letter = "r"; }
        else if (glet=="b" || glet=="c") { letter = "b"; }
        else                             { letter = " "; }
        c.add(letter);
      }
      boxes.add(c);
    }
    // print("gs ----------- $boxes");
  }

  // This constructor is for playing the game.  We give it 
  // a new position grid, just install it.
  BoxState.update( this.boxes );
}

class BoxCubit extends Cubit<BoxState>
{
  BoxCubit( List<List<String>> gs ) : super( BoxState.first( gs) );

  void update(List<List<String>> bs ) 
  { emit( BoxState.update(bs) ); }

  void reset( List<List<String>> gs )
  { emit( BoxState.first(gs) ); }
}