import 'dart:convert'; // Para decodificar o JSON
import 'package:flutter/material.dart';

class PurchaseInformationScreen extends StatelessWidget {
  final String qrCodeJson;

  const PurchaseInformationScreen({super.key, required this.qrCodeJson});

  @override
  Widget build(BuildContext context) {
    // Decodifica o JSON para um mapa
    final Map<String, dynamic> decodedJson = jsonDecode(qrCodeJson);
    final List<dynamic> cart = decodedJson['cart'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Informações da Compra'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(item['product_name']),
              subtitle: Text(
                'ID do Pagamento: ${item['payment_id']}\n'
                'ID do Produto: ${item['product_id']}\n'
                'Quantidade: ${item['purchases']}\n'
                'Preço Unitário: \$${item['unit_price']}',
              ),
            ),
          );
        },
      ),
    );
  }
}
