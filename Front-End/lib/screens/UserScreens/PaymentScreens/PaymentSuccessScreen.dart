import 'package:flutter/material.dart';
import 'package:refeitech/screens/UserScreens/ShopScreens/ProductsHome.dart';
import 'package:refeitech/services/cookie_api.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  Future<void> _clearCart() async {
    try {
      await CookieService.clearCart(); // Limpa o carrinho
    } catch (e) {
      print('Erro ao limpar o carrinho: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
          Image.asset(
            'assets/images/background_image2.png', // Substitua pelo caminho da sua imagem
            fit: BoxFit.cover,
          ),
          // Conteúdo da tela
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto de sucesso
              const Text(
                'Compra realizada com sucesso!',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botão para voltar à tela de produtos
              ElevatedButton.icon(
                onPressed: () {
                  _clearCart();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductsHome()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag, // Ícone de produtos
                  color: Colors.white,
                ),
                label: const Text(
                  'Voltar aos produtos',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
