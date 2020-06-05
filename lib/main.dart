import 'dart:convert';
import 'dart:math';

import 'package:ada_exam/normal_question_screen.dart';
import 'package:ada_exam/question.dart';
import 'package:ada_exam/question_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADA Exam App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ADA Exam App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<List<Question>> _readQuestions() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/questions.json");
    var l = List.of(jsonDecode(data) as List).map((e) => Question.fromJson(e)).toList();
    return l;
  }
  
  List<Question> _fetchRandom(List<dynamic> questions) {
    Utils.reset();
    Set<Question> q = Set();
    while(q.length < Utils.limit) {
      q.add(questions[Random().nextInt(questions.length)]);
    }

    return q.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADA Exam App'),
      ),
      body: FutureBuilder(
        future: _readQuestions(),
        builder: (context, snapshot) =>
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if(snapshot.hasError)
                Text(snapshot.error.toString()),
              if(!snapshot.hasData)
                Text('Loading Data')
              else
                RaisedButton(
                child: Text('Go', style: Theme.of(context).textTheme.headline1,),
                onPressed: () async =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NormalQuestion(_fetchRandom(snapshot.data), 0)))),
            ],
          ),
        ),
      ),
    );
  }
}
