import 'package:flutter/material.dart';
import 'package:refeitech/screens/AdminScreens/UserControlScreens/UserControlHome.dart';
import 'package:refeitech/screens/AdminScreens/ProductControlScreens/ProductControlHome.dart';
import 'package:refeitech/screens/AdminScreens/PurchasesValidationScreens/PurchaseQRCodeReader.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background image
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'ADMINISTRAÇÃO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2328),
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _buildAdminButton(
                    label: 'VALIDAR COMPRAS',
                    color: const Color(0xFFFFBB00),
                    icon: Icons.shopping_cart_checkout,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseQRCodeReader()),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  _buildAdminButton(
                    label: 'CONTROLE DE USUÁRIOS',
                    color: const Color(0xFFFFBB00),
                    icon: Icons.person_outline,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserControlHome()),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  _buildAdminButton(
                    label: 'CONTROLE DE PRODUTOS',
                    color: const Color(0xFFFFBB00),
                    icon: Icons.shopping_bag_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductControlHome()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Back button (top left)
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
    return SizedBox(
      width: double.infinity, // Make the button take the full width
      child: ElevatedButton.icon(
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
            fontSize: 18, // Adjust font size
          ),
          overflow: TextOverflow.ellipsis, // Handle text overflow
          maxLines: 1, // Ensure text is on one line
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
