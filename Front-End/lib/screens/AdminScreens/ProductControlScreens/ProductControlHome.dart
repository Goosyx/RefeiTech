import 'package:flutter/material.dart';
import 'package:refeitech/screens/AdminScreens/ProductControlScreens/AddProductScreen.dart';
import 'package:refeitech/screens/AdminScreens/ProductControlScreens/RemoveProductScreen.dart';
import 'package:refeitech/screens/AdminScreens/ProductControlScreens/ProductListScreen.dart';
import 'package:refeitech/screens/AdminScreens/ProductControlScreens/UpdateProductScreen.dart';

class ProductControlHome extends StatelessWidget {
  const ProductControlHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png', // Substitua pelo caminho correto da sua imagem
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão de voltar posicionado corretamente
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 30.0),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 30.0), // Espaço para o botão de voltar
                  const Text(
                    'Controle de Produtos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2328),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 55.0),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      children: [
                        _buildAdminCard(
                          icon: Icons.add,
                          label: 'Adicionar Produto',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen()),
                            );
                          },
                        ),
                        _buildAdminCard(
                          icon: Icons.remove,
                          label: 'Remover Produto',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RemoveProductScreen()),
                            );
                          },
                        ),
                        _buildAdminCard(
                          icon: Icons.edit,
                          label: 'Modificar Produto',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateProductScreen()),
                            );
                          },
                        ),
                        _buildAdminCard(
                          icon: Icons.list,
                          label: 'Lista de Produtos',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductListScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: const Color(0xFF1E2328),
            ),
            const SizedBox(height: 10.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2328),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
