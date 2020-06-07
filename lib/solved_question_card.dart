import 'package:ada_exam/main.dart';
import 'package:ada_exam/question.dart';
import 'package:ada_exam/question_utils.dart';
import 'package:flutter/material.dart';

class SolvedQuestion extends StatefulWidget {
  final int index;

  SolvedQuestion(this.index);

  @override
  _SolvedQuestionState createState() => _SolvedQuestionState(this.index);
}

class _SolvedQuestionState extends State<SolvedQuestion> {
  final int index;
  Map<Question, String> q;
  Question question;
  String ans;

  int selected;
  List<int> selectedList = List<int>();
  Map<int, String> selectedMap = Map();

  _SolvedQuestionState(this.index) {
    this.q = Utils.getAtIndex(index);
    question = this.q.keys.first;
    ans = this.q[question];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: <Widget>[
          Text("${index+1}/${Utils.limit}")
        ],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                question.question,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              if (question.type == QuestionType.normal)
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: question.answers.length,
                  itemBuilder: (context, index) => Container(
                    color: Utils.translate(question.answer) - 1 == index
                        ? Colors.green
                        : null,
                    child: ListTile(
                      leading: int.parse(ans) - 1 == index
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text(question.answers[index]),
                    ),
                  ),
                ),
              if (question.type == QuestionType.multiple)
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: question.answers.length,
                  itemBuilder: (context, index) => Container(
                    color: question.answer
                            .map((e) => Utils.translate(e))
                            .toList()
                            .contains(index + 1)
                        ? Colors.green
                        : null,
                    child: ListTile(
                      leading: ans
                              .split(',')
                              .map((e) => int.parse(e) - 1)
                              .toList()
                              .contains(index)
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text(question.answers[index]),
                    ),
                  ),
                ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: question.selection.length,
                itemBuilder: (context, index) {
                  selectedMap[index] = question.answers.first;
                  return ListTile(
                      leading: DropdownButton<String>(
                        onTap: null,
                        value: question.answers[
                            Utils.translate(ans.split(',')[index][1]) - 1],
                        items: question.answers.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            selectedMap[index] = value;
                          });
                        },
                      ),
                      title: Text(question.selection[index]),
                      trailing: Text(
                        _getText(index),
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ));
                },
              ))
            ],
          ),
        ),
        floatingActionButton: ButtonBar(
          children: <Widget>[
            if(index > 0) FloatingActionButton(
              heroTag: null,
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back_ios),
            ),
            FloatingActionButton(
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  _navPage(context);
                }),
          ],
        ));
  }

  String _getText(int index) {
    return question.answers[Utils.translate(question.answer[index][1]) - 1];
  }

  void _navPage(BuildContext context) {
    if (index == Utils.limit - 1) {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => MyHomePage()));
    } else {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => SolvedQuestion(index + 1)));
    }
  }
}
