import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PlaceListBloc extends BlocBase {
  final _placeController = BehaviorSubject<List>();

  Stream<List> get outPlace => _placeController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _place = [];

  PlaceListBloc() {
    _addPlaceListener();
  }

  void _addPlaceListener() {
    _firestore.collection("places").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _place.add(change.document);
            break;
          case DocumentChangeType.modified:
            _place.removeWhere((order) => order.documentID == oid);
            _place.add(change.document);
            break;
          case DocumentChangeType.removed:
            _place.removeWhere((order) => order.documentID == oid);
            break;
        }
      });
      _placeController.add(_place);
    });
  }

  @override
  void dispose() {
    _placeController.close();
  }
}
