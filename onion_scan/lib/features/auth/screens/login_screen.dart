import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onion_scan/core/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _emailOrPhone, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Connexion',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // E-mail ou numéro de téléphone
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'E-mail ou numéro de téléphone',
                      hintText: 'Enter your email or phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) => _emailOrPhone = value,
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                ),
                const SizedBox(height: 12),
                // Mot de passe
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    obscureText: true,
                    onChanged: (value) => _password = value,
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton Se connecter
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Appeler AuthService pour connexion
                        context.push('/capture'); // Rediriger après connexion
                      }
                    },
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Mot de passe oublié ?
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/login/forgot-password'),
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: AppColors.accentColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // I don’t have an account? Register now
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'I don’t have an account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: Text(
                          'Register now',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}