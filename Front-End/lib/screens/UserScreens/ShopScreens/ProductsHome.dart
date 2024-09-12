import 'package:flutter/material.dart';
import 'package:refeitech/screens/UserScreens/ShopScreens/CartScreen.dart';
import 'package:refeitech/screens/UserScreens/WelcomeScreen.dart'; // Import da tela de boas-vindas
import 'package:refeitech/services/api_service.dart';
import 'package:refeitech/services/cookie_api.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    var response = await ApiService.listProducts();
    if (response['status'] == 'success') {
      setState(() {
        _products = response['product'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar produtos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addToCart(String productId, int quantity) async {
    try {
      final response = await CookieService.addToCart(productId, quantity);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto adicionado ao carrinho'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                response['message'] ?? 'Erro ao adicionar produto ao carrinho'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar produto ao carrinho: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image2.png', // Substitua pelo caminho da imagem desejada
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                scrolledUnderElevation: 0,
                centerTitle: true,
                title: const Text(
                  'REFEITECH',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.2,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 28,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _products.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum produto encontrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF1E2328),
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _products.length,
                              itemBuilder: (context, index) {
                                final product =
                                    _products[index] as Map<String, dynamic>;
                                return Card(
                                  color:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  elevation: 5,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              product['imagem'] ??
                                                  'https://via.placeholder.com/200',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'] ??
                                                  'Nome não disponível',
                                              style: const TextStyle(
                                                fontSize: 29,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E2328),
                                              ),
                                            ),
                                            const SizedBox(height: 9),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'R\$ ${product['price'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF1E2328),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => _addToCart(
                                                      product['id'].toString(),
                                                      1),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFFFBB00),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    elevation: 3,
                                                    minimumSize:
                                                        const Size(30, 40),
                                                  ),
                                                  child: const Icon(
                                                      Icons.add_shopping_cart,
                                                      color: Color(0xFF1E2328),
                                                      size: 25),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
