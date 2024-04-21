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
        debugShowCheckedModeBanner: false, // 不显示右上角的 debug
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/", // 注册路由表
        routes: {
          "/": (context) => const LoginPage(title: "登录"), // 首页路由
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
        key: _formKey, // 设置globalKey，用于后面获取FormStat
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
            //  const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
            buildTitle(), // Login
            // buildTitleLine(), // Login下面的下划线
            const SizedBox(height: 10),
            buildEmailTextField(), // 输入邮箱
            const SizedBox(height: 15),
            buildPasswordTextField(context), // 输入密码
            const SizedBox(height: 30),
            buildLoginButton(context), // 登录按钮
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
              // 设置圆角
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(
            'Login',
          ),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              //TODO 执行登录方法
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
            obscureText: _isObscure, // 是否显示文字
            onSaved: (v) => _password = v!,
            validator: (v) {
              if (v!.isEmpty) {
                return '请输入密码';
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
                    // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
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
              return '请输入正确的邮箱地址';
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
