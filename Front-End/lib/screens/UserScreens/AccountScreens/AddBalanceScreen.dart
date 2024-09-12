import 'package:flutter/material.dart';
import 'package:refeitech/services/api_service.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  _AddBalanceScreenState createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;

  Future<void> _addBalance() async {
    setState(() {
      _isProcessing = true;
    });

    String? userRA = UserSession().getRA();
    if (userRA != null) {
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      var response = await ApiService.addBalance(userRA, amount);
      if (response != null && response['status'] == 'success') {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao adicionar saldo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Adicionar Saldo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2328),
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Valor',
              labelStyle: const TextStyle(
                color: Color(0xFF1E2328),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
            style: const TextStyle(
              fontSize: 18.0,
              color: Color(0xFF1E2328),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _isProcessing ? null : _addBalance,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E2328), // Cor do botão
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: _isProcessing
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    'Adicionar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
