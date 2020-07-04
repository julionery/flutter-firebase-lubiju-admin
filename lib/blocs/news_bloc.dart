import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot news;
  dynamic image;

  Map<String, dynamic> unsavedData;

  NewsBloc({this.news}) {
    if (news != null) {
      unsavedData = Map.of(news.data);
      _createdController.add(true);
    } else {
      unsavedData = {
        "active": true,
        "image": null,
        "x": 1,
        "y": 1,
        "date": DateTime.now()
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveActive(bool value) {
    unsavedData["active"] = value;
  }

  void saveImage(dynamic value) {
    unsavedData["image"] = null;
    image = value;
  }

  void saveX(String value) {
    print(int.parse(value.trim()));
    unsavedData["x"] = int.parse(value.trim());
  }

  void saveY(String value) {
    print(int.parse(value.trim()));
    unsavedData["y"] = int.parse(value.trim());
    print(unsavedData);
  }

  Future<bool> saveNews() async {
    _loadingController.add(true);

    try {
      if (news != null) {
        print(unsavedData);
        if (unsavedData["image"] == null) await _uploadImage(news.documentID);

        await news.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("home")
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
        .child("home")
        .child(documentId)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(image);

    StorageTaskSnapshot s = await uploadTask.onComplete;
    String downloadUrl = await s.ref.getDownloadURL();

    unsavedData["image"] = downloadUrl;
  }

  void deleteNews() {
    news.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
