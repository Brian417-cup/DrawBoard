import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:flutterdrawboard/view/custom_draw_board_area.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DrawBoardProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomDrawBoardArea(),
    );
  }
}
