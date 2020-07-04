import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class SizeBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String productId;
  String categoryId;
  DocumentSnapshot size;
  Stream<QuerySnapshot> colors;

  Map<String, dynamic> unsavedData;

  SizeBloc({this.size, this.productId, this.categoryId, this.colors}) {
    if (size != null) {
      unsavedData = Map.of(size.data);
      _createdController.add(true);
    } else {
      unsavedData = {"title": null, "colors": []};
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String title) {
    unsavedData["title"] = title;
  }

  void saveHasColor(bool value) {
    unsavedData["hasColor"] = value;
  }

  void saveQuantity(String value) {
    unsavedData["quantity"] = int.parse(value);
  }

  void saveOrder(String value) {
    unsavedData["order"] = int.parse(value);
  }

  void saveColors(List colors) {
    unsavedData["colors"] = colors;
  }

  Future<bool> saveSize() async {
    _loadingController.add(true);

    try {
      if (size != null) {
        await size.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("products")
            .document(categoryId)
            .collection("items")
            .add(Map.from(unsavedData)..remove("images"));
        await _addColors(dr.documentID);
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

  Future _addColors(String productId) async {
    for (int i = 0; i < unsavedData["sizes"].length; i++) {
      await Firestore.instance
          .collection("products")
          .document(categoryId)
          .collection("items")
          .document(productId)
          .collection("sizes")
          .add({
        "title": unsavedData["sizes"][i],
        "hasColor": false,
        "quantity": 0,
        "order": i + 1,
      });
    }
  }

  void deleteSize() {
    size.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
