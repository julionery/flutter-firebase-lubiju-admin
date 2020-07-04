import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lubijuadmin/blocs/contactus_bloc.dart';
import 'package:lubijuadmin/blocs/coupons_bloc.dart';
import 'package:lubijuadmin/blocs/news_list_bloc.dart';
import 'package:lubijuadmin/blocs/orders_bloc.dart';
import 'package:lubijuadmin/blocs/place_list_bloc.dart';
import 'package:lubijuadmin/blocs/user_bloc.dart';
import 'package:lubijuadmin/ui/pages/news_page.dart';
import 'package:lubijuadmin/ui/pages/place_page.dart';
import 'package:lubijuadmin/ui/tabs/contactus_tab.dart';
import 'package:lubijuadmin/ui/tabs/coupons_tab.dart';
import 'package:lubijuadmin/ui/tabs/news_tab.dart';
import 'package:lubijuadmin/ui/tabs/orders_tab.dart';
import 'package:lubijuadmin/ui/tabs/places_tab.dart';
import 'package:lubijuadmin/ui/tabs/products_tab.dart';
import 'package:lubijuadmin/ui/tabs/users_tab.dart';
import 'package:lubijuadmin/ui/widgets/add_coupon_dialog.dart';
import 'package:lubijuadmin/ui/widgets/edit_category_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;
  NewsListBloc _newsBloc;
  PlaceListBloc _placeListBloc;
  ContactUsBloc _contactUsBloc;
  CouponsBloc _couponsBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserBloc();
    _newsBloc = NewsListBloc();
    _ordersBloc = OrdersBloc();
    _couponsBloc = CouponsBloc();
    _placeListBloc = PlaceListBloc();
    _contactUsBloc = ContactUsBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).primaryColor,
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white54))),
        child: BottomNavigationBar(
            currentIndex: _page,
            backgroundColor: Theme.of(context).primaryColor,
            onTap: (p) {
              _pageController.animateToPage(p,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Clientes")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), title: Text("Pedidos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.style), title: Text("Novidades")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Produtos")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard), title: Text("Cupons")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.store), title: Text("Lojas")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), title: Text("Mensagens"))
            ]),
      ),
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: BlocProvider<CouponsBloc>(
              bloc: _couponsBloc,
              child: BlocProvider<NewsListBloc>(
                bloc: _newsBloc,
                child: BlocProvider<ContactUsBloc>(
                  bloc: _contactUsBloc,
                  child: BlocProvider<PlaceListBloc>(
                    bloc: _placeListBloc,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (p) {
                        setState(() {
                          _page = p;
                        });
                      },
                      children: <Widget>[
                        UsersTab(),
                        OrdersTab(),
                        NewsTab(),
                        ProductsTab(),
                        CouponsTab(),
                        PlacesTab(),
                        ContactUsTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Theme.of(context).primaryColor,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).primaryColor,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Theme.of(context).primaryColor,
                ),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
                })
          ],
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewsPage()));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        );
      case 3:
        return FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => EditCategoryDialog());
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        );
      case 4:
        return FloatingActionButton(
          onPressed: () async {
            Map<String, String> coupon = await showDialog(
                context: context, builder: (context) => AddCouponDialog());
            if (coupon != null)
              await Firestore.instance
                  .collection("coupons")
                  .document(coupon["code"])
                  .setData({
                "percent": double.parse(coupon["percent"]),
              });
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        );
      case 5:
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PlacePage()));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        );
      default:
        return Container();
    }
  }
}
