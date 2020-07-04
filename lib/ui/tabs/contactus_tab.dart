import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/contactus_bloc.dart';
import 'package:lubijuadmin/ui/tiles/contact_tile.dart';

class ContactUsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _contactUsBloc = BlocProvider.of<ContactUsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mensagens"),
        centerTitle: true,
      ),
      body: StreamBuilder<List>(
          stream: _contactUsBloc.outContactUs,
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
                      "Nenhuma mensagem encontrada!",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ContactUsTile(snapshot.data[index]);
                  });
          }),
    );
  }
}
