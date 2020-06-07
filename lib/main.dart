import 'dart:convert';
import 'dart:math';

import 'package:ada_exam/normal_question_screen.dart';
import 'package:ada_exam/question.dart';
import 'package:ada_exam/question_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static SharedPreferences prefs;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> answeredQuestions = List();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<List<Question>> _readQuestions() async {
    String data = await DefaultAssetBundle.of(context).loadString(
        "assets/questions.json");
    MyHomePage.prefs = await SharedPreferences.getInstance();

    answeredQuestions = MyHomePage.prefs.getStringList('questions') ?? List();


    var l = List.of(jsonDecode(data) as List)
        .map((e) => Question.fromJson(e))
        .toList();

    setState(() {

    });

    return l;
  }

  List<Question> _fetchRandom(List<dynamic> questions) {
    Utils.reset();

    if(questions.length - answeredQuestions.length < Utils.limit) {
      Utils.limit = questions.length - answeredQuestions.length;
    }

    try {
      print(MyHomePage.prefs
          .getStringList('questions')
          .length);
    } catch (exception) {
      print(exception.toString());
    }
    Set<Question> q = Set();
    while (q.length < Utils.limit) {
      var quest = questions[Random().nextInt(questions.length)];

      if(answeredQuestions.contains(quest.question)) {
        continue;
      }

      q.add(quest);
    }

    return q.toList();
  }

  Future<void> _resetQuestions(BuildContext ctx) async {
    return showDialog(context: ctx,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
              shape: RoundedRectangleBorder(),
          title: Text('Reset questions?'),
          content: SingleChildScrollView(
          child: ListBody(
          children: <Widget>[
          Text("Are you sure you would like to reset the questions?"),
          ],
          ),
          ),
          actions: <Widget>[
          RaisedButton(
          color: Colors.blueGrey,
          child: Text('Cancle'),
          onPressed: () {
          Navigator.of(context).pop();
          },
          ),
          FlatButton(
          child: Text('Reset'),
          onPressed: () async => await _reset(ctx),
          )
          ,
          ]);
        });
  }

  Future<void> _reset(BuildContext ctx) async {
    Utils.limit = 20;
    await MyHomePage.prefs.setStringList('questions', List());
    Navigator.of(ctx).pop();
    answeredQuestions = List();
    setState(() {

    });


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
                    Column(
                      children: <Widget>[
                        RaisedButton(
                            child: Text('Go', style: Theme
                                .of(context)
                                .textTheme
                                .headline1,),
                            onPressed: () async => (snapshot.data.length - answeredQuestions.length > 0) ? Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    NormalQuestion(
                                        _fetchRandom(snapshot.data), 0))) : _resetQuestions(context)),
                        RaisedButton(
                          child: Text('${MyHomePage.prefs
                              .getStringList('questions')
                              .length ?? 0}/${snapshot.data.length}'),
                          onPressed: () => _resetQuestions(context),
                        )
                      ],
                    ),
                ],
              ),
            ),
      ),
    );
  }
}
