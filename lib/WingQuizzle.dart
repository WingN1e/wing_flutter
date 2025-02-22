import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => QuizCubit()..loadQuestions(),
        child: const QuizScreen(),
      ),
    );
  }
}

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizLoading());

  final Map<String, String> questions = {};
  int currentIndex = 0;
  int score = 0;
  List<String> states = [];

  Future<void> loadQuestions() async {
    try {
      final file = File('/Users/wing/Desktop/test31/lib/StateCapitols.txt'); //Change file path here
      final lines = await file.readAsLines();
      for (var line in lines.skip(1)) {
        final parts = line.split(',');
        if(parts.length == 2) {
          questions[parts[0].trim()] = parts[1].trim();
        }
      }

      states = questions.keys.toList();
      states.shuffle(Random());
      emit(QuizLoaded(states[currentIndex], score, questions.length));
    } catch (e) {
      emit(QuizError('Failed to load questions: $e'));
    }
  }

  void checkAnswers(String answer) {
    if(questions[states[currentIndex]]!.toLowerCase() == answer.toLowerCase()) {
      score++;
      emit(QuizFeedBack(true, states[currentIndex], score, questions.length));
    } else {
      emit(QuizFeedBack(false, states[currentIndex], score, questions.length));
    }
    Future.delayed(const Duration(seconds: 1), nextQuestion);
  }

  void nextQuestion() {
    currentIndex++;
    if (currentIndex < states.length) {
      emit(QuizLoaded(states[currentIndex], score, questions.length));
    } else {
      emit(QuizComplete(score, questions.length));
    }
  }
}

abstract class QuizState{}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final String state;
  final int score;
  final int total;
  QuizLoaded(this.state, this.score, this.total);
}

class QuizFeedBack extends QuizState {
  final bool isCorrect;
  final String state;
  final int score;
  final int total;
  QuizFeedBack(this.isCorrect, this.state, this.score, this.total);
}

class QuizComplete extends QuizState {
  final int score;
  final int total;
  QuizComplete(this.score, this.total);
}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizError) {
            return Center(child: Text(state.message));
          } else if (state is QuizLoaded) {
            return QuizQuestion(state);
          } else if (state is QuizFeedBack) {
            return QuizFeedBackScreen(state);
          } else if (state is QuizComplete) {
            return QuizCompletionScreen(state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class QuizQuestion extends StatelessWidget {
  final QuizLoaded state;
  QuizQuestion(this.state);

  final TextEditingController controller = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('What is the capital of ${state.state}?',
          style: const TextStyle(fontSize: 24)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(controller: controller),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<QuizCubit>().checkAnswers(controller.text);
          }, 
          child: const Text('Submit'),
        ),
        Text('Score: ${state.score}/${state.total}'),
      ],
    );
  }
}
  
class QuizFeedBackScreen extends StatelessWidget {

  final QuizFeedBack state;
  QuizFeedBackScreen(this.state);

  @override
  Widget build(BuildContext context) {
    return Center (
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.isCorrect ? 'Correct!' : 'Wrong!',
            style: TextStyle(fontSize: 24, color: state.isCorrect ? Colors.green : Colors.red),
          ),
          Text('Score: ${state.score}/${state.total}'),
        ],
      ),
    );
  }
}

class QuizCompletionScreen extends StatelessWidget {
  final QuizComplete state;
  QuizCompletionScreen(this.state);

  @override
  Widget build(BuildContext context) {
   return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Quiz Complete!', style: const TextStyle(fontSize: 24)),
        Text('Final Score: ${state.score}/${state.total}'),
      ],
    ),
   ); 
  }

}