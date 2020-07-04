import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/ui/tiles/user_order_tile.dart';

class UserOrdersPage extends StatefulWidget {
  final String uid;

  const UserOrdersPage(this.uid);

  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("users")
            .document(widget.uid)
            .collection("orders")
            .orderBy("dateOrder")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ListView(
              children: snapshot.data.documents
                  .map((doc) => UserOrderTile(doc.documentID))
                  .toList()
                  .reversed
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
