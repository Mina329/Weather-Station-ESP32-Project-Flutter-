import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp_app/models/csv_model.dart';
import 'package:firebase_database/firebase_database.dart';

class WeatherRepository {
  final DatabaseReference firebaseDatabase;
  final FirebaseFirestore firebaseFirestore;

  WeatherRepository({
    required this.firebaseDatabase,
    required this.firebaseFirestore,
  });

  Stream<double> temperatures() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('TEMPERATURE').value.toString())
        .map(double.parse);
  }

  Stream<double> humidities() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('HUMIDITY').value.toString())
        .map(double.parse);
  }

  Stream<double> altitudes() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('ALTITUDE').value.toString())
        .map(double.parse);
  }

  Stream<double> pressures() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('PRESSURE').value.toString())
        .map(double.parse);
  }

  Stream<double> alert() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('ALERT').value.toString())
        .map(double.parse);
  }

  Stream<String> time() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('TIME').value.toString());
  }

  Future<List<CSVRowModel>> csvRecords() async {
    var query = await firebaseFirestore
        .collection('history')
        .orderBy('CREATED_AT', descending: true)
        .get();
    var csvRows =
        query.docs.map((doc) => CSVRowModel.fromJson(doc.data())).toList();
    return csvRows;
  }

  Stream<Map<dynamic, dynamic>> settings() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.value as Map<dynamic, dynamic>);
  }

  Stream<String> emailSent() {
    return firebaseDatabase.onValue
        .map((event) => event.snapshot.child('emailSent').value.toString());
  }

  Stream<Map<String, int>> minmaxTemp() {
    return firebaseDatabase.onValue.map((event) {
      return {
        'minTempVal':
            double.parse(event.snapshot.child('minTempVal').value.toString())
                .round(),
        'maxTempVal':
            double.parse(event.snapshot.child('maxTempVal').value.toString())
                .round()
      };
    });
  }

  void minTempVal(int value) async {
    await firebaseDatabase.update({'minTempVal': value});
  }

  void maxTempVal(int value) async {
    await firebaseDatabase.update({'maxTempVal': value});
  }

  void minHumiVal(int value) async {
    await firebaseDatabase.update({'minHumiVal': value});
  }

  void maxHumiVal(int value) async {
    await firebaseDatabase.update({'maxHumiVal': value});
  }

  void minAltVal(int value) async {
    await firebaseDatabase.update({'minAltVal': value});
  }

  void maxAltVal(int value) async {
    await firebaseDatabase.update({'maxAltVal': value});
  }

  void minPresVal(int value) async {
    await firebaseDatabase.update({'minPresVal': value});
  }

  void maxPresVal(int value) async {
    await firebaseDatabase.update({'maxPresVal': value});
  }

  void setEmail(String value) async {
    await firebaseDatabase.update({'email': value});
  }

  void setEmailSent(bool value) async {
    await firebaseDatabase.update({'emailSent': value});
  }
}
