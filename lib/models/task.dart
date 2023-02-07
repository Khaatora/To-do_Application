class TaskData {
  String? id;
  String? title;
  String? description;
  int? date;
  String? time;
  bool? isDone;

  TaskData(
      {this.id = "",
      required this.title,
      required this.description,
      required this.date,
      required this.time,
      this.isDone = false});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "time": time,
      "isDone": isDone,
    };
  }

  TaskData.fromJson(Map<String, dynamic> json)
      : this(
    id: json["id"],
          title: json["title"],
          description: json["description"],
          date: json["date"],
          time: json["time"],
          isDone: json["isDone"],
        );
}
