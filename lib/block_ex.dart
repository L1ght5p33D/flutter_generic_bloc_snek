import 'package:flutter/material.dart';
import 'dart:async';

abstract class BlocBase {
  void dispose();
}

// Generic BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    // final type = _typeOf<BlocProvider<T>>();
    final type = _typeOf<BlocProvider<T>>();

    // https://dart.dev/guides/language/language-tour
    // class Foo<T extends SomeBaseClass> {
    // String toString() => "Instance of 'Foo<$T>'";
    // }
    // class Extender extends SomeBaseClass {...}
    // It’s OK to use SomeBaseClass or any of its subclasses as generic argument:
    // var someBaseClassFoo = Foo<SomeBaseClass>();
    // var extenderFoo = Foo<Extender>();
    // _BlocProviderInherited<T> provider = context.getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()?.widget;

    // could print type of findAncestor here ...
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<IncrementBloc>(
        bloc: IncrementBloc(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IncrementBloc ic_bloc_inst = BlocProvider.of<IncrementBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        child: StreamBuilder<int>(
            // stream: bloc.outCounter,
            stream: ic_bloc_inst.count_stream,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text('You hit me: ${ic_bloc_inst.bloc_counter} times');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ic_bloc_inst._handleLogic(null);
        },
      ),
    );
  }
}

// Cannot create multiple
class IncrementBloc implements BlocBase {
  Stream count_stream;
  int bloc_counter = 0;

  StreamController<int> counterController = StreamController<int>();
  // Stream<int>  outCounter = counterController.stream.asBroadcastStream();

  // Sink getter to name input function
  StreamSink<int> get inAdd => counterController.sink;

  Stream out_counter() {
    Stream ic_bc_stream = counterController.stream.asBroadcastStream();
    count_stream = ic_bc_stream;
    return ic_bc_stream;
  }

  void dispose() {
    counterController.close();
  }

  void _handleLogic(data) {
    bloc_counter = bloc_counter + 1;
    //print("Counter call ~ " + bloc_counter.toString() );
  }
}
