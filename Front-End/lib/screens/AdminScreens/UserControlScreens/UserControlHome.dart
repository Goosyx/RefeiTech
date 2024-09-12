import 'package:flutter/material.dart';
import 'package:refeitech/screens/AdminScreens/UserControlScreens/AddUserScreen.dart';
import 'package:refeitech/screens/AdminScreens/UserControlScreens/UserListScreen.dart';

class UserControlHome extends StatelessWidget {
  const UserControlHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png',
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo sobre a imagem de fundo
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Color(0xFF1E2328),
                        ),
                        children: [
                          TextSpan(
                            text: 'QUAL FUNÇÃO DESEJA\n',
                          ),
                          TextSpan(
                            text: 'ACESSAR?',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Color(0xFF1E2328),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _buildAdminButton(
                      label: 'ADICIONAR USUÁRIO',
                      color: const Color(0xFFFFBB00),
                      icon: Icons.person_add_alt_1_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddUserScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 15.0),
                    _buildAdminButton(
                      label: 'LISTA DE USUÁRIOS',
                      color: const Color(0xFFFFBB00),
                      icon: Icons.list_alt_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserListScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 30.0),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 28,
        color: const Color(0xFF1E2328),
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E2328),
          fontSize: 18, // Ajustado para tamanhos de tela menores
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(
            double.infinity, 60), // Ajusta o botão para a largura da tela
        padding: const EdgeInsets.symmetric(vertical: 16.0), // Ajusta o padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
