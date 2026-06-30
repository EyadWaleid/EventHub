import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/core/constant/widget/FormBox.dart';
import 'package:eventhub/core/constant/widget/PrimaryBtn.dart';
import 'package:eventhub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:eventhub/features/auth/presentation/cubit/auth_state.dart';
import 'package:eventhub/features/auth/presentation/ui/compoents/LoginWithBtn.dart';
import 'package:eventhub/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey     = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 24),
                  Text('Sign Up', style: AppTextStyles.fontStyle24
                      .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 21),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      FormBox(labeled: 'Full Name', controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        prefixIcon: Assets.assets.images.svg.profile.svg(width: 22, height: 22),
                        validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 19),
                      FormBox(labeled: 'Email', controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Assets.assets.images.svg.message.svg(width: 22, height: 22),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your email';
                          if (!RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 19),
                      FormBox(labeled: 'Password', controller: _passCtrl,
                        isObscured: true, keyboardType: TextInputType.visiblePassword,
                        suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                        prefixIcon: Assets.assets.images.svg.lock.svg(width: 22, height: 22),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your password';
                          if (v.length < 6) return 'At least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 19),
                      FormBox(labeled: 'Confirm Password', controller: _confirmCtrl,
                        isObscured: true, keyboardType: TextInputType.visiblePassword,
                        suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                        prefixIcon: Assets.assets.images.svg.lock.svg(width: 22, height: 22),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Confirm your password';
                          if (v != _passCtrl.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  if (state is AuthError) ...[
                    Text(state.message,
                        style: AppTextStyles.fontStyle14.copyWith(color: Colors.red)),
                    const SizedBox(height: 8),
                  ],
                  Center(
                    child: state is AuthLoading
                        ? CircularProgressIndicator(color: AppColours.primaryColour)
                        : PrimaryBtn(
                            label: 'SIGN UP', isImage: true,
                            function: () {
                              if (!_formKey.currentState!.validate()) return;
                              context.read<AuthCubit>().register(
                                  _nameCtrl.text, _emailCtrl.text, _passCtrl.text);
                            },
                          ),
                  ),
                  const SizedBox(height: 24),
                  Center(child: Text('OR', style: AppTextStyles.fontStyle14
                      .copyWith(color: AppColours.darkGreyColour))),
                  const SizedBox(height: 5),
                  LoginWithBtn(label: 'Login With Google',
                      assetPath: Assets.assets.images.png.google.path),
                  const SizedBox(height: 17),
                  LoginWithBtn(label: 'Login With Facebook',
                      assetPath: Assets.assets.images.png.facebook.path),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Already have an account? ', style: AppTextStyles.fontStyle14
                        .copyWith(color: AppColours.blackColour)),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: Text('Sign In', style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.primaryColour)),
                    ),
                  ]),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
