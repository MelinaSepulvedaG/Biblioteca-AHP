import 'package:flutter/material.dart';

import 'calculos.dart';

import 'historial.dart';
import 'resultados.dart';

void main() {
  runApp(LoginApp());
}

//PANTALLA LOGIN
//////////////////////////////

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Nombre',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusColor: const Color.fromRGBO(33, 150, 243, 1)),
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                // _nombre = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Contraseña',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )),
            cursorColor: Colors.blue,
            obscureText: true,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                // _nombre = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
              child: Text('Iniciar Sesión'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Inicio de sesión exitoso');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
          SizedBox(height: 20),
          // ElevatedButton(
          //     child: Text('Continuar sin registrar'),
          //     onPressed: () {
          //       if (_formKey.currentState!.validate()) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => HomePage()),
          //         );
          //       }
          //     },
          //     style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.blue, foregroundColor: Colors.white)),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              // Navegar a la página de registro
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child: Text('¿No tienes una cuenta? Regístrate aquí'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
          TextButton(
            onPressed: () {
              // Navegar a la página de recuperación de contraseña
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              );
            },
            child: Text('¿Olvidaste tu contraseña?'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
        ],
      ),
    );
  }
}

//PANTALLA REGISTRO USUARIO
////////////////////////////////
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Nombre',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )),
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                // _nombre = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )),
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu correo electrónico';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                // _nombre = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Contraseña',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                // _password = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Implementar la lógica de registro de usuario aquí
                  print('Usuario registrado exitosamente');
                }
              },
              child: Text('Registrarse'),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
        ],
      ),
    );
  }
}

//PANTALLA CAMBIAR CONTRA
//////////////////
class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ForgotPasswordForm(),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )),
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu correo electrónico';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Implementar la lógica de recuperación de contraseña aquí
                  print('Correo de recuperación enviado a $_email');
                }
              },
              child: Text('Recuperar Contraseña'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
        ],
      ),
    );
  }
}

//PANTALLA PRINCIPAL
//////////////////////////////////
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeForm(),
    CalculosPage(),
    History(),
    Configuracion(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca MADM'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Bienvenido a la pantalla principal :)'),
      ),
    );
  }
}

//PANTALLA HISTORIAL
//////////////////////////

//PANTALLA CALCULOS
///////////////////////////
class CalculosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CalculosForm(),
        ),
      ),
    );
  }
}

//PANTALLA ALTERNATIVAS
///////////////////////
class AlternativasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algoritmo AHP'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: AlternativasForm(),
        ),
      ),
    );
  }
}

//PANTALLA MATRIZ
//////////////////////

class MatrizComparacionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algoritmo AHP'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: MatrizComparacionForm(),
        ),
      ),
    );
  }
}

//PANTALLA  RESULTADOS
//////////////////////
class ResultadosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ResultadoForm(),
        ),
      ),
    );
  }
}

//PANTALLA CONFIGURACION
//////////////////
class Configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        OutlinedButton(
          onPressed: () {
            // Navegar a la página de registro
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: const Text(
            'Cerrar Sesion',
            style: TextStyle(fontSize: 20),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            // Navegar a la página de registro
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            );
          },
          child: const Text(
            'Cambiar contraseña',
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    ));
  }
}
