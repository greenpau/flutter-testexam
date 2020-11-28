class ExamQuestion {
  String stem;
  List<String> answers;
  List<int> solution;
  List<String> comments;
  List<String> references;
  List<String> tags;

  ExamQuestion(
      {this.stem,
      this.answers,
      this.solution,
      this.comments,
      this.references,
      this.tags});

  ExamQuestion.fromJson(Map<String, dynamic> json) {
    stem = json['stem'];
    answers = json['answers'].cast<String>();
    solution = json['solution'].cast<int>();
    comments = json['comments'].cast<String>();
    references = json['references'].cast<String>();
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stem'] = this.stem;
    data['answers'] = this.answers;
    data['solution'] = this.solution;
    data['comments'] = this.comments;
    data['references'] = this.references;
    data['tags'] = this.tags;
    return data;
  }
}
