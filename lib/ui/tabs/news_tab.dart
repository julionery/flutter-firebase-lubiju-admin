import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lubijuadmin/blocs/news_list_bloc.dart';
import 'package:lubijuadmin/ui/pages/news_page.dart';
import 'package:lubijuadmin/ui/widgets/network_image.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _newsBloc = BlocProvider.of<NewsListBloc>(context);

    return StreamBuilder<List>(
        stream: _newsBloc.outNews,
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
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text("Novidades"),
                    centerTitle: true,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("home")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 200.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                        );
                      else
                        return SliverStaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          staggeredTiles: snapshot.data.documents.map((doc) {
                            return StaggeredTile.count(
                                doc.data["x"], doc.data["y"]);
                          }).toList(),
                          children: snapshot.data.documents.map((doc) {
                            if (doc.data["image"] == null)
                              return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor));
                            else
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          NewsPage(news: doc)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: PNetworkImage(
                                    doc.data["image"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                          }).toList(),
                        );
                    },
                  ),
                )
              ],
            );
          }
        });
  }
}
