import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rvir_demo_0/models/person.dart';

class SecondScreen extends StatelessWidget {
  final Function()? clearFormCallback;

  const SecondScreen({
    Key? key,
    this.clearFormCallback,
  }) : super(key: key);

  Future<void> _updatePerson(
      BuildContext context, Person person, int index) async {
    final editControllerName = TextEditingController(text: person.name);
    final editControllerSurname = TextEditingController(text: person.surname);
    final editControllerDate = TextEditingController(text: person.date);
    final editControllerArrivalTime =
        TextEditingController(text: person.arrivalTime);
    final editControllerLeaveTime =
        TextEditingController(text: person.leaveTime);

    final List<String> positions = ['Profesor', 'Asistent', 'Referat', 'Dekan'];

    // Variable to hold the selected position
    String? selectedPosition = person.position;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: editControllerName),
              TextField(controller: editControllerSurname),
              DropdownButtonFormField<String>(
                value: selectedPosition,
                items: positions.map((String position) {
                  return DropdownMenuItem<String>(
                    value: position,
                    child: Text(position),
                  );
                }).toList(),
                onChanged: (String? value) {
                  selectedPosition = value;
                },
              ),
              TextField(
                controller: editControllerDate,
              ),
              TextField(controller: editControllerArrivalTime),
              TextField(controller: editControllerLeaveTime),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final editedPerson = Person(
                  name: editControllerName.text,
                  surname: editControllerSurname.text,
                  position: selectedPosition ?? '',
                  date: editControllerDate.text,
                  arrivalTime: editControllerArrivalTime.text,
                  leaveTime: editControllerLeaveTime.text,
                );
                Hive.box<Person>('people').putAt(index, editedPerson);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            'Izpis zaposlenih',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.indigo[400],
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Person>('people').listenable(),
        builder: (context, Box<Person> personBox, _) {
          return ListView.builder(
            itemCount: personBox.length,
            itemBuilder: (context, index) {
              final person = personBox.getAt(index);
              return ListTile(
                title: Text('${person!.name} ${person.surname}'),
                leading: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        personBox.deleteAt(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _updatePerson(context, person, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          clearFormCallback?.call();
        },
        backgroundColor: Colors.indigo[400],
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
      ),
    );
  }
}
