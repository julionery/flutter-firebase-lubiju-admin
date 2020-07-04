import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lubijuadmin/ui/views/order_view_page.dart';

class UserOrderTile extends StatelessWidget {
  final String orderId;

  UserOrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection("orders")
            .document(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderViewPage(snapshot.data)));
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Código: ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("${snapshot.data.documentID}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.black87)),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Horário da Compra: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${DateFormat('dd-MM-yyyy – kk:mm').format(snapshot.data['dateOrder'].toDate())}",
                                  style: TextStyle(color: Colors.black87)),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Status: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _buildStatus(
                                  snapshot.data['status'],
                                ),
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  String _buildStatus(int status) {
    switch (status) {
      case 1:
        return "Aguardando Confirmação";
        break;
      case 2:
        return "Em Preparação";
        break;
      case 3:
        return "Em Transporte";
        break;
      case 4:
        return "Entregue";
        break;
      case 99:
        return "Cancelado";
        break;
      default:
        return "Finalizado";
        break;
    }
  }
}
