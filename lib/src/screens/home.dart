import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/cat.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  @override
  void initState() {
    super.initState();
    boxController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // ignore: always_specify_types
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );
    catController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // ignore: always_specify_types
    catAnimation = Tween(begin: -30.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
    boxAnimation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    } else if (catController.status == AnimationStatus.forward) {
      catController.reverse();
      boxController.forward();
    } else if (catController.status == AnimationStatus.reverse) {
      catController.forward();
      boxController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation!'),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
          child: const Cat(),
        );
      },
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      decoration: BoxDecoration(
        color: Colors.brown,
        border: Border.all(width: 3.0),
      ),
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      top: 1.0,
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          decoration: BoxDecoration(
            color: Colors.brown,
            border: Border.all(width: 2.0),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      top: 1.0,
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          decoration: BoxDecoration(
            color: Colors.brown,
            border: Border.all(width: 2.0),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
            child: child,
          );
        },
      ),
    );
  }
}
