import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/coupons_bloc.dart';
import 'package:lubijuadmin/ui/tiles/coupon_tile.dart';

class CouponsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _couponsBloc = BlocProvider.of<CouponsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cupons"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder<List>(
            stream: _couponsBloc.outCoupons,
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
                        "Nenhum cupom encontrado!",
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
                      return CouponTile(snapshot.data[index]);
                    });
            }),
      ),
    );
  }
}
