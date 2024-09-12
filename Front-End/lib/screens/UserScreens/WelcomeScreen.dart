import 'package:flutter/material.dart';
import 'package:refeitech/screens/UserScreens/ShopScreens/ProductsHome.dart';
import 'package:refeitech/screens/UserScreens/AccountScreens/AccountScreen.dart';
import 'package:refeitech/screens/UserScreens/MenuScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image2.png', // Caminho para a imagem
              fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
            ),
          ),
          // Conteúdo da tela

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título de boas-vindas
                    const Text(
                      'Bem Vindo',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(
                            0xFF1E2328), // Texto em branco para melhor contraste
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40.0),
                    // Botão de produtos
                    _buildButton(
                      context,
                      'Produtos',
                      Icons.shopping_cart,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProductsHome()),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Botão de conta
                    _buildButton(
                      context,
                      'Conta',
                      Icons.person,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Botão de cardápio
                    _buildButton(
                      context,
                      'Cardápio',
                      Icons.menu,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para construir botões
  Widget _buildButton(BuildContext context, String label, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1E2328),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        minimumSize: const Size(200, 60),
      ),
      icon: Icon(icon, size: 24.0),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
