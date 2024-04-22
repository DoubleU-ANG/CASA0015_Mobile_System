import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import './pages/tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const LoginPage(title: "LOGIN"),
          "/tab": (context) => const Tabs(),
        });
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            Container(
              height: 240,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 240,
                    width: width,
                    child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('images/2.0x/background.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    height: 240,
                    width: width + 20,
                    child: FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'images/2.0x/background-2.png'),
                                  fit: BoxFit.fill)),
                        )),
                  )
                ],
              ),
            ),

            buildTitle(), // Login

            const SizedBox(height: 15),
            buildEmailTextField(),
            const SizedBox(height: 15),
            buildPasswordTextField(context),
            const SizedBox(height: 30),
            buildLoginButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(
            'Login',
          ),
          onPressed: () {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();

              print('email: $_email, password: $_password');
              Navigator.pushNamed(context, '/tab');
            }
          },
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
            obscureText: _isObscure,
            onSaved: (v) => _password = v!,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Please enter your password';
              }
            },
            decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: _eyeColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                      _eyeColor = (_isObscure
                          ? Colors.grey
                          : Theme.of(context).iconTheme.color)!;
                    });
                  },
                ))));
  }

  Widget buildEmailTextField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Email Address'),
          validator: (v) {
            var emailReg = RegExp(
                r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
            if (!emailReg.hasMatch(v!)) {
              return 'Please enter your e-mail';
            }
          },
          onSaved: (v) => _email = v!,
        ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
        child: Text(
          'LOGIN',
          style: TextStyle(fontSize: 40),
        ));
  }
}
