import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart'; // Assure-toi d'avoir créé ce fichier
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Contrôleurs pour récupérer le texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Pour afficher un chargement sur le bouton

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 2. Fonction de connexion Firebase
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Si réussi, on change d'écran
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs (Mot de passe faux, utilisateur inexistant, etc.)
      String message = "Une erreur est survenue";
      if (e.code == 'user-not-found')
        message = "Aucun utilisateur trouvé.";
      else if (e.code == 'wrong-password') message = "Mot de passe incorrect.";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final TextEditingController resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    final String? email = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          title: const Text(
            'Reinitialiser le mot de passe',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Adresse email',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF12121A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
              ),
              onPressed: () {
                Navigator.pop(context, resetEmailController.text.trim());
              },
              child: const Text(
                'Envoyer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    resetEmailController.dispose();

    if (!mounted || email == null || email.isEmpty) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Un email de reinitialisation a ete envoye a $email',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Impossible d\'envoyer l\'email de reinitialisation.';
      if (e.code == 'invalid-email') {
        message = 'Adresse email invalide.';
      } else if (e.code == 'user-not-found') {
        message = 'Aucun utilisateur trouve avec cet email.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121A),
      body: Center(
        child: Container(
          width: 900,
          height: 550,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Row(
              children: [
                // PARTIE GAUCHE (Image)
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=2070',
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.4)),
                      const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gardez la mémoire\nde chaque concert.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // PARTIE DROITE (Formulaire)
                Container(
                  width: 450,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Concertothèque",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      _buildTextField("Adresse email", _emailController, false),
                      const SizedBox(height: 20),
                      _buildTextField(
                          "Mot de passe", _passwordController, true),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleForgotPassword,
                          child: const Text(
                            'Mot de passe oublie ?',
                            style: TextStyle(color: Color(0xFFFFB199)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("Se connecter",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                        child: const Text(
                          "Pas de compte ? S'inscrire",
                          style: TextStyle(color: Color(0xFFFFB199)),
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

  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF12121A),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
