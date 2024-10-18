import 'package:flutter/material.dart';
import 'generales/historial.dart';
import 'calculos/resultados.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'calculos/criterios.dart';
import 'generales/configuracion.dart';
import 'calculos/alternativas.dart';

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
        automaticallyImplyLeading: false,
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
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool _verContra = false;

  // Petición POST para el login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // Si el formulario no es válido, salimos de la función
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
        },
        body: jsonEncode(<String, String>{
          'nombre': _nombreController.text,
          'password': _passwordController.text
        }),
      );

      print('Respuesta del servidor: ${response.body}');

      // Si la respuesta es OK 200 FLUJO NORMAL
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('respuesta $responseData');

        if (responseData.containsKey('idUsuario')) {
          String idUsuario = responseData['idUsuario'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('idUsuario', idUsuario);
          print('Login exitoso: $idUsuario');
          _message = responseData['mensaje'];

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          showSuccessSnackbar(context, _message);
        } else {
          _message = responseData['mensaje'] ?? 'Error en el login';
          showErrorSnackbar(context, _message);
          print(_message);
        }
      } else {
        _message = 'Error: ${response.statusCode}';
        showErrorSnackbar(context, _message);
        print(_message);
      }
    } catch (error) {
      _message = 'Error en la conexión: $error';
      showErrorSnackbar(context, _message);
      print(_message);
    }
  }

  // Widget del login
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
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
            ),
            cursorColor: Colors.blueGrey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
             
              suffixIcon: IconButton(
                icon: Icon(
                  _verContra ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _verContra = !_verContra;
                  });
                },
              ),
            ),
            cursorColor: Colors.blueGrey,
            obscureText: !_verContra,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
              child: Text('Iniciar Sesión'),
              onPressed: _login,
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

// Funciones para mostrar mensajes de éxito y error
void showSuccessSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  // peticion post para el registro
  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      // Si el formulario no es válido, salir
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/registro'),
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
      print('Registro exitoso');
      _message = responseData['mensaje'];
      showSuccessSnackbar(context, _message);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      print('Error en el registro');
      _message = responseData['mensaje'];
      showErrorSnackbar(context, _message); // Asegúrate de manejar el error
    }
  }

  // widget del formulario de registro
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
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
            ),
            cursorColor: Colors.blueGrey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _correoController,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
            ),
            cursorColor: Colors.blueGrey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo electrónico';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _registrarUsuario();
            },
            child: Text('Registrarse'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
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
  var objlogin = _LoginFormState(); // Asegúrate de que esta clase esté definida
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  String _message = '';
  bool _verContra1 = false;
  bool _verContra2 = false;

  Future<void> _actualizarContra() async {
    if (_formKey.currentState!.validate()) {
      // Validación del formulario
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/cambiar-contrasena'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(<String, String>{
          'nombre': objlogin._nombreController.text,
          'contrasena_actual': _passwordController.text,
          'nueva_contrasena': _newpasswordController.text,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('si jala');
        _message = responseData['mensaje'];
        showSuccessSnackbar(context, _message);
      } else {
        print('no jala');
        _message = responseData['mensaje'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña Actual',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _verContra1 ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _verContra1 = !_verContra1;
                  });
                },
              ),
            ),
            cursorColor: Colors.blueGrey,
            obscureText: !_verContra1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña actual';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _newpasswordController,
            decoration: InputDecoration(
              labelText: 'Contraseña Nueva',
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _verContra2 ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _verContra2 = !_verContra2;
                  });
                },
              ),
            ),
            obscureText: !_verContra2,
            cursorColor: Colors.blueGrey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nueva contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _actualizarContra();
            },
            child: Text('Actualizar Contraseña'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
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
    // History(),
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
        title: const Text('Biblioteca MADM'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculos',
          ),
          // BottomNavigationBarItem(
          // icon: Icon(Icons.history),
          // label: 'Historial',
          //  ),
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
    return const Center(
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
          padding: const EdgeInsets.all(20.0),
          child: CriteriosPage(),
        ),
      ),
    );
  }
}

//PANTALLA ALTERNATIVAS
///////////////////////
class AlternativasPage extends StatelessWidget {
  final List<String> criterios;
  late List<String> alternativas;
  final List<List<double>> matrizCriterios;

  AlternativasPage(
      {required this.criterios,
      required this.alternativas,
      required this.matrizCriterios});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AlternativasForm(
            criterios: criterios,
            matrizCriterios: matrizCriterios,
          ),
        ),
      ),
    );
  }
}

//PANTALLA  RESULTADOS
//////////////////////
class ResultadosPage extends StatelessWidget {
  final List<String> alternativas;
  final List<double> puntajes;

  ResultadosPage({required this.alternativas, required this.puntajes});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ResultadoForm(alternativas: alternativas, puntajes: puntajes),
        ),
      ),
    );
  }
}
