import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["sizes"] =
          product.data["sizes"] != null ? List.of(product.data["sizes"]) : [];
      unsavedData["colors"] =
          product.data["colors"] != null ? List.of(product.data["colors"]) : [];
      _createdController.add(true);
    } else {
      unsavedData = {
        "active": true,
        "title": null,
        "description": null,
        "price": null,
        "hasSize": false,
        "hasColor": false,
        "quantity": 0,
        "images": [],
        "sizes": [],
        "colors": [],
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveActive(bool value) {
    unsavedData["active"] = value;
  }

  void saveTitle(String title) {
    unsavedData["title"] = title;
  }

  void saveDescription(String description) {
    unsavedData["description"] = description;
  }

  void savePrice(String price) {
    unsavedData["price"] = double.parse(price);
  }

  void saveImages(List images) {
    unsavedData["images"] = images;
  }

  void saveSizes(List sizes) {
    unsavedData["sizes"] = sizes;
  }

  void saveQuantity(String value) {
    unsavedData["quantity"] = int.parse(value);
  }

  void saveHasSize(bool value) {
    unsavedData["hasSize"] = value;
  }

  void saveHasColor(bool value) {
    unsavedData["hasColor"] = value;
  }

  void saveColors(List colors) {
    unsavedData["colors"] = colors;
  }

  Future<String> saveProduct() async {
    String uID;
    _loadingController.add(true);
    if (unsavedData["hasSize"] || unsavedData["hasColor"])
      unsavedData["quantity"] = 0;

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
        uID = product.documentID;
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("products")
            .document(categoryId)
            .collection("items")
            .add(Map.from(unsavedData)..remove("images"));
        await _uploadImages(dr.documentID);

        await _addSizes(dr.documentID);
        unsavedData.remove("sizes");

        await _addColors(dr.documentID);
        unsavedData.remove("colors");

        await dr.updateData(unsavedData);
        uID = dr.documentID;
      }

      _createdController.add(true);
      _loadingController.add(false);
      return uID;
    } catch (e) {
      _loadingController.add(false);
      return null;
    }
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < unsavedData["images"].length; i++) {
      if (unsavedData["images"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData["images"][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  Future _addSizes(String productId) async {
    for (int i = 0; i < unsavedData["sizes"].length; i++) {
      await Firestore.instance
          .collection("products")
          .document(categoryId)
          .collection("items")
          .document(productId)
          .collection("sizes")
          .add({
        "title": unsavedData["sizes"][i],
        "quantity": 0,
        "hasColor": false,
        "order": i + 1,
      });
    }
  }

  Future _addColors(String productId) async {
    for (int i = 0; i < unsavedData["colors"].length; i++) {
      await Firestore.instance
          .collection("products")
          .document(categoryId)
          .collection("items")
          .document(productId)
          .collection("colors")
          .add({
        "color": unsavedData["colors"][i],
        "quantity": 0,
      });
    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
