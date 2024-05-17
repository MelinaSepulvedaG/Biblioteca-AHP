import 'package:flutter/material.dart';
import 'calculos.dart';
import 'historial.dart';
import 'resultados.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  //variables para tomar lo que hay en los textfield
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
// peticion post para el login
  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: jsonEncode(<String, String>{
        'nombre': _nombreController.text,
        'password': _passwordController.text,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('si jala');
      _message = responseData['mensaje'];

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      showSuccessSnackbar(context, _message);
    } else {
      print('no jala');
      print(_message);
      _message = responseData['mensaje'];
    }
  }

//mensaje flotante
  void showSuccessSnackbar(BuildContext context, String _message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

//widget del login
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _nombreController,
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
            controller: _passwordController,
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
                _login();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)),
          SizedBox(height: 20),
          Text(_message),
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
  // variables para tomar el valor de los textfield
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _message = '';
// peticion post para el login
  Future<void> _registrarUsuario() async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/registro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: jsonEncode(<String, String>{
        'nombre': _nombreController.text,
        'password': _passwordController.text,
        'email': _correoController.text
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('si jala');
      _message = responseData['mensaje'];
      showSuccessSnackbar(context, _message);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      print('no jala');
      print(_message);
      _message = responseData['mensaje'];
    }
  }

  //mensaje flotante
  void showSuccessSnackbar(BuildContext context, String _message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

//wiidget del formulario de registro
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _nombreController,
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
            controller: _correoController,
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
            controller: _passwordController,
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
                _registrarUsuario();
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
class ActualizarContraPage extends StatelessWidget {
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
          child: ActualizarContraForm(),
        ),
      ),
    );
  }
}

class ActualizarContraForm extends StatefulWidget {
  @override
  _ActualizarContraFormState createState() => _ActualizarContraFormState();
}

class _ActualizarContraFormState extends State<ActualizarContraForm> {
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
                labelText: 'Contraseña Actual',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )),
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu contraseña actual';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Contraseña Nueva',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )),
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == "") {
                return 'Por favor ingresa tu nueva contraseña';
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
              onPressed: () {},
              child: Text('Actualizar Contraseña'),
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
        child: Text("Bienvenido"),
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
            // Navegar al login
            Navigator.pushReplacement(
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ActualizarContraPage()),
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
