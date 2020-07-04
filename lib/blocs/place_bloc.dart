import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PlaceBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot place;
  dynamic image;

  Map<String, dynamic> unsavedData;

  PlaceBloc({this.place}) {
    if (place != null) {
      unsavedData = Map.of(place.data);
      _createdController.add(true);
    } else {
      unsavedData = {
        "address": null,
        "image": null,
        "lat": 0,
        "long": 0,
        "phone": null,
        "title": null
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveAddress(String value) {
    unsavedData["address"] = value;
  }

  void savePhone(String value) {
    unsavedData["phone"] = value;
  }

  void saveTitle(String value) {
    unsavedData["title"] = value;
  }

  void saveImage(dynamic value) {
    unsavedData["image"] = null;
    image = value;
  }

  void saveLat(double value) {
    unsavedData["lat"] = value;
  }

  void saveLong(double value) {
    unsavedData["long"] = value;
  }

  Future<bool> savePlace() async {
    _loadingController.add(true);

    try {
      if (place != null) {
        if (unsavedData["image"] == null) await _uploadImage(place.documentID);

        await place.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("places")
            .add(Map.from(unsavedData)..remove("image"));
        await _uploadImage(dr.documentID);
        await dr.updateData(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImage(String documentId) async {
    StorageUploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("places")
        .child(documentId)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(image);

    StorageTaskSnapshot s = await uploadTask.onComplete;
    String downloadUrl = await s.ref.getDownloadURL();

    unsavedData["image"] = downloadUrl;
  }

  void deletePlace() {
    place.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
