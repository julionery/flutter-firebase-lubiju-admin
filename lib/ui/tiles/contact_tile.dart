import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lubijuadmin/ui/views/contactus_page.dart';

class ContactUsTile extends StatelessWidget {
  final DocumentSnapshot message;

  ContactUsTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactUsPage(message)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 16.0, right: 8.0, bottom: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${DateFormat('dd-MM-yyyy – kk:mm').format(message["date"].toDate())}: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "${message["message"]}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
