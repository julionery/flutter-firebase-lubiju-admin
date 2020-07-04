import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/ui/pages/size_page.dart';

class SizeTile extends StatelessWidget {
  final DocumentSnapshot size;
  final String categoryId;
  final String productId;

  SizeTile(this.size, this.categoryId, this.productId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onLongPress: () {
          size.reference.delete();
        },
        onTap: () {
          Stream<QuerySnapshot> _colors =
              size.reference.collection("colors").snapshots();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SizePage(
                  size: size,
                  categoryId: categoryId,
                  productId: productId,
                  colors: _colors)));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${size["title"]}",
                  style: TextStyle(
                      color: Colors.grey[450],
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Possui cores?",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        size["hasColor"]
                            ? Icon(Icons.check_circle_outline)
                            : Icon(Icons.radio_button_unchecked)
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text("Ordem: ${size["order"]}",
                        style: TextStyle(
                          color: Colors.grey[450],
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
