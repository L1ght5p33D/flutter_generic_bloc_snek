import 'package:flutter/material.dart';

abstract class siBlocBase {
  void dispose();
}

class _siBlocProviderState<T> extends State<siBlocProvider<siBlocBase>>{
  @override
  void dispose(){
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return widget.child;
  }
}

// Generic BLoC provider
class siBlocProvider<T extends siBlocBase> extends StatefulWidget {
  siBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _siBlocProviderState<T> createState() => _siBlocProviderState<T>();

  static T of<T extends siBlocBase>(BuildContext context){
    // final type = _typeOf<BlocProvider<T>>();
    final type = _typeOf<siBlocProvider<T>>();

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
    siBlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}