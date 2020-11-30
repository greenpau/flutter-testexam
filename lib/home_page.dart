import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:testexam/exam_question.dart';

class MyHomePage extends StatefulWidget {
  final title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final _examController = ExamController();

  List<ExamQuestion> _examQuestions = [];
  ExamQuestion _question;
  Map<String, bool> selectedChoices = {};
  int _pointer = 0;
  int _currentQuestionID = 1;
  int _totalQuestions = 0;
  bool _answerVisible = false;

  @override
  void initState() {
    super.initState();

    _loadExamQuestions().then((data) {
      setState(() {
        if (data == null) {
          _examQuestions = [];
          _totalQuestions = 0;
        } else {
          _examQuestions = data;
          _totalQuestions = data.length;
          _question = _examQuestions[_pointer];
        }
      });
    });
  }

  void _showAnswer() {
    setState(() {
      _answerVisible = true;
    });
  }

  void _incrementCounter() {
    setState(() {
      _pointer++;
      _currentQuestionID++;
      _question = _examQuestions[_pointer];
      _answerVisible = false;
      selectedChoices = {};
    });
  }

  void _decrementCounter() {
    if (_pointer == 0) {
      return;
    }
    setState(() {
      _pointer--;
      _currentQuestionID--;
      _question = _examQuestions[_pointer];
      _answerVisible = false;
      selectedChoices = {};
    });
  }

  void putAnswerState(item, value) {
    Map<String, bool> newSelectedChoices = selectedChoices;
    newSelectedChoices[item] = value;
    setState(() {
      selectedChoices = newSelectedChoices;
    });
  }

  bool getAnswerState(item) {
    return selectedChoices.containsKey(item);
  }

  String getSolution() {
    var letters = {
      0: "A",
      1: "B",
      2: "C",
      3: "D",
      4: "E",
      5: "F",
      6: "G",
      7: "H",
    };
    List<String> entries = [];
    for (var i in _question.solution) {
      entries.add(letters[i]);
    }
    return entries.join(', ');
  }

  String getAnswerIndex(item, _question_answers) {
    var letters = {
      0: "A",
      1: "B",
      2: "C",
      3: "D",
      4: "E",
      5: "F",
      6: "G",
      7: "H",
    };

    print(item);

    for (var i = 0; i < _question_answers.length; i++) {
      if (_question_answers[i] == item) {
        return letters[i] + '.';
      }
    }
    return "- ";
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    if (_totalQuestions < 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Exam questions not found!',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      );
    }

    String _question_stem = _question.stem;
    List<String> _question_answers = _question.answers;
    List<int> _question_solution = _question.solution;
    bool _multiple_choice = false;

    //for (var i = 0; i < _question_answers.length; i++) {
    //  selectedChoices[_question_answers[i]] = false;
    //}

    //if (_question_solution.length > 1) {
    //  _multiple_choice = true;
    //}

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // Question Count
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          '$_currentQuestionID out of ${_totalQuestions}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Question stem
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Question: ' + '$_question_stem',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Question Choices
            for (var item in _question_answers)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: getAnswerState(item),
                        onChanged: (bool newValue) {
                          putAnswerState(item, newValue);
                        },
                      ),
                      Expanded(
                        child: Text(
                          getAnswerIndex(item, _question_answers) + ' ${item}',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Question Solution
            Row(
              children: [
                Row(
                  children: [
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Visibility(
                            visible: _answerVisible,
                            child: Text(
                              'Solution: ' + getSolution(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Answer and Next Buttons
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OutlineButton(
                          onPressed: () {
                            _decrementCounter();
                          },
                          child: Text(
                            "Previous",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OutlineButton(
                          onPressed: () {
                            _showAnswer();
                          },
                          child: Text(
                            "Show Answer",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OutlineButton(
                          onPressed: () {
                            _incrementCounter();
                          },
                          child: Text(
                            "Next",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ExamQuestion>> _loadExamQuestions() async {
    try {
      List<ExamQuestion> questionList = [];
      final dynList = json.decode(await rootBundle.loadString('data.json'));
      var dynListIter = dynList.iterator;
      while (dynListIter.moveNext()) {
        //print(dynListIter.current);
        var q = ExamQuestion(
          stem: dynListIter.current['question'],
          answers: List<String>.from(dynListIter.current['answers']),
          solution: List<int>.from(dynListIter.current['solution']),
        );
        questionList.add(q);
        //break;
      }

      return questionList;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
