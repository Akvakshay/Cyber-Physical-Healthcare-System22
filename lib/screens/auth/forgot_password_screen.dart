import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/view_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Forgot password?', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                const Text('Enter the phone number or email linked to your account and we\'ll send a reset link.'),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Phone number or email',
                  hint: 'Enter phone number or email',
                  controller: _controller,
                  prefixIcon: Icons.alternate_email,
                  textInputAction: TextInputAction.done,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                if (auth.resetState.isError) ...[
                  const SizedBox(height: 10),
                  Text(auth.resetState.errorMessage ?? '', style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ],
                if (auth.resetState.isSuccess) ...[
                  const SizedBox(height: 10),
                  const Text('Reset link sent. Check your inbox or SMS.', style: TextStyle(color: AppColors.success, fontSize: 13)),
                ],
                const SizedBox(height: 22),
                PrimaryButton(
                  label: 'SEND RESET LINK',
                  isLoading: auth.resetState.status == ViewStatus.loading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      auth.sendPasswordReset(_controller.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
