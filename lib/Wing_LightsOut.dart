import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

void main() {
  runApp( BlocProvider(
      create: (context) => LightsCubit(5),
      child: LightsApp(),
    )); 
}

class LightsCubit extends Cubit<List<bool>> {
  LightsCubit(int n) : super(List.generate(n, (_) => Random().nextBool()));

  void toggleLight(int index) {
    List<bool> newState = List.from(state);
    newState[index] = !newState[index];
    if (index > 0) newState[index - 1] = !newState[index - 1];
    if (index < newState.length - 1) newState[index + 1] = !newState[index + 1];
    emit(newState);
  }

  void setLights(int n) {
    emit(List.generate(n, (_) => Random().nextBool()));
  }
}

class LightsApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Lights Out")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("N: "),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      int? newN = int.tryParse(value);
                      if (newN != null && newN > 0) {
                        context.read<LightsCubit>().setLights(newN);
                      }
                    },
                  ),
                )
              ],
            ),
            BlocBuilder<LightsCubit, List<bool>>( 
              builder: (context, lights) {
                bool allOff = lights.every((light) => !light);
                return Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        lights.length,
                        (index) => GestureDetector(
                          onTap: () => context.read<LightsCubit>().toggleLight(index),
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: lights[index] ? Colors.yellow : Colors.grey,
                              border: Border.all(),
                            ),
                          ),
                        )
                      )
                    )
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}