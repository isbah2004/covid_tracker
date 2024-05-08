import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  late String image;
  late String name;
  late int totalCases,
      totalDeaths,
      totalRecovered,
      active,
      critical,
      todayRecovered,
      test;
  DetailScreen(
      {Key? key,
      required this.image,
      required this.name,
      required this.active,
      required this.critical,
      required this.test,
      required this.todayRecovered,
      required this.totalCases,
      required this.totalDeaths,
      required this.totalRecovered})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
      ),
    );
  }
}
