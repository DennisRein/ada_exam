import 'package:ada_exam/question.dart';

class Utils{
  static List<Map<Question, String>> questionAnswers = List();

  static _addNormalAnswer(Question q, int answer) {
    Map<Question, String> temp = Map();
    temp.addAll({q: (answer+1).toString()});
    questionAnswers.add(temp);
  }

  static _addMultipleAnswer(Question q, List<int> answer) {
    Map<Question, String> temp = Map();
    temp.addAll({q: answer.map((e) => e+1).toList().join(',')});
    questionAnswers.add(temp);
  }

  static _addSelectionAnswer(Question q, Map<int, String> selection) {
    Map<Question, String> temp = Map();
    temp.addAll({q: selection.keys.map((e) => "${e+1}${selection[e][0]}").toList().join(',')});
    questionAnswers.add(temp);
  }

  static addAnswer(Question q, dynamic answer) {
    if(answer is Map) _addSelectionAnswer(q, answer);
    else if(answer is List) _addMultipleAnswer(q, answer);
    else _addNormalAnswer(q, answer);
  }

  static getAtIndex(int index) {
    print(index);
    return questionAnswers[index];
  }

  static reset() {
    questionAnswers = List();
  }

  static final limit = 20;

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