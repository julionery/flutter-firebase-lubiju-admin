import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lubijuadmin/blocs/orders_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CouponsBloc extends BlocBase {
  final _couponsController = BehaviorSubject<List>();

  Stream<List> get outCoupons => _couponsController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _coupons = [];

  SortCriteria _criteria;

  CouponsBloc() {
    _addCouponsListener();
  }

  void _addCouponsListener() {
    _firestore.collection("coupons").snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _coupons.add(change.document);
            break;
          case DocumentChangeType.modified:
            _coupons.removeWhere((order) => order.documentID == oid);
            _coupons.add(change.document);
            break;
          case DocumentChangeType.removed:
            _coupons.removeWhere((order) => order.documentID == oid);
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
        _coupons.sort((a, b) {
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
        _coupons.sort((a, b) {
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
    _couponsController.add(_coupons);
  }

  @override
  void dispose() {
    _couponsController.close();
  }
}
