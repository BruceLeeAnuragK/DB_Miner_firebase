class Student {
  int id;
  String name;
  String age;

  Student({
    required this.id,
    required this.name,
    required this.age,
  });

  factory Student.fromMap(Map data, {required Map<dynamic, dynamic> data}) =>
      Student(
        id:data['id'],
        name: data["name"],
        age: data["age"],
      );
}
