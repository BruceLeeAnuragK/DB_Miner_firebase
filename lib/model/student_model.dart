class Student {
  int id;
  String name;
  int age;

  Student({
    required this.id,
    required this.name,
    required this.age,
  });

  factory Student.fromMap({required Map data}) => Student(
        id: data['id'],
        name: data["name"],
        age: data["age"],
      );
}
