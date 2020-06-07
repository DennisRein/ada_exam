import 'package:ada_exam/main.dart';
import 'package:ada_exam/question.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{
  static List<Map<Question, String>> questionAnswers = List();
  static final SharedPreferences prefs = MyHomePage.prefs;

  static _addDone(Question q) {
    List<String> questions = prefs.getStringList('questions') ?? List();

    print(q);

    print(questions);

    questions.add(q.question);

    prefs.setStringList('questions', questions);
  }


  static _addNormalAnswer(Question q, int answer) {
    Map<Question, String> temp = Map();
    temp.addAll({q: (answer+1).toString()});
    print(Utils.translate(q.answer)-1);
    print(answer);
    if(Utils.translate(q.answer)-1 == answer) {
      _addDone(q);
    }
    questionAnswers.add(temp);
  }

  static _addMultipleAnswer(Question q, List<int> answer) {

    Map<Question, String> temp = Map();
    temp.addAll({q: answer.map((e) => e+1).toList().join(',')});

    List translated = q.answer.map((e) => Utils.translate(e) - 1).toList();
    if(DeepCollectionEquality.unordered().equals(translated, answer)) {
        _addDone(q);
      }

    questionAnswers.add(temp);
  }

  static _addSelectionAnswer(Question q, Map<int, String> selection) {
    Map<Question, String> temp = Map();
    List translated = List.of(selection.keys).toList().map((e) => "${e + 1}${selection[e][0]}").toList();
      if(DeepCollectionEquality.unordered().equals(translated, q.answer)) {
      _addDone(q);
    }


    temp.addAll({q: selection.keys.map((e) => "${e+1}${selection[e][0]}").toList().join(',')});
    questionAnswers.add(temp);
  }

  static addAnswer(Question q, dynamic answer) {
    if(answer is Map) _addSelectionAnswer(q, answer);
    else if(answer is List) _addMultipleAnswer(q, answer);
    else _addNormalAnswer(q, answer);
  }

  static getAtIndex(int index) {
    return questionAnswers[index];
  }

  static reset() {
    questionAnswers = List();
  }

  static int limit = 20;

  static int translate(String c) {
    switch(c) {
      case 'a' : return 1;
      case 'b' : return 2;
      case 'c' : return 3;
      case 'd' : return 4;
      case 'e' : return 5;
      case 'f' : return 6;
      case 'g' : return 7;
      default : return 0;
    }
  }

}