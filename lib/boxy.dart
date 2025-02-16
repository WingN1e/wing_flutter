
import "package:flutter/material.dart";

class Boxy extends Padding
{
  final double width;
  final double height;
  final String letter;

  Boxy( this.width,this.height, this.letter ) 
  : super
    ( padding: EdgeInsets.all(4.0),
      child: Container
      ( width: width, height: height,
        decoration: BoxDecoration
        ( border: Border.all
          ( width:(letter=="c" || letter=="s" || letter=="g" ? 4:1 ),
          ), 
          color: ( letter=="r" || letter=="s" )
                 ? Colors.red
                 : letter=="w"
                   ? Colors.black
                   : ( letter=="b" || letter=="c" )
                     ? Colors.blue : Colors.white,
        ),
        child: Text(""),
      ),
    );
}
