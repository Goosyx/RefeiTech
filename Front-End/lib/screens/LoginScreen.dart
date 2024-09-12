import 'package:flutter/material.dart';
import 'package:refeitech/services/api_service.dart';
import 'AdminScreens/AdminHome.dart';
import 'UserScreens/WelcomeScreen.dart';
import 'package:refeitech/services/cookie_api.dart';
import 'package:refeitech/services/global_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _raController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _clearCart() async {
    try {
      await CookieService.clearCart(); // Limpa o carrinho
    } catch (e) {
      print('Erro ao limpar o carrinho: $e');
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String ra = _raController.text;
      String password = _passwordController.text;

      var jsonResponse = await CookieService.login(ra, password);

      if (jsonResponse != null && jsonResponse['status'] == 'success') {
        // Store RA in UserSession
        UserSession().setRA(ra);
        GlobalState.userRA = ra;

        if (jsonResponse['user_type'] == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse?['message'] ?? 'Erro ao fazer login'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png', // Caminho para a imagem de fundo
              fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Logo ou outra imagem
                      Image.asset(
                        'assets/images/logo_image.png', // Caminho para a imagem do logo
                        height: 200, // Ajuste a altura conforme necessário
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _raController,
                              decoration: InputDecoration(
                                hintText: 'RA',
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1E2328), width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu RA';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Senha',
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1E2328), width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira sua senha';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                              onPressed: () {
                                _clearCart();
                                _login();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2328),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal:
                                      40.0, // Adiciona um padding horizontal
                                ),
                                minimumSize:
                                    const Size(200, 50), // Tamanho mínimo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            TextButton(
                              onPressed: () {
                                // Adicione a ação para "Esqueceu a senha?"
                              },
                              child: const Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                    color: Color(0xFF1E2328),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
