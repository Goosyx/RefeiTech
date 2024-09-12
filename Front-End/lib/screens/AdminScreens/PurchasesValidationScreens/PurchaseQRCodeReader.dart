import 'dart:convert'; // Import necessário para parse JSON
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:refeitech/services/cookie_api.dart';

class PurchaseQRCodeReader extends StatefulWidget {
  const PurchaseQRCodeReader({Key? key}) : super(key: key);

  @override
  State<PurchaseQRCodeReader> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<PurchaseQRCodeReader> {
  List<Map<String, dynamic>> products = [];
  String errorMessage = '';

  Future<void> readQRCode() async {
    final String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF", // Cor da linha de escaneamento
      "Cancelar", // Texto do botão de cancelar
      false, // Mostrar ícone de flash
      ScanMode.QR, // Modo de escaneamento
    );

    if (code != '-1') {
      try {
        // Decodifica o QR code como um objeto JSON
        final Map<String, dynamic> data = jsonDecode(code);

        // Verifica se o objeto contém a chave 'cart' e se é uma lista
        if (data.containsKey('cart') && data['cart'] is List) {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['cart']);
            errorMessage = '';
          });

          // Chama a função validateQRCode com 'success'
          CookieService.validateQRCode('success');
        } else {
          setState(() {
            errorMessage = 'QRCode inválido';
            products = [];
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Erro na leitura';
          products = [];
        });
      }
    } else {
      setState(() {
        errorMessage = 'QRCode não validado';
        products = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png', // Imagem de fundo
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo sobre a imagem de fundo
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'VALIDAR QR CODE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2328),
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          errorMessage,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    ),
                  if (products.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: products.map((product) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Produto: ${product['product_name']}',
                                  style: const TextStyle(
                                      fontSize: 20, color: Color(0xFF1E2328)),
                                ),
                                Text(
                                  'Quantidade: ${product['purchases']}',
                                  style: const TextStyle(
                                      fontSize: 20, color: Color(0xFF1E2328)),
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  ElevatedButton.icon(
                    onPressed: readQRCode,
                    icon: const Icon(
                      Icons.qr_code,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Ler QRCode',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1E2328), // Cor de fundo do botão
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botão de voltar (topo esquerdo)
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
}
