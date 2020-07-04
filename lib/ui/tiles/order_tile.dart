import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/ui/views/order_view_page.dart';
import 'package:lubijuadmin/ui/widgets/order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order);

  final Map<int, String> status = {
    0: "",
    1: "Recebido",
    2: "Em preparação",
    3: "Em transporte",
    4: "Entregue",
    5: "Finalizado",
    99: "Cancelado"
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] == 1,
          title: Row(
            children: <Widget>[
              Text(
                "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - ",
                style: TextStyle(color: Colors.grey[850]),
              ),
              Text(
                "${status[order.data["status"]]}",
                style: TextStyle(
                    color: order.data["status"] == 99
                        ? Colors.red
                        : order.data["status"] != 4
                            ? Colors.grey[850]
                            : Colors.green),
              )
            ],
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderViewPage(order)));
                    },
                    child: Column(
                      children: <Widget>[
                        OrderHeader(order),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: order.data["products"].map<Widget>((p) {
                            return ListTile(
                              title: Text(p["product"]["title"] +
                                  " " +
                                  (p["size"] != null ? p["size"] : "")),
                              subtitle:
                                  Text(p["category"] + "/" + p["productId"]),
                              trailing: Text(
                                p["quantity"].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          order.reference.updateData({"status": 99});
                        },
                        textColor: Colors.red,
                        child: Text("CANCELAR"),
                      ),
                      order.data["status"] != 99
                          ? FlatButton(
                              onPressed: order.data["status"] > 1 &&
                                      order.data["status"] != 99
                                  ? () {
                                      order.reference.updateData(
                                          {"status": order.data["status"] - 1});
                                    }
                                  : null,
                              textColor: Colors.grey[850],
                              child: Text("REGREDIR"),
                            )
                          : Container(),
                      order.data["status"] != 99
                          ? FlatButton(
                              onPressed: order.data["status"] < 5
                                  ? () {
                                      order.reference.updateData(
                                          {"status": order.data["status"] + 1});
                                    }
                                  : null,
                              textColor: Colors.green,
                              child: Text("AVANÇAR"),
                            )
                          : FlatButton(
                              onPressed: () {
                                order.reference.updateData({"status": 2});
                              },
                              textColor: Colors.green,
                              child: Text("ATIVAR"),
                            ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
