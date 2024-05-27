import 'package:firebase_database/firebase_database.dart';

class RecipesService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('recipes');

  DatabaseReference get databaseReference => _databaseReference;

  void createRecipe(String id, String name, String description) {
    _databaseReference.child(id).set({
      'id': id,
      'name': name,
      'description': description,
    });
  }

  void readData(void Function(Map<dynamic, dynamic>) onDataReceived) {
    _databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values =
            dataSnapshot.value as Map<dynamic, dynamic>;
        onDataReceived(values);
      } else {
        onDataReceived({});
      }
    });
  }
}
