import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({ WidgetBuilder builder, RouteSettings settings })
    : super(builder: builder, settings:settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if(settings.isInitialRoute){
      return child;
    }

    return new FadeTransition(opacity: animation, child: child);

  }

}

class SlideLeftRoute<T> extends MaterialPageRoute<T> {
  SlideLeftRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings:settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if(settings.isInitialRoute){
      return child;
    }

    return new SlideTransition(position: new Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero
    ).animate(animation), child: child);

  }

}