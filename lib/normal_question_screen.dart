import 'package:ada_exam/question.dart';
import 'package:ada_exam/question_utils.dart';
import 'package:ada_exam/solved_question_card.dart';
import 'package:flutter/material.dart';

class NormalQuestion extends StatefulWidget {
  final List<Question> questions;
  final int index;

  NormalQuestion(this.questions, this.index);

  @override
  _NormalQuestionState createState() => _NormalQuestionState(this.questions, this.index);
}

class _NormalQuestionState extends State<NormalQuestion> {
  final List<Question> questions;
  final int index;
  Question q;

  int selected;
  List<int> selectedList = List<int>();
  Map<int, String> selectedMap = Map();

  _NormalQuestionState(this.questions, this.index) {
    this.q = questions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: <Widget>[
          Text("${index + 1}/${Utils.limit}")
        ],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                q.question,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              if (q.type == QuestionType.normal)
            ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
              scrollDirection: Axis.vertical,
                      itemCount: q.answers.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: selected == index
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        onTap: () => setState(() {
                          selected = index;
                        }),
                        title: Text(q.answers[index]),
                      ),
                    ),
              if (q.type == QuestionType.multiple)
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: q.answers.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: selectedList.contains(index)
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () => setState(() {
                      selectedList.contains(index)
                          ? selectedList.remove(index)
                          : selectedList.add(index);
                    }),
                    title: Text(q.answers[index]),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: q.selection.length,
                  itemBuilder: (context, index) {
                    if(!selectedMap.containsKey(index))
                      selectedMap[index] = q.answers.first;
                    return ListTile(
                    leading: DropdownButton<String>(
                      value: selectedMap.containsKey(index) ? selectedMap[index] : q.answers.first,
                      items: q.answers.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(), onChanged: (String value) { setState(() {
                        print(value);
                        selectedMap[index] = value;
                      });},
                    ),
                    title: Text(q.selection[index]),
                  );},
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.navigate_next),
            onPressed: () {
              if(selected != null) Utils.addAnswer(q, selected);
              if (selectedList.length > 0) Utils.addAnswer(q, selectedList);
              if (selectedMap.keys.length > 0) Utils.addAnswer(q, selectedMap);
              if(selected != null || selectedMap.length + selectedList.length > 0) _navPage(context);})
    );

  }
  void _navPage(BuildContext context) {
    if(index == Utils.limit - 1)
      {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => SolvedQuestion(0)));
      }
    else {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => NormalQuestion(questions, index + 1)));
    }
    }
}
