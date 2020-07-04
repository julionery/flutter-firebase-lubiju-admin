import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/ui/tiles/size_tile.dart';
import 'package:lubijuadmin/ui/widgets/add_size_dialog.dart';
import 'package:lubijuadmin/ui/widgets/loading_widget.dart';
import 'package:lubijuadmin/ui/widgets/no_record_widget.dart';

class SizeList extends StatelessWidget {
  final String categoryId;
  final String productId;
  final String productName;

  SizeList(this.categoryId, this.productId, this.productName);

  @override
  Widget build(BuildContext context) {
    int qtdSizes = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tamanhos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String size = await showDialog(
              context: context, builder: (context) => AddSizeDialog());
          if (size != null)
            Firestore.instance
                .collection("products")
                .document(categoryId)
                .collection("items")
                .document(productId)
                .collection("sizes")
                .add({"hasColor": false, "order": qtdSizes + 1, "title": size});
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
            child: Text(
              "Produto: $productName",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("products")
                      .document(categoryId)
                      .collection("items")
                      .document(productId)
                      .collection("sizes")
                      .orderBy("order", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return LoadingWidget();
                    else if (snapshot.data.documents.length == 0)
                      return NoRecordWidget();
                    else {
                      qtdSizes = snapshot.data.documents.length;
                      return ListView(
                        children: snapshot.data.documents
                            .map((doc) => SizeTile(doc, categoryId, productId))
                            .toList(),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
