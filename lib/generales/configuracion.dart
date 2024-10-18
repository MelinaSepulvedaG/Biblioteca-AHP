import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/main.dart';

class Configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botón para cambiar la contraseña
            ElevatedButton.icon(
              icon: Icon(Icons.edit_rounded),
              label: const Text('Cambiar Contraseña'),
              onPressed: () {
                // Navegar a la página de actualización de contraseña
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActualizarContraPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            // Botón para cerrar sesión
            ElevatedButton.icon(
              icon: Icon(Icons.logout_sharp),
              label: Text('Cerrar Sesión'),
              onPressed: () async {
                // Borrar el ID de usuario del almacenamiento local
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('idUsuario');
                // Navegar al login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}