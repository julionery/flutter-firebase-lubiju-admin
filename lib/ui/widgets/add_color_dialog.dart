import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';

class AddColorDialog extends StatefulWidget {
  @override
  _AddColorDialogState createState() => _AddColorDialogState();
}

class _AddColorDialogState extends State<AddColorDialog> {
  Color pickerColor = Color(0xffffffff);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('SELECIONE UMA COR'),
      content: SingleChildScrollView(
//        child: ColorPicker(
//          pickerColor: pickerColor,
//          enableLabel: true,
//          pickerAreaHeightPercent: 0.8,
//        ),
        // Use Material color picker:
        //
        child: MaterialPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          enableLabel: true, // only on portrait mode
        ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            String selectedColor = pickerColor
                .toString()
                .replaceAll("Color(0xff", "#")
                .replaceAll(")", "");
            Navigator.of(context).pop(selectedColor);
          },
        ),
      ],
    );
  }
}
