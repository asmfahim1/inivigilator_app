class Exam {
  int? id;
  String? examDate;
  String? examStart;
  String? examEnd;
  List<Room>? rooms;

  Exam({this.id, this.examDate, this.examStart, this.examEnd, this.rooms});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      examDate: json['examDate'],
      examStart: json['examStart'],
      examEnd: json['examEnd'],
      rooms: (json['rooms'] as List<dynamic>?)
          ?.map((e) => Room.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examDate': examDate,
    'examStart': examStart,
    'examEnd': examEnd,
    'rooms': rooms?.map((e) => e.toJson()).toList(),
  };
}

class Room {
  int? roomId;
  String? roomNo;
  int? capacity;
  Hall? hall;

  Room({this.roomId, this.roomNo, this.capacity, this.hall});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      roomNo: json['roomNo'],
      capacity: json['capacity'],
      hall: json['hall'] != null ? Hall.fromJson(json['hall']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'roomNo': roomNo,
    'capacity': capacity,
    'hall': hall?.toJson(),
  };
}

class Hall {
  int? id;
  String? name;
  String? location;

  Hall({this.id, this.name, this.location});

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
  };
}


/*{
"ok": true,
"message": "susccess",
"data": [
{
"id": 10,
"examDate": "2025-06-08",
"examStart": "10:00 AM",
"examEnd": "12:00 PM",
"rooms": [
{
"roomId": 3,
"roomNo": "C201",
"capacity": 40,
"hall": {
"id": 1,
"name": "Main Hall",
"location": "Building A"
}
}
]
}
]
}*/
