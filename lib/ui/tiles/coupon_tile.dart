import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/ui/widgets/add_coupon_dialog.dart';

class CouponTile extends StatelessWidget {
  final DocumentSnapshot coupon;

  CouponTile(this.coupon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: () async {
          Map<String, String> _coupon = await showDialog(
              context: context,
              builder: (context) => AddCouponDialog(
                    coupon: coupon,
                  ));
          if (_coupon != null)
            await Firestore.instance
                .collection("coupons")
                .document(_coupon["code"])
                .setData({
              "percent": double.parse(_coupon["percent"]),
            });
        },
        onLongPress: () {
          coupon.reference.delete();
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${coupon.documentID}",
                  style: TextStyle(
                      color: Colors.grey[450],
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Text("${coupon["percent"]}%",
                    style: TextStyle(
                        color: Colors.grey[450],
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
