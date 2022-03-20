import 'package:flutter/material.dart';
import 'package:login/homepage.dart';
import 'package:login/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoasVindas extends StatefulWidget {
  const BoasVindas({Key? key}) : super(key: key);

  @override
  State<BoasVindas> createState() => _BoasVindasState();
}

class _BoasVindasState extends State<BoasVindas> {
  /*Instancia o initState para ser a primeira função a ser executada
   *ao iniciar a execução da página
   */
  @override
  void initState() {
    super.initState();
    /*Verifica se o token existe ou não, só é possível utilizar o then
     *porque a função verificarToken foi tipada como Future
     */
    verificarToken().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /*Sempre que se faz login com API, é gerado um token,
   *essa função armazena o token para comunicação com a API
   */

  /*Por ter que aguardar a execução da função de verificar o usuário,
   *é preciso definir a tipagem da função como futura, por ser uma
   *função com retorno verdadeiro ou falso, é definida como bool
   */
  Future<bool> verificarToken() async {
    /*Por ter que aguardar para armazenar o token, é preciso
     *aguardar a inicialização para comunicar com o SharedPreferences
     */
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //Verifica se já existe um usuário com aquele token
    if (sharedPreferences.getString('token') == null) {
      return false;
    } else {
      return true;
    }
  }
}
