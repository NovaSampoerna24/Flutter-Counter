import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlogDelegate extends BlocDelegate{
  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    // TODO: implement onError
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    // TODO: implement onEvent
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
    print(transition);
  }
}
void main() {
  BlocSupervisor.delegate = SimpleBlogDelegate();
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=>ThemeBloc(),
      child: BlocBuilder<ThemeBloc,ThemeData>(
      builder: (_,theme){
        return MaterialApp(
          title: 'Flutter Demo',
          home: BlocProvider(
            create: (_)=>CounterBloc(),
            child: CounterPage(),
            ),
            theme: theme,
          );
        },
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: BlocBuilder<CounterBloc, int>(
        builder: (_, count) {
          return Center(
            child: Text(
              '$count',
              style: TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () =>
                  context.bloc<CounterBloc>().add(CounterEvent.increment),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () =>
                  context.bloc<CounterBloc>().add(CounterEvent.decrement),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.update),
              onPressed: () => context.bloc<ThemeBloc>().add(ThemeEvent.toggle),
            ),
          ),
        ],
      ),
    );
  }
}


enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent,int>{
  int get initialState => 0;

  Stream<int> mapEventToState(CounterEvent event)async*{
    switch (event) {
      case CounterEvent.decrement:
          yield state - 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
    }
  }
}

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent,ThemeData>{
  
  ThemeData get initialState => ThemeData.light();

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async*{
    switch (event) {
      case ThemeEvent.toggle:
        yield state == ThemeData.dark() ?ThemeData.light() : ThemeData.dark();
        break;
      
    }
  }
}