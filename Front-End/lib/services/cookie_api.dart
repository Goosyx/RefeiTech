import 'package:http/http.dart' as http;
import 'dart:convert';

class CookieService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static String? _cookie; // Variável para armazenar o cookie

  static Future<Map<String, dynamic>?> login(String ra, String password) async {
    var url = Uri.parse('$baseUrl/login');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_cookie != null) 'Cookie': _cookie!,
        },
        body: jsonEncode({
          'user': {'ra': ra, 'password': password}
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _updateCookie(response.headers);
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Função para adicionar ao carrinho e capturar cookies
  static Future<Map<String, dynamic>> addToCart(
      String productId, int quantity) async {
    final url = Uri.parse('$baseUrl/cart/add/$productId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      // Captura e armazena os cookies após a resposta
      _updateCookie(response.headers);
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao adicionar o produto ao carrinho');
    }
  }

  // Função para buscar o carrinho com os cookies armazenados
  static Future<Map<String, dynamic>> fetchCart() async {
    final url = Uri.parse('$baseUrl/cart');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );

    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar o carrinho');
    }
  }

  // Atualiza o cookie a partir dos cabeçalhos da resposta
  static void _updateCookie(Map<String, String> headers) {
    final cookiesHeader = headers['set-cookie'];
    if (cookiesHeader != null) {
      _cookie = cookiesHeader.split(';')[0]; // Armazena apenas o cookie
    }
  }

  // Atualiza a quantidade do item no carrinho
  static Future<void> updateCartItem(int productId, int quantity) async {
    final url = Uri.parse('$baseUrl/cart/update_quantity/$productId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
      body: jsonEncode({'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      _updateCookie(response.headers);
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        print('Quantidade atualizada no carrinho');
      } else {
        throw Exception('Falha ao atualizar a quantidade: ${data['message']}');
      }
    } else {
      throw Exception(
          'Erro ao atualizar a quantidade no carrinho: ${response.statusCode}');
    }
  }

  static Future<void> removeCartItem(int productId) async {
    final url = Uri.parse('$baseUrl/cart/remove_product/$productId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );
    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('Produto não encontrado no carrinho');
    }
  }

  static Future<void> clearCart() async {
    final url = Uri.parse('$baseUrl/cart/clear/');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );
    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('ERROR');
    }
  }

  static Future<Map<String, dynamic>?> createPayment(
    String paymentMethod,
    String? ra, {
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) async {
    var url = Uri.parse('$baseUrl/payment/create');
    try {
      // Cria o mapa básico com os parâmetros obrigatórios
      Map<String, dynamic> body = {
        'ra': ra,
        'payment_method': paymentMethod,
      };

      // Adiciona os parâmetros opcionais somente se forem fornecidos
      if (cardNumber != null) {
        body['card_number'] = cardNumber;
      }
      if (expiryDate != null) {
        body['card_expiry'] = expiryDate;
      }
      if (cvv != null) {
        body['cvv'] = cvv;
      }

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_cookie != null) 'Cookie': _cookie!,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _updateCookie(response.headers);
        return jsonDecode(response.body);
      } else {
        print('Failed to create payment: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> purchasesList() async {
    final url = Uri.parse('$baseUrl/purchases/show');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );
    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar compras');
    }
  }

  static Future<Map<String, dynamic>> generateQRCode() async {
    final url = Uri.parse('$baseUrl/purchases/generate');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );
    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar compras');
    }
  }

  static Future<Map<String, dynamic>> addToFinalCart(
      String? userRA, int productID, int quantity) async {
    final url = Uri.parse('$baseUrl/cart/final/add/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
      body: json.encode({
        'payments': [
          {
            'payment': {
              'users_ra': userRA,
              'products_id': productID,
              'purchases': quantity
            }
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Captura e armazena os cookies após a resposta
      _updateCookie(response.headers);
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  static Future<Map<String, dynamic>> getFinalCart() async {
    final url = Uri.parse('$baseUrl/purchases/show_cart');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );

    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar o carrinho');
    }
  }

  static Future<void> removeFinalCartItem(int productId) async {
    final url = Uri.parse('$baseUrl/purchases/remove_product/$productId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );
    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('Produto não encontrado no carrinho');
    }
  }

  static Future<void> clearFinalCart() async {
    final url = Uri.parse('$baseUrl/purchases/clear_cart');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!, // Envia o cookie se existir
      },
    );
    if (response.statusCode == 200) {
      _updateCookie(response.headers); // Atualiza o cookie após a resposta
      return jsonDecode(response.body);
    } else {
      throw Exception('ERROR');
    }
  }

  static Future<Map<String, dynamic>> validateQRCode(String? status) async {
    final url = Uri.parse('$baseUrl/purchases/validate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (_cookie != null) 'Cookie': _cookie!,
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      // Captura e armazena os cookies após a resposta
      _updateCookie(response.headers);
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }
}
