import 'package:flutter/material.dart';
import 'package:refeitech/services/cookie_api.dart';
import 'package:refeitech/services/global_state.dart'; // Assumindo que GlobalState está nesse arquivo
import 'package:refeitech/screens/UserScreens/AccountScreens/FinalCartScreen.dart';

class MyPurchasesScreen extends StatefulWidget {
  const MyPurchasesScreen({super.key});

  @override
  _MyPurchasesScreenState createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
  List<Map<String, dynamic>> _purchases = [];
  Map<int, int> _purchaseQuantities = {}; // To keep track of quantities
  String? userRA = GlobalState.userRA;

  @override
  void initState() {
    super.initState();
    _fetchPurchases();
  }

  Future<void> _fetchPurchases() async {
    var response = await CookieService.purchasesList();
    if (response['status'] == 'success') {
      setState(() {
        _purchases = List<Map<String, dynamic>>.from(response['payments']);
        _purchaseQuantities = {
          for (var i = 0; i < _purchases.length; i++)
            i: _purchases[i]['total_purchases']
        };
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar as compras'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _increaseQuantity(int index) {
    setState(() {
      final maxQuantity = _purchases[index]['total_purchases'] ?? 10;
      if (_purchaseQuantities[index]! < maxQuantity) {
        _purchaseQuantities[index] = _purchaseQuantities[index]! + 1;
      }
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_purchaseQuantities[index]! > 1) {
        _purchaseQuantities[index] = _purchaseQuantities[index]! - 1;
      }
    });
  }

  Future<void> _addToCart(String userRA, int productID, int quantity) async {
    var response =
        await CookieService.addToFinalCart(userRA, productID, quantity);
    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto adicionado ao carrinho com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao adicionar produto ao carrinho'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Minhas Compras',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _purchases.isEmpty
                  ? const Center(
                      child: Text(
                        'Você ainda não fez nenhuma compra.',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _purchases.length,
                      itemBuilder: (context, index) {
                        final purchase = _purchases[index];
                        final quantity = _purchaseQuantities[index] ?? 1;
                        final maxQuantity = purchase['total_purchases'] ?? 10;

                        return Card(
                          color: const Color(0xFF1E2328),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              purchase['product']['name'],
                              style: const TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              'Quantidade: ${purchase['total_purchases'].toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: quantity <= 1
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Color(0xFF1E2328),
                                      size: 24.0,
                                    ),
                                  ),
                                  onPressed: quantity <= 1
                                      ? null
                                      : () => _decreaseQuantity(index),
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: quantity >= maxQuantity
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Color(0xFF1E2328),
                                      size: 24.0,
                                    ),
                                  ),
                                  onPressed: quantity >= maxQuantity
                                      ? null
                                      : () => _increaseQuantity(index),
                                ),
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Color(0xFF1E2328),
                                      size: 24.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    _addToCart(
                                      userRA!,
                                      purchase['product']['id'],
                                      quantity,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Botão na parte inferior da tela
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinalCartScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Coletar Compras',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
