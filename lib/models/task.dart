class TaskData {
  String? id;
  String? title;
  String? description;
  int? date;
  String? time;
  bool? isDone;

  TaskData(
      {this.id = null,
      required this.title,
      required this.description,
      required this.date,
      required this.time,
      this.isDone = false});

  Map<String, dynamic> toJson() {
    return {
      idColumn: id,
      titleColumn: title,
      descriptionColumn: description,
      dateColumn: date,
      timeColumn: time,
      isDoneColumn: isDone,
    };
  }

  Map<String, dynamic> toJsonSqflite() {
    return {
      // idColumn: id,
      titleColumn: title,
      descriptionColumn: description,
      dateColumn: date,
      timeColumn: time,
      isDoneColumn: isDone == true ? 1 : 0,
    };
  }

  TaskData.fromJson(Map<String, dynamic> json)
      : this(
          id: json[idColumn],
          title: json[titleColumn],
          description: json[descriptionColumn],
          date: json[dateColumn],
          time: json[timeColumn],
          isDone: json[isDoneColumn],
        );

  TaskData.fromJsonSqflite(Map<String, dynamic> json)
      : this(
          id: json[idColumn].toString(),
          title: json[titleColumn],
          description: json[descriptionColumn],
          date: json[dateColumn],
          time: json[timeColumn],
          isDone: json[isDoneColumn] == 1 ? true : false,
        );

  @override
  String toString() {
    return "Task $id, title: $title, description: $description";
  }

  @override
  bool operator ==(covariant TaskData other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

const dbName = "tasks.db";
const tasksTable = "todo";
const idColumn = "id";
const titleColumn = "title";
const descriptionColumn = "description";
const dateColumn = "date";
const timeColumn = "time";
const isDoneColumn = "isDone";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "todo" (
	"id"	INTEGER NOT NULL UNIQUE,
	"title"	TEXT,
	"description"	TEXT,
	"date"	INTEGER DEFAULT 0,
	"time"	INTEGER,
	"isDone"	INTEGER DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT)
); ''';
