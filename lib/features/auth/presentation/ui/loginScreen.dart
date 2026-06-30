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

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();
  final _remember     = ValueNotifier<bool>(false);

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
                    Center(child: Assets.assets.images.svg.secondLogo.svg()),
                    const SizedBox(height: 32),
                    Text('Sign in', style: AppTextStyles.fontStyle24
                        .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 21),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        FormBox(
                          labeled: 'Email', controller: _emailCtrl,
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
                        FormBox(
                          labeled: 'Password', controller: _passwordCtrl,
                          isObscured: true, keyboardType: TextInputType.visiblePassword,
                          suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                          prefixIcon: Assets.assets.images.svg.lock.svg(width: 22, height: 22),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter your password';
                            return null;
                          },
                        ),
                      ]),
                    ),
                    const SizedBox(height: 14),
                    Row(children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _remember,
                        builder: (_, val, __) => Switch(
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColours.primaryColour,
                          value: val, onChanged: (v) => _remember.value = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Remember Me', style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.blackColour)),
                      const Spacer(),
                      Text('Forget password?', style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.blackColour)),
                    ]),
                    if (state is AuthError) ...[
                      const SizedBox(height: 8),
                      Text(state.message,
                          style: AppTextStyles.fontStyle14.copyWith(color: Colors.red)),
                    ],
                    const SizedBox(height: 36),
                    Center(
                      child: state is AuthLoading
                          ? CircularProgressIndicator(color: AppColours.primaryColour)
                          : PrimaryBtn(
                              label: 'SIGN IN',
                              isImage: true,
                              function: () {
                                if (!_formKey.currentState!.validate()) return;
                                context.read<AuthCubit>().login(
                                    _emailCtrl.text, _passwordCtrl.text);
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
                      Text("Don't have an account? ", style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.blackColour)),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/sign_up'),
                        child: Text('Sign Up', style: AppTextStyles.fontStyle14
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
