import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/place_bloc.dart';
import 'package:lubijuadmin/ui/widgets/image_source_sheet.dart';
import 'package:lubijuadmin/ui/widgets/network_image.dart';

class PlacePage extends StatefulWidget {
  final DocumentSnapshot place;

  PlacePage({this.place});

  @override
  _PlacePageState createState() => _PlacePageState(place);
}

class _PlacePageState extends State<PlacePage> {
  final PlaceBloc _placeBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _xFocus = FocusNode();
  final _yFocus = FocusNode();

  _PlacePageState(DocumentSnapshot place)
      : _placeBloc = PlaceBloc(place: place);

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(fontSize: 16);

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(labelText: label);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _placeBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data ? "Editar Novidade" : "Adicionar Novidade");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _placeBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _placeBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _deletePlace(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _placeBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : _savePlace,
                );
              }),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: StreamBuilder<Map>(
              stream: _placeBloc.outData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: snapshot.data["title"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _placeBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["address"],
                        style: _fieldStyle,
                        maxLines: 3,
                        decoration: _buildDecoration("Endereço"),
                        onSaved: _placeBloc.saveAddress,
                        validator: validateAddress,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["phone"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Telefone"),
                        onSaved: _placeBloc.savePhone,
                        validator: validatePhone,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Imagens",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: snapshot.data["image"] != null
                              ? PNetworkImage(
                                  snapshot.data["image"],
                                  fit: BoxFit.cover,
                                )
                              : _placeBloc.image == null
                                  ? Icon(
                                      Icons.camera_enhance,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Image.file(
                                      _placeBloc.image,
                                      fit: BoxFit.cover,
                                    ),
                          color: Colors.grey.withAlpha(50),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => ImageSourceSheet(
                                    onImageSelected: (image) {
                                      setState(() {
                                        _placeBloc.saveImage(image);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ));
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        focusNode: _xFocus,
                        initialValue: snapshot.data["lat"].toString(),
                        style: _fieldStyle,
                        keyboardType: TextInputType.number,
                        decoration: _buildDecoration("Latitude"),
                        onSaved: (value) =>
                            _placeBloc.saveLat(double.parse(value.trim())),
                        validator: validateTitle,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_yFocus);
                        },
                      ),
                      TextFormField(
                        focusNode: _yFocus,
                        keyboardType: TextInputType.number,
                        initialValue: snapshot.data["long"].toString(),
                        style: _fieldStyle,
                        decoration: _buildDecoration("Longitude"),
                        onSaved: (value) =>
                            _placeBloc.saveLong(double.parse(value.trim())),
                        validator: validateTitle,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  void _deletePlace(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar este registro?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                _placeBloc.deletePlace();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o título da loja.";
    return null;
  }

  String validateAddress(String text) {
    if (text.isEmpty) return "Preencha o endereço da loja.";
    return null;
  }

  String validatePhone(String text) {
    if (text.isEmpty) return "Preencha o telefone da loja.";
    return null;
  }

  void _savePlace() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando a loja...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _placeBloc.savePlace();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Loja salva!" : "Erro ao salvar a Loja!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
