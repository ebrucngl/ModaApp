import 'package:flutter/material.dart';
import 'package:tasarim_calismasi/anasayfa.dart';
import 'package:tasarim_calismasi/Pages/sifreyenile.dart';
import 'package:tasarim_calismasi/Pages/yenihesap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasarim_calismasi/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Login(),
      '/anasayfa': (context) => Anasayfa(),
      'sifreyenile': (context) => SifreSifirla(),
    },
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://static.vecteezy.com/system/resources/previews/000/278/317/original/pastel-background-vector.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 400,
                child: Card(
                  elevation: 4.0,
                  color: Colors.white70,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Color(0xFF000000)),
                          cursorColor: Color(0xFF9b9b9b),
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.checkroom,
                              color: Colors.grey,
                            ),
                            hintText: "e-mail",
                            hintStyle: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          style: TextStyle(color: Color(0xFF000000)),
                          cursorColor: Color(0xFF9b9b9b),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.checkroom,
                              color: Colors.grey,
                            ),
                            hintText: "şifre",
                            hintStyle: TextStyle(
                              color: Color(0xFF9b9b9b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SifreSifirla()),
                                );
                              },
                              child: Text(
                                "Şifreni mi unuttun?",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    height: 4.0,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.indigo[400],
                            ),
                            child: TextButton(
                              onPressed: () {
                                _authService
                                    .singIn(emailController.text,
                                        passwordController.text)
                                    .then(
                                      (value) => {
                                        Navigator.pushReplacementNamed(
                                            context, '/anasayfa'),
                                      },
                                    );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Text(
                                  "Giriş",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hesabın yok mu?",
                              style: TextStyle(
                                height: 3.0,
                                fontSize: 15,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YeniHesap()),
                                );
                              },
                              child: Text(
                                " Hesap oluştur.",
                                style: TextStyle(
                                  height: 3.0,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  color: Colors.indigo[400],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
