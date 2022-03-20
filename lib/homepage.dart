import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'boasvindas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () async {
          bool saiu = await sair();
          if (saiu) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BoasVindas()));
          }
        },
        child: const Text('Sair'),
      ),
    ));
  }

  Future<bool> sair() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }
}
