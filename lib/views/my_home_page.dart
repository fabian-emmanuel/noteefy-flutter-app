import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing Bloc'),
        ),
        body:
            BlocConsumer<CounterBloc, CounterState>(builder: (context, state) {
          final invalidValue =
              (state is InvalidCounterState) ? state.invalidValue : '';
          return Column(
            children: [
              Text('Current Value => ${state.value}'),
              Visibility(
                child: Text('Invalid input => $invalidValue'),
                visible: state is InvalidCounterState,
              ),
              TextField(
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: 'Enter a number here...:'),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      },
                      child: const Icon(Icons.west)),
                  TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      },
                      child: const Icon(Icons.add)),
                ],
              )
            ],
          );
        }, listener: (context, state) {
          _controller.clear();
        }),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class ValidCounterState extends CounterState {
  const ValidCounterState(int value) : super(value);
}

class InvalidCounterState extends CounterState {
  final String invalidValue;
  const InvalidCounterState(
      {required this.invalidValue, required int previousValue})
      : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const ValidCounterState(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(InvalidCounterState(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(ValidCounterState(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(InvalidCounterState(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(ValidCounterState(state.value - integer));
      }
    });
  }
}
