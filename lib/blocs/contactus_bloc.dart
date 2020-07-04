import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lubijuadmin/blocs/orders_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ContactUsBloc extends BlocBase {
  final _contactUsController = BehaviorSubject<List>();

  Stream<List> get outContactUs => _contactUsController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _contactUs = [];

  SortCriteria _criteria;

  ContactUsBloc() {
    _addContactUsListener();
  }

  void _addContactUsListener() {
    _firestore.collection("messages").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _contactUs.add(change.document);
            break;
          case DocumentChangeType.modified:
            _contactUs.removeWhere((message) => message.documentID == oid);
            _contactUs.add(change.document);
            break;
          case DocumentChangeType.removed:
            _contactUs.removeWhere((message) => message.documentID == oid);
            break;
        }
      });

      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _contactUs.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });
        break;
      case SortCriteria.READY_LAST:
        _contactUs.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }
    _contactUsController.add(_contactUs);
  }

  @override
  void dispose() {
    _contactUsController.close();
  }
}
