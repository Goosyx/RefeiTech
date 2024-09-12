import 'package:flutter/material.dart';
import 'package:refeitech/services/api_service.dart';
import 'package:refeitech/screens/UserScreens/AccountScreens/AddBalanceScreen.dart';
import 'package:refeitech/screens/UserScreens/AccountScreens/MyPurchasesScreen.dart'; // Certifique-se de importar a tela correta
import 'package:refeitech/screens/LoginScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? userRA;
  double? userBalance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    userRA = UserSession().getRA();
    if (userRA != null) {
      var response = await ApiService.getUserBalance(userRA!);
      if (response != null && response['status'] == 'success') {
        setState(() {
          userBalance = double.tryParse(response['balance'].toString()) ?? 0.0;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar saldo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddBalanceScreen() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const AddBalanceScreen();
      },
    );

    if (result ?? false) {
      _fetchUserDetails();
    }
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
                elevation: 0,
                title: const Text(
                  'MINHA CONTA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.1,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage: const AssetImage(
                              'assets/images/profile_picture.png'),
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 5.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          userRA ?? 'RA não disponível',
                          style: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Saldo: R\$${userBalance?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              _buildAccountOption(
                                  'Minhas Compras', Icons.shopping_cart, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyPurchasesScreen()), // Certifique-se de que a tela MyPurchasesScreen está implementada
                                );
                              }),
                              _buildAccountOption(
                                  'Editar Perfil', Icons.edit, () {}),
                              _buildAccountOption(
                                  'Adicionar Saldo',
                                  Icons.account_balance_wallet,
                                  _showAddBalanceScreen),
                              _buildAccountOption('Fazer Logout', Icons.logout,
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption(
      String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2328),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.white),
            title: Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
