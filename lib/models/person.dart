import 'package:hive/hive.dart';
part 'person.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String surname;
  @HiveField(2)
  final String position;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String arrivalTime;
  @HiveField(5)
  final String leaveTime;
  Person({
    required this.name,
    required this.surname,
    required this.position,
    required this.date,
    required this.arrivalTime,
    required this.leaveTime,
  });
}
