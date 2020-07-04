import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/user_bloc.dart';
import 'package:lubijuadmin/ui/tiles/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  hintText: "Pesquisar",
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: InputBorder.none),
              onChanged: _userBloc.onChangedSearch,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  );
                else if (snapshot.data.length == 0)
                  return Center(
                    child: Text(
                      "Nenhum usuário encontrado!",
                    ),
                  );
                else
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return UserTile(snapshot.data[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Container();
                      },
                      itemCount: snapshot.data.length);
              }),
        )
      ],
    );
  }
}
