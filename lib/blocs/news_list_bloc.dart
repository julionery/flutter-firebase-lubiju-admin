import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class NewsListBloc extends BlocBase {
  final _newsController = BehaviorSubject<List>();

  Stream<List> get outNews => _newsController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _news = [];

  NewsListBloc() {
    _addNewsListener();
  }

  void _addNewsListener() {
    _firestore.collection("home").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _news.add(change.document);
            break;
          case DocumentChangeType.modified:
            _news.removeWhere((order) => order.documentID == oid);
            _news.add(change.document);
            break;
          case DocumentChangeType.removed:
            _news.removeWhere((order) => order.documentID == oid);
            break;
        }
      });
      _newsController.add(_news);
    });
  }

  @override
  void dispose() {
    _newsController.close();
  }
}
