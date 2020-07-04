import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tamanho:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                controller: _controller,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("ADICIONAR"),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pop(_controller.text.trim().toUpperCase());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
