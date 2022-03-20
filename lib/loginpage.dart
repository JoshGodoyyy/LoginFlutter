import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*A declaração _formKey é responsável por verificar
   *se o usuário digitou algum dado errado ou não
   */
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Por favor, digite seu email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(_emailController.text)) {
                      return 'Por favor, digite um email válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return 'Por favor, digite sua senha';
                    } else if (senha.length < 6) {
                      return 'Por favor, digite uma senha válida';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (_formKey.currentState!.validate()) {
                      bool isTrue = await login();
                      if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                      if (isTrue) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } else {
                        _passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: const Text('Entrar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final snackBar = const SnackBar(
    content: Text('email e/ou senha inválido(s)', textAlign: TextAlign.center),
    backgroundColor: Colors.redAccent,
  );

  /*A função login é tipada como Future<bool> pois tem que aguardar
   *o retorno da API e então vai retornar verdadeiro ou falso
   */
  Future<bool> login() async {
    //Inicialização do sharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //Definindo a URL da API para acesso
    var url = Uri.parse('InserirMinhaURL');
    //Enviando dados em mapa para a API para verificação
    var response = await http.post(url, body: {
      'username': _emailController.text,
      'password': _passwordController.text,
    });
    //O resultado 200 é padrão de retorno de servidor, indicando que deu certo
    if (response.statusCode == 200) {
      await sharedPreferences.setString(
          'token', "Token ${json.decode(response.body)['token']}");
      return true;
    } else {
      return false;
    }
  }
}
