import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/place_list_bloc.dart';
import 'package:lubijuadmin/ui/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _placeBloc = BlocProvider.of<PlaceListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lojas"),
        centerTitle: true,
      ),
      body: StreamBuilder<List>(
          stream: _placeBloc.outPlace,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              );
            else if (snapshot.data.length == 0)
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.grid_off,
                      size: 80.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Nenhum registro encontrado!",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            else {
              return ListView(
                children: snapshot.data.map((doc) => PlaceTile(doc)).toList(),
              );
            }
          }),
    );
  }
}
