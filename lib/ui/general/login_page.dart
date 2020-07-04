import 'package:flutter/material.dart';
import 'package:lubijuadmin/blocs/login_bloc.dart';
import 'package:lubijuadmin/ui/pages/home_page.dart';
import 'package:lubijuadmin/ui/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc();
  final _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Error..."),
                    content:
                        Text("Você não possui os privilégios necessários."),
                  ));
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
              case LoginState.SUCCESS:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                );
                break;
              case LoginState.IDLE:
              case LoginState.FAIL:
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(),
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 155.0,
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 16.0),
                              child: InputField(
                                icon: Icons.person_outline,
                                hint: "E-mail",
                                obscure: false,
                                stream: _loginBloc.outEmail,
                                onChanged: _loginBloc.changeEmail,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(_passFocus);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InputField(
                                focusNode: _passFocus,
                                icon: Icons.lock_outline,
                                hint: "Senha",
                                obscure: true,
                                stream: _loginBloc.outPassword,
                                onChanged: _loginBloc.changePassword,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            StreamBuilder<bool>(
                                stream: _loginBloc.outSubmitValid,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    height: 50,
                                    child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        "ENTRAR",
                                      ),
                                      onPressed: snapshot.hasData
                                          ? _loginBloc.submit
                                          : null,
                                      textColor: Colors.white,
                                      disabledColor: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(140),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ],
                );
                break;
              default:
                return Container();
                break;
            }
          }),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
