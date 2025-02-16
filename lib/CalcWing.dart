import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

//Main application widget that sets up the app structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => ConversionBloc(),
        child: ConversionScreen(),
      ),
    );
  }
}

//The enum defines the different types of conversions available
enum ConversionType { fahrenheitToCelsius, celsiusToFahrenheit, poundsToKg, kgToPounds }

//This Bloc is what handles the conversion logic and state management
class ConversionBloc extends Cubit<String> {
  ConversionBloc() : super('');

  // Performs the conversion based on the selected type and updates the type
  void convert(String input, ConversionType type) {
    double? value = double.tryParse(input);
    if (value == null) {
      emit('Invalid input');
      return;
    }

    double result;
    switch (type) {
      case ConversionType.fahrenheitToCelsius:
        result = (value - 32) * 5 / 9;
        emit('$value °F = ${result.toStringAsFixed(2)} °C');
        break;
      case ConversionType.celsiusToFahrenheit:
        result = (value * 9 / 5) + 32;
        emit('$value °C = ${result.toStringAsFixed(2)} °F');
        break;
      case ConversionType.poundsToKg:
        result = value * 0.453592;
        emit('$value lb = ${result.toStringAsFixed(2)} kg');
        break;
      case ConversionType.kgToPounds:
        result = value / 0.453592;
        emit('$value kg = ${result.toStringAsFixed(2)} lb');
        break;
    }
  }
}


//This widget represents the UI for the unit converter
class ConversionScreen extends StatefulWidget {
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  String input = '';
  ConversionType selectedType = ConversionType.fahrenheitToCelsius;

  void onKeyPress(String value) {
    setState(() {
      if (value == 'Clear') {
        input = '';
      } else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else {
        input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(title: Text('Unit Converter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Input: $input', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            BlocBuilder<ConversionBloc, String>(
              builder: (context, result) {
                return Text(result, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
              },
            ),
            SizedBox(height: 20),
            DropdownButton<ConversionType>(
              value: selectedType,
              items: ConversionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last.replaceAll('To', ' to ')),
                );
              }).toList(), 
              onChanged: (newType) {
                setState(() {
                  selectedType = newType!;
                });
              }
            ),
            SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: ['1','2','3','4','5','6','7','8','9','0','.','-','⌫', 'C'].map((key) {
                return ElevatedButton(
                  onPressed: () => onKeyPress(key), 
                  child: Text(key, style: TextStyle(fontSize: 24)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<ConversionBloc>().convert(input, selectedType), 
              child: Text('Convert', style: TextStyle(fontSize: 24)),
            )
          ],
        ),
      ),
    );
  }
}
