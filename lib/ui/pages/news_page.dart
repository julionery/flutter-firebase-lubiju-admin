import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/news_bloc.dart';
import 'package:lubijuadmin/ui/widgets/image_source_sheet.dart';
import 'package:lubijuadmin/ui/widgets/network_image.dart';

class NewsPage extends StatefulWidget {
  final DocumentSnapshot news;

  NewsPage({this.news});

  @override
  _NewsPageState createState() => _NewsPageState(news);
}

class _NewsPageState extends State<NewsPage> {
  final NewsBloc _newsBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _xFocus = FocusNode();
  final _yFocus = FocusNode();

  void _onChanged1(bool value) => setState(() => _newsBloc.saveActive(value));

  _NewsPageState(DocumentSnapshot news) : _newsBloc = NewsBloc(news: news);

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
            stream: _newsBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data ? "Editar Novidade" : "Adicionar Novidade");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _newsBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _newsBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _deleteNews(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _newsBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : _saveNews,
                );
              }),
        ],
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder<Map>(
            stream: _newsBloc.outData,
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
                          "Ativo?",
                          style: TextStyle(
                              color: Colors.grey[650],
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                            value: snapshot.data["active"] != null
                                ? snapshot.data["active"]
                                : false,
                            onChanged: _onChanged1),
                      ],
                    ),
                    Text(
                      "Imagens",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 8,
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
                            : _newsBloc.image == null
                                ? Icon(
                                    Icons.camera_enhance,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : Image.file(
                                    _newsBloc.image,
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
                                      _newsBloc.saveImage(image);
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
                      initialValue: snapshot.data["x"].toString(),
                      style: _fieldStyle,
                      keyboardType: TextInputType.number,
                      decoration: _buildDecoration("Largura (Blocos)"),
                      onSaved: _newsBloc.saveX,
                      validator: validateX,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_yFocus);
                      },
                    ),
                    TextFormField(
                      focusNode: _yFocus,
                      keyboardType: TextInputType.number,
                      initialValue: snapshot.data["y"].toString(),
                      style: _fieldStyle,
                      decoration: _buildDecoration("Altura (Blocos)"),
                      onSaved: _newsBloc.saveY,
                      validator: validateY,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _deleteNews(BuildContext context) {
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
                _newsBloc.deleteNews();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateX(String text) {
    if (text.isEmpty) return "Preencha o Largura";
    if (int.parse(text.trim()) < 0) return "O X tem q ser maior que 0";
    return null;
  }

  String validateY(String text) {
    if (text.isEmpty) return "Preencha o Altura";
    if (int.parse(text.trim()) < 0) return "O Y tem q ser maior que 0";
    return null;
  }

  void _saveNews() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando registro...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      bool success = await _newsBloc.saveNews();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Registro salvo!" : "Erro ao salvar o registro!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.of(context).pop();
    }
  }
}
