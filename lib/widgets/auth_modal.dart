import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

class AuthModal {
  static void show(BuildContext context, {bool isSignUp = true, String? initialMessage}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _AuthModalContent(initialSignUp: isSignUp, message: initialMessage);
      },
    );
  }
}

class _AuthModalContent extends StatefulWidget {
  final bool initialSignUp;
  final String? message;

  const _AuthModalContent({required this.initialSignUp, this.message});

  @override
  State<_AuthModalContent> createState() => _AuthModalContentState();
}

class _AuthModalContentState extends State<_AuthModalContent> {
  late bool _isSignUp;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialSignUp;
  }

  void _handleSubmit() {
    final state = Provider.of<AppState>(context, listen: false);
    setState(() => _errorMessage = null);

    if (_isSignUp) {
      final res = state.signUp(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (res.ok) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.greenDark,
            content: Text('Conta criada! Bem-vindo(a), ${res.account!.name}! 🎉'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() => _errorMessage = res.error);
      }
    } else {
      final res = state.signIn(
        _emailController.text,
        _passwordController.text,
      );
      if (res.ok) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.greenDark,
            content: Text('Bem-vindo(a) de volta, ${res.account!.name}!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() => _errorMessage = res.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isSignUp ? 'Criar conta 🌿' : 'Entrar na sua conta',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenDark,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.message ??
                  (_isSignUp
                      ? 'Crie sua conta para ter acesso a plantas, rotina, diagnóstico e comunidade.'
                      : 'Entre com o e-mail e a senha cadastrados.'),
              style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.danger.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.dangerInk, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.dangerInk, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isSignUp) ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  hintText: 'Ex: Maria',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                hintText: 'voce@email.com',
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                hintText: 'Mínimo de 4 caracteres',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coralDark,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _handleSubmit,
              child: Text(
                _isSignUp ? 'Criar conta' : 'Entrar',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isSignUp = !_isSignUp;
                    _errorMessage = null;
                  });
                },
                child: Text.rich(
                  TextSpan(
                    text: _isSignUp ? 'Já tem conta? ' : 'Ainda não tem conta? ',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    children: [
                      TextSpan(
                        text: _isSignUp ? 'Entrar' : 'Criar conta',
                        style: const TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
