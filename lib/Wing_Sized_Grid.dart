// sized_grid_prep.dart
// Wing Nie 2025
// lab
// let user enter 2D grid size, make grid that size

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SizedGridState {
  final int width;
  final int height;

  SizedGridState ({required this.width, required this.height});
}

class SizedGridCubit extends Cubit<SizedGridState> {
  SizedGridCubit() : super(SizedGridState(width: 4, height: 3));

  void SetWidth(int width) => emit(SizedGridState(width: width, height: state.height));
  void SetHeight(int height) => emit(SizedGridState(width: state.width, height: height));
}

void main() { 
  runApp( BlocProvider(
    create: (context) => SizedGridCubit(),
    child: SG(),
  )); 
}

class SG extends StatelessWidget
{
  SG({super.key});

  @override

  Widget build( BuildContext context )
  {
    return MaterialApp
    ( title: "sized grid prep",
      home: SG1(),
    );
  }
}

class SG1 extends StatelessWidget
{
  SG1({super.key});

  @override

  Widget build( BuildContext context )
  { 
    return Scaffold ( 
      appBar: AppBar(title: Text("Sized Grid")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Width: "),
              SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    int? newWidth = int.tryParse(value);
                    if (newWidth != null) {
                      context.read<SizedGridCubit>().SetWidth(newWidth);
                    }
                  },
                ),
              ),
              Text(" Height: "),
              SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    int? newHeight = int.tryParse(value);
                    if (newHeight != null) {
                      context.read<SizedGridCubit>().SetHeight(newHeight);
                    }
                  },
                ),
              )
            ],
          ),
          BlocBuilder<SizedGridCubit, SizedGridState> (
            builder: (context, state) {
              return Column(
                children: [
                  Text("before the grid"),
                  buildGrid(state.width, state.height),
                  Text("after the grid"),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildGrid(int width, int height) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(width, (i) {
        return Column(
          children: List.generate(height, (j) => Boxy(40, 40)),
        );
      }),
    );
  }
}



class Boxy extends Padding
{
  final double width;
  final double height;
  Boxy( this.width,this.height ) 
  : super
    ( padding: EdgeInsets.all(4.0),
      child: Container
      ( width: width, height: height,
        decoration: BoxDecoration
        ( border: Border.all(), ),
        child: Text("x"),
      ),
    );
}
