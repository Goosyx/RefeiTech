import 'package:http/http.dart' as http;
import 'dart:convert';

// Certifique-se de que este caminho esteja correto

class UserSession {
  // Singleton instance
  static final UserSession _instance = UserSession._internal();

  // Factory constructor
  factory UserSession() => _instance;

  // Internal constructor
  UserSession._internal();

  // Get the singleton instance
  static UserSession get instance => _instance;

  // User RA
  String? _ra;

  // User balance
  double? _balance;

  // Getter and Setter for RA
  String? getRA() => _ra;
  void setRA(String? ra) => _ra = ra;

  // Getter and Setter for balance
  double? getBalance() => _balance;
  void setBalance(double? balance) => _balance = balance;
}

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<Map<String, dynamic>?> addUser(
      String ra, String password) async {
    var url = Uri.parse('$baseUrl/admins/add_user');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ra': ra, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // Status 201 Created
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> removeUser(String ra) async {
    var url = Uri.parse('$baseUrl/admins/remove_user/$ra');
    try {
      var response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> listUsers() async {
    var url = Uri.parse('$baseUrl/admins/list_users');
    try {
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> addProduct(
      String id, String nome, double preco, int qtde) async {
    final url = Uri.parse('$baseUrl/products/add');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nome,
          'price': preco,
          'quantity': qtde,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // Retorna um mapa de erro em caso de falha
        return {'status': 'fail', 'message': 'Erro ao adicionar produto.'};
      }
    } catch (e) {
      print('Exceção capturada: $e');
      return {
        'status': 'fail',
        'message': 'Erro ao tentar adicionar o produto: $e'
      }; // Falha devido a uma exceção
    }
  }

  static Future<Map<String, dynamic>> removeProduct(String id) async {
    final url = Uri.parse('$baseUrl/products/remove/$id');

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {
        'status': 'fail',
        'message': 'Erro ao tentar remover o produto: $e'
      };
    }
  }

  // Método para atualizar um produto
  static Future<Map<String, dynamic>> updateProduct(
      String id, String nome, double preco, int qtde) async {
    final url = Uri.parse('$baseUrl/products/update/$id');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'name': nome,
          'price': preco,
          'quantity': qtde,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'fail', 'message': 'Erro ao atualizar produto.'};
      }
    } catch (e) {
      print('Exceção capturada: $e');
      return {
        'status': 'fail',
        'message': 'Erro ao tentar atualizar o produto: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> listProducts() async {
    final url = Uri.parse('$baseUrl/products/list');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'fail', 'message': 'Erro ao listar produtos.'};
      }
    } catch (e) {
      print('Exceção capturada: $e');
      return {
        'status': 'fail',
        'message': 'Erro ao tentar listar os produtos: $e'
      }; // Falha devido a uma exceção
    }
  }

  static Future<Map<String, dynamic>?> addBalance(
      String ra, double saldo) async {
    var url = Uri.parse('$baseUrl/payment/add_balance');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ra': ra, 'balance': saldo}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserBalance(String ra) async {
    var url = Uri.parse(
        '$baseUrl/payment/get_balance/'); // Ajuste o endpoint conforme necessário
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ra': ra}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get balance: ${response.body}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> validatePayment(
    String paymentMethod,
    String? correlationID, {
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) async {
    var url = Uri.parse(
        '$baseUrl/payment/validate'); // Ajuste o endpoint conforme necessário
    try {
      // Cria o mapa básico com os parâmetros obrigatórios
      Map<String, dynamic> body = {
        'payment_method': paymentMethod,
        'charge_id': correlationID,
      };

      // Adiciona os parâmetros opcionais somente se forem fornecidos
      if (cardNumber != null) {
        body['card_number'] = cardNumber;
      }
      if (expiryDate != null) {
        body['expiry_date'] = expiryDate;
      }
      if (cvv != null) {
        body['cvv'] = cvv;
      }

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to validate payment: ${response.body}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
