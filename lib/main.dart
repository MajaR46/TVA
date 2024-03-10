import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rvir_demo_0/models/person.dart';
import 'second_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(PersonAdapter());
    await Hive.openBox<Person>('people');
    runApp(const MyApp());
    Fluttertoast.showToast(msg: "Database connected");
  } catch (error) {
    print("Error connecting to the database: $error");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Box<Person> personBox;

  @override
  void initState() {
    super.initState();
    personBox = Hive.box<Person>('people');
  }

  String name = '';
  String surname = '';
  String dropdownvalue = 'Profesor';

  var dropdownitems = [
    'Profesor',
    'Asistent',
    'Referat',
    'Dekan',
  ];

  final TextEditingController _imeController =
      TextEditingController(); // s controllerji imamo nadzor nad podatki ki jih userji vnesejo v input fielde
  final TextEditingController _priimekController = TextEditingController();
  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _timePickerContollerPrihod =
      TextEditingController();
  final TextEditingController _timePickerContollerOdhod =
      TextEditingController();

  void _navigateToSecondScreen() async {
    _formKey.currentState!.save(); // Shraniš vrednosti forme
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SecondScreen(clearFormCallback: clearForm),
        //clearFormCallback --> s tem omogočiš da se clearForm metoda kliče na drugem screenu
      ),
    );
  }

  void clearForm() {
    //clear form ko greš iz second screen na prvi
    _imeController.clear();
    _priimekController.clear();
    _datePickerController.clear();
    _timePickerContollerOdhod.clear();
    _timePickerContollerPrihod.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            'Podatki o zaposlenem',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.indigo[400],
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _imeController,
                  decoration: InputDecoration(
                    labelText: 'Ime',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _priimekController,
                  decoration: InputDecoration(
                    labelText: 'Priimek',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                  onSaved: (value) {
                    surname = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField(
                  isExpanded: true,
                  value: dropdownvalue,
                  decoration: InputDecoration(
                    labelText: 'Delovno mesto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: dropdownitems.map((String dropdownitems) {
                    return DropdownMenuItem(
                      value: dropdownitems,
                      child: Text(
                        dropdownitems,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _datePickerController,
                  decoration: InputDecoration(
                    labelText: 'Datum',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _datepicker();
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _timePickerContollerPrihod,
                  decoration: InputDecoration(
                    labelText: 'Ura prihoda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _timepickerPrihod();
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _timePickerContollerOdhod,
                  decoration: InputDecoration(
                    labelText: 'Ura odhoda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _timepickerOdhod();
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      personBox.add(Person(
                          name: _imeController.text,
                          surname: _priimekController.text,
                          position: dropdownvalue,
                          date: _datePickerController.text,
                          arrivalTime: _timePickerContollerPrihod.text,
                          leaveTime: _timePickerContollerOdhod.text));
                      _navigateToSecondScreen();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.indigo[400] ?? Colors.indigo),
                    ),
                    child: const Text(
                      'Naprej',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _datepicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    );

    if (selectedDate != null) {
      final formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day} ";
      setState(() {
        _datePickerController.text = formattedDate
            .toString(); // izbran date spremeni v string da ga lahko prikažemo na text fieldu
      });
    }
  }

  Future<void> _timepickerPrihod() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (time != null) {
      final formattedTime = "${time.hour}:${time.minute}";
      setState(() {
        _timePickerContollerPrihod.text = formattedTime.toString();
      });
    }
  }

  Future<void> _timepickerOdhod() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (time != null) {
      final formattedTime = "${time.hour}:${time.minute}";
      setState(() {
        _timePickerContollerOdhod.text = formattedTime.toString();
      });
    }
  }
}
