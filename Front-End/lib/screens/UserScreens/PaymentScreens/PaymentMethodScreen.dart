import 'package:flutter/material.dart';
import 'package:refeitech/screens/UserScreens/PaymentScreens/PixScreen.dart';
import 'package:refeitech/services/api_service.dart';
import 'package:refeitech/services/cookie_api.dart';
import 'package:refeitech/services/global_state.dart';
import 'package:refeitech/screens/UserScreens/PaymentScreens/WalletScreen.dart';
import 'package:refeitech/screens/UserScreens/PaymentScreens/CreditCardScreen.dart';

class PaymentOptionsScreen extends StatelessWidget {
  const PaymentOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFBB00),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2), // deslocamento do box shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
              color: const Color(0xFFFFBB00),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: const Text(
                'Métodos de Pagamento',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.5,
                ),
              )),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                PaymentOptionTile(
                  icon: Icons.credit_card,
                  title: 'Cartão de Crédito',
                  subtitle: 'Pague com seu cartão de crédito.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreditCardScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                PaymentOptionTile(
                  icon: Icons.pix,
                  title: 'Pix',
                  subtitle: 'Pague via Pix para uma transação rápida.',
                  onTap: () async {
                    // Obtém o RA do usuário
                    String? userRA = UserSession().getRA();

                    if (userRA != null) {
                      // Executa a função para criar o pagamento
                      var response =
                          await CookieService.createPayment('pix', '');

                      // Se a resposta for bem-sucedida, redireciona para a PixScreen
                      if (response != null && response['status'] == 'success') {
                        String qrCodeImage =
                            response['qr_code']['charge']['qrCodeImage'];
                        String correlationID =
                            response['qr_code']['charge']['correlationID'];

                        GlobalState.correlationID = correlationID;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PixScreen(
                              qrCodeUrl: qrCodeImage,
                            ),
                          ),
                        );
                      } else {
                        // Mostra uma mensagem de erro se o pagamento falhar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao criar pagamento'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Mostra uma mensagem de erro se o RA não estiver disponível
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('RA não disponível'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                PaymentOptionTile(
                  icon: Icons.wallet,
                  title: 'Carteira',
                  subtitle: 'Pague usando o saldo da sua conta.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          icon,
          color: const Color(0xFFFFBB00),
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2328),
            fontFamily: 'Roboto',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6D6E71),
            fontFamily: 'Roboto',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF1E2328),
        ),
        onTap: onTap,
      ),
    );
  }
}
