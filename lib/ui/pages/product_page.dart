import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/product_bloc.dart';
import 'package:lubijuadmin/ui/lists/size_list.dart';
import 'package:lubijuadmin/ui/widgets/color_sizes.dart';
import 'package:lubijuadmin/ui/widgets/images_widget.dart';
import 'package:lubijuadmin/ui/widgets/product_sizes.dart';

class ProductPage extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductPage({this.categoryId, this.product});

  @override
  _ProductPageState createState() => _ProductPageState(categoryId, product);
}

class _ProductPageState extends State<ProductPage> {
  final ProductBloc _productBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onChanged1(bool value) =>
      setState(() => _productBloc.saveActive(value));
  void _onChanged2(bool value) =>
      setState(() => _productBloc.saveHasSize(value));
  void _onChanged3(bool value) =>
      setState(() => _productBloc.saveHasColor(value));

  _ProductPageState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductBloc(categoryId: categoryId, product: product);

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
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data)
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _deleteProduct(context);
                              },
                      );
                    });
              else
                return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveProduct,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: EdgeInsets.all(16),
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
                          new Switch(
                              value: snapshot.data["active"] != null
                                  ? snapshot.data["active"]
                                  : false,
                              onChanged: _onChanged1),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Pussui tamanhos?",
                            style: TextStyle(
                                color: Colors.grey[650],
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          new Switch(
                              value: snapshot.data["hasSize"] != null
                                  ? snapshot.data["hasSize"]
                                  : false,
                              onChanged: _onChanged2),
                        ],
                      ),
                      (snapshot.data["hasSize"] != null
                              ? snapshot.data["hasSize"]
                              : false)
                          ? Container(
                              child: Text(
                                  "As cores e quantidade serão definidas pelo tamanho."),
                            )
                          : Row(
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
                                    value: snapshot.data["hasColor"] != null
                                        ? snapshot.data["hasColor"]
                                        : false,
                                    onChanged: _onChanged3),
                              ],
                            ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Imagens",
                        style: TextStyle(fontSize: 12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["title"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["description"],
                        style: _fieldStyle,
                        maxLines: 4,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _productBloc.saveDescription,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["price"] != null
                            ? snapshot.data["price"]?.toStringAsFixed(2)
                            : "10.00",
                        style: _fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      snapshot.data["hasSize"] || snapshot.data["hasColor"]
                          ? Container()
                          : TextFormField(
                              initialValue:
                                  snapshot.data["quantity"].toString(),
                              style: _fieldStyle,
                              decoration:
                                  _buildDecoration("Quantidade Disponível"),
                              keyboardType: TextInputType.number,
                              onSaved: _productBloc.saveQuantity,
                              validator: validateQuantity,
                            ),
                      SizedBox(
                        height: 16,
                      ),
                      snapshot.data["title"] != null && snapshot.data["hasSize"]
                          ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text("GERENCIAR TAMANHOS"),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => SizeList(
                                                  widget.categoryId,
                                                  widget.product.documentID,
                                                  widget
                                                      .product.data["title"])));
                                    },
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          : snapshot.data["hasSize"]
                              ? Text(
                                  "Tamanhos:",
                                  style: TextStyle(fontSize: 14),
                                )
                              : Container(),
                      snapshot.data["title"] != null
                          ? Container()
                          : snapshot.data["hasSize"]
                              ? ProductSizes(
                                  context: context,
                                  initialValue: snapshot.data["sizes"],
                                  onSaved: _productBloc.saveSizes,
                                )
                              : Container(),
                      SizedBox(
                        height: 16,
                      ),
                      snapshot.data["hasSize"]
                          ? SizedBox(
                              height: 8,
                            )
                          : Container(),
                      !snapshot.data["hasSize"] && snapshot.data["hasColor"]
                          ? Text(
                              "Cores:",
                              style: TextStyle(fontSize: 14),
                            )
                          : Container(),
                      !snapshot.data["hasSize"] && snapshot.data["hasColor"]
                          ? ColorSizes(
                              context: context,
                              initialValue: snapshot.data["colors"],
                              onSaved: _productBloc.saveColors,
                              validator: (s) {
                                if (s.isEmpty) return "";
                                return null;
                              },
                            )
                          : Container(),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void _deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar?"),
          content: new Text("Deseja realmente deletar este produto?"),
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
                _productBloc.deleteProduct();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateImages(List images) {
    if (images.isEmpty) return "Adicione imagens do produto";
    return null;
  }

  String validateTitle(String text) {
    if (text.isEmpty) return "Preencha o título do produto";
    return null;
  }

  String validateQuantity(String text) {
    if (text.isEmpty) return "Preencha a quantidade";
    if (widget.product == null && int.parse(text) <= 0)
      return "Informe a quantidade";
    return null;
  }

  String validatePrice(String text) {
    double price = double.tryParse(text);
    if (price != null) {
      if (!text.contains(".")) text += ".00";
      if (text.split(".")[1].length != 2) return "Utilize 2 casas decimais";
    } else {
      return "Preço inválido";
    }
    return null;
  }

  void saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando produto...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      String uID = await _productBloc.saveProduct();
      print(uID);
      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          uID != null ? "Produto salvo!" : "Erro ao salvar produto!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: uID != null ? Colors.green : Colors.red,
      ));

      if (uID != null) {
        if (widget.product == null && _productBloc.unsavedData["hasSize"]) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SizeList(
                  widget.categoryId, uID, _productBloc.unsavedData["title"])));
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }
}
