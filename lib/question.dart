class Question {
  //{"type": 0, "answer": "b", "question": "Sie arbeiten in einem Betrieb, der bisher nicht ausbildet. Welches Argument könnte für die Aufnahme von Auszubildenden sprechen?", "answers": ["Sie können eine gelernte Fachkraft einsparen, da ab dem zweiten Lehrjahr der Auszubildende voll eingesetzt werden muss.", "Sie bilden Fachkräfte aus, die später - auch im eigenen Betrieb - dringend gebraucht werden und übernehmen somit Verantwortung.", "Sie können Fördermittel für die Auszubildenden erhalten, welche die Ausbildungsvergütung übersteigen.", "Auszubildende können auch gut zu nicht betrieblichen Zwecken eingesetzt werden."]}
  QuestionType type;
  dynamic answer;
  String question;
  List<dynamic> answers = List();

  List<dynamic> selection = List();

  Question._normal(String answer, String question, List<dynamic> answers) {
    this.type = QuestionType.normal;
    this.answer = answer;
    this.question = question;
    this.answers = answers;
  }

  Question._multiple(String answer, String question, List<dynamic> answers) {
    this.type = QuestionType.multiple;
    this.answer = answer.split(',');
    this.question = question;
    this.answers = answers;
  }

  Question._selection(String answer, String question, List<dynamic> ans) {
    this.type = QuestionType.selection;
    this.answer = answer.split(',');
    this.question = question;
    ans.forEach((e) => int.tryParse(e[0]) != null ? answerAdd(e) : selectionAdd(e));

  }

  void answerAdd(e) {
    selection.add(e);
  }

  void selectionAdd(e) {
    answers.add(e);
  }

  factory Question._internal(int type, String answer, String question, List<dynamic> answers) {
    switch(type) {
      case(0) : return Question._normal(answer, question, answers);
      case(1) : return Question._multiple(answer, question, answers);
      default : return Question._selection(answer, question, answers);
    }
  }

  factory Question.fromJson(dynamic json) {
    return Question._internal(json['type'], json['answer'], json['question'], json['answers']);
  }

  @override
  String toString() {
    return "${this.type.toString()} ${this.question.toString()} ${this.answers.toString()} ${this.answer.toString()} ${this.selection.toString()}";
  }

}

enum QuestionType {
  normal,
  multiple,
  selection,
}

extension QuestionTypeExtension on QuestionType {
  int value() {
    switch(this) {
      case(QuestionType.normal) : return 0;
      case(QuestionType.multiple) : return 1;
      default : return 2;
    }
  }

  QuestionType fromValue(int i) {
    switch(i) {
      case 0 : return QuestionType.normal;
      case 1: return QuestionType.multiple;
      default : return QuestionType.selection;
    }
  }

}

