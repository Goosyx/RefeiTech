import 'package:flutter/material.dart';
import 'package:refeitech/services/api_service.dart';

class RemoveProductScreen extends StatefulWidget {
  const RemoveProductScreen({super.key});

  @override
  _RemoveProductScreenState createState() => _RemoveProductScreenState();
}

class _RemoveProductScreenState extends State<RemoveProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  String _message = '';

  Future<void> _removeProduct() async {
    if (_formKey.currentState!.validate()) {
      final String id = _idController.text;

      final response = await ApiService.removeProduct(id);

      setState(() {
        _message = response['message'] ?? 'Erro ao remover produto';
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
              'assets/images/background_image.png', // Substitua pelo caminho correto da sua imagem
              fit: BoxFit.cover,
            ),
          ),
          // Botão de voltar no topo da tela
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color(0xFF1E2328), size: 30.0),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Conteúdo principal da tela
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Remover Produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2328),
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _buildTextField(
                    controller: _idController,
                    labelText: 'ID do Produto',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _removeProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2328),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Remover Produto',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1E2328),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1E2328), width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
      style: const TextStyle(fontSize: 16),
    );
  }
}
