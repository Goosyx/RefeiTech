import 'package:flutter/material.dart';
import 'package:refeitech/screens/UserScreens/AccountScreens/PurchaseQRCodeScreen.dart';
import 'package:refeitech/services/cookie_api.dart';
import 'package:refeitech/screens/UserScreens/PaymentScreens/PaymentMethodScreen.dart';

class FinalCartScreen extends StatefulWidget {
  const FinalCartScreen({super.key});

  @override
  _FinalCartScreen createState() => _FinalCartScreen();
}

class _FinalCartScreen extends State<FinalCartScreen> {
  late Future<Map<String, dynamic>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    setState(() {
      _cartFuture = CookieService.getFinalCart();
    });
  }

  Future<void> _removeItem(int productId) async {
    try {
      await CookieService.removeFinalCartItem(productId);
      _loadCart(); // Atualiza o futuro para refletir a mudança
    } catch (e) {
      print('Erro ao remover o item: $e');
    }
  }

  Future<void> _clearCart() async {
    try {
      await CookieService.clearFinalCart(); // Limpa o carrinho
      _loadCart(); // Atualiza o futuro para refletir a mudança
    } catch (e) {
      print('Erro ao limpar o carrinho: $e');
    }
  }

  void _showPaymentOptionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: const PaymentOptionsScreen(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image2.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                title: const Text(
                  'CARRINHO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.5,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 30),
                    onPressed: () {
                      _clearCart(); // Limpa o carrinho quando o botão é pressionado
                    },
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _cartFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                        'Erro ao carregar o carrinho',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ));
                    } else if (!snapshot.hasData ||
                        (snapshot.data!['cart'] as List<dynamic>).isEmpty) {
                      return const Center(
                        child: Text(
                          'CARRINHO VAZIO!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      );
                    } else {
                      final cartData = snapshot.data!;
                      final cartItems = cartData['cart'] as List<dynamic>;

                      return Stack(
                        children: [
                          ListView.separated(
                            padding: const EdgeInsets.only(bottom: 120.0),
                            itemCount: cartItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 15),
                            itemBuilder: (context, index) {
                              final item =
                                  cartItems[index] as Map<String, dynamic>;
                              return CartItemCard(
                                item: item,
                                onRemoveItem: _removeItem,
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      var response =
                                          await CookieService.generateQRCode();

                                      // Se a resposta for bem-sucedida, redireciona para a PixScreen
                                      if (response['status'] == 'success') {
                                        String qrCodeImage =
                                            'http://10.0.2.2:3000/qrcode.png?timestamp=${DateTime.now().millisecondsSinceEpoch}';

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PurchaseQRCodeScreen(
                                              qrCodeUrl: qrCodeImage,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Mostra uma mensagem de erro se o pagamento falhar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Erro ao criar pagamento'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF1E2328),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 5.0,
                                    ),
                                    child: const Text(
                                      'Gerar QRCode',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Future<void> Function(int productId) onRemoveItem;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              image: DecorationImage(
                image: NetworkImage(
                    item['image'] ?? 'https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['product_name'] ?? 'Nome não disponível',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2328),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Quantidade: ${item['purchases'].toString()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1E2328),
                    fontFamily: 'Roboto',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onRemoveItem(item['product_id']);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
