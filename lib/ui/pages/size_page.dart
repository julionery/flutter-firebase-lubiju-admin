import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/size_bloc.dart';
import 'package:lubijuadmin/ui/widgets/add_color_dialog.dart';

class SizePage extends StatefulWidget {
  final DocumentSnapshot size;
  final String categoryId;
  final String productId;
  final Stream<QuerySnapshot> colors;

  SizePage({this.size, this.categoryId, this.productId, this.colors});

  @override
  _SizePageState createState() =>
      _SizePageState(size, categoryId, productId, colors);
}

class _SizePageState extends State<SizePage> {
  final SizeBloc _sizeBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onChanged1(bool value) => setState(() => _sizeBloc.saveHasColor(value));

  _SizePageState(DocumentSnapshot size, String categoryId, String productId,
      Stream<QuerySnapshot> colors)
      : _sizeBloc = SizeBloc(
            size: size,
            categoryId: categoryId,
            productId: productId,
            colors: colors);

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
            stream: _sizeBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data ? "Editar Tamanho" : "Adicionar Tamanho");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _sizeBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _sizeBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _deleteSize(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _sizeBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : _saveSize,
                );
              }),
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
            stream: _sizeBloc.outData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Possui cores?",
                          style: TextStyle(
                              color: Colors.grey[650],
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        new Switch(
                            value: snapshot.data["hasColor"],
                            onChanged: _onChanged1),
                      ],
                    ),
                    TextFormField(
                      initialValue: snapshot.data["title"],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Título"),
                      onSaved: _sizeBloc.saveTitle,
                      validator: validateTitle,
                    ),
                    TextFormField(
                      initialValue: snapshot.data["order"].toString(),
                      style: _fieldStyle,
                      decoration: _buildDecoration("Ordem"),
                      onSaved: _sizeBloc.saveOrder,
                      validator: validateTitle,
                    ),
                    snapshot.data["hasColor"]
                        ? Expanded(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Cores:",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: GestureDetector(
                                        onTap: () async {
                                          String color = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddColorDialog());
                                          if (color != null)
                                            _sizeBloc.size.reference
                                                .collection("colors")
                                                .add({"color": color});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 3)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "+",
                                            style: TextStyle(fontSize: 36),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: _sizeBloc.colors,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Theme.of(context).primaryColor),
                                          ),
                                        );
                                      else if (snapshot.data.documents.length ==
                                          0)
                                        return Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text("Nenhuma cor encontrada!",
                                              style: TextStyle(
                                                fontSize: 26.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        );
                                      else
                                        return ListView(
                                          children: snapshot.data.documents
                                              .map((doc) => Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: 100,
                                                          child:
                                                              GestureDetector(
                                                                  onLongPress:
                                                                      () {
                                                                    snapshot.data.documents.length ==
                                                                            0 ??
                                                                        doc.reference
                                                                            .updateData({
                                                                          "hasColor":
                                                                              false
                                                                        });
                                                                    doc.reference
                                                                        .delete();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            width: 3.0)),
                                                                    height: 20,
                                                                    width: 20,
                                                                    child:
                                                                        Container(
                                                                      color: Color(int.parse(
                                                                              doc["color"].substring(1, 7),
                                                                              radix: 16) +
                                                                          0xFF000000),
                                                                    ),
                                                                  )),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                              .toList(),
                                        );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : TextFormField(
                            initialValue: snapshot.data["quantity"].toString(),
                            style: _fieldStyle,
                            decoration:
                                _buildDecoration("Quantidade Disponível"),
                            keyboardType: TextInputType.number,
                            onSaved: _sizeBloc.saveQuantity,
                          ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _deleteSize(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar este tamanho?"),
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
                _sizeBloc.deleteSize();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o título do produto";
    return null;
  }

  void _saveSize() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando tamanho...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _sizeBloc.saveSize();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Tamanho salvo!" : "Erro ao salvar tamanho!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
