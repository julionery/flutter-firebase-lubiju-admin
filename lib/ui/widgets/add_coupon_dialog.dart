import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCouponDialog extends StatefulWidget {
  final DocumentSnapshot coupon;

  const AddCouponDialog({this.coupon});

  @override
  _AddCouponDialogState createState() => _AddCouponDialogState();
}

class _AddCouponDialogState extends State<AddCouponDialog> {
  var _controllerCode = TextEditingController();

  var _controllerPercent = TextEditingController();

  _AddCouponDialogState();

  @override
  void initState() {
    super.initState();
    _controllerCode.text =
        widget.coupon != null ? widget.coupon.documentID : "";
    _controllerPercent.text =
        widget.coupon != null ? widget.coupon.data["percent"].toString() : "";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.coupon != null
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Text(
                      "Código:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
            widget.coupon != null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      enabled: widget.coupon == null,
                      controller: _controllerCode,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Text(
                "Percentual:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                controller: _controllerPercent,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("SALVAR"),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  if (double.parse(_controllerPercent.text.trim()) > 100)
                    _erroAlert(context, false);
                  else if (double.parse(_controllerPercent.text.trim()) < 0)
                    _erroAlert(context, true);
                  else {
                    Map<String, String> item = {
                      "code": _controllerCode.text.trim().toUpperCase(),
                      "percent": _controllerPercent.text.trim(),
                    };
                    Navigator.of(context).pop(item);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _erroAlert(BuildContext context, bool negative) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Oooops..."),
          content: new Text(
              "Percentual ${negative ? "abaixo dos 0" : "acima dos 100"}%"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
