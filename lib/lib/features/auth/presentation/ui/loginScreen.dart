
import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/lib/core/constant/widget/FormBox.dart';
import 'package:eventhub/lib/core/constant/widget/PrimaryBtn.dart';
import 'package:eventhub/lib/core/service/hive/hive_service.dart';
import 'package:eventhub/lib/core/service/shared_perferance/session_service.dart';
import 'package:eventhub/lib/features/auth/presentation/ui/compoents/LoginWithBtn.dart';
import 'package:eventhub/lib/generated/assets.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();
  final _remember     = ValueNotifier<bool>(false);
  final _error        = ValueNotifier<String?>('');

  LoginScreen({super.key});

  Future<void> _signIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _error.value = null;

    final user = HiveService.login(
      email:    _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    if (user == null) {
      _error.value = 'Wrong email or password.';
      return;
    }

    await SessionService.saveSession(user.email);
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(child: Assets.assets.images.svg.secondLogo.svg()),
              const SizedBox(height: 32),
              Text('Sign in',
                  style: AppTextStyles.fontStyle24
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 21),
              Form(
                key: _formKey,
                child: Column(children: [
                  FormBox(
                    labeled: 'Email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Assets.assets.images.svg.message
                        .svg(width: 22, height: 22),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter your email';
                      if (!RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(v)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 19),
                  FormBox(
                    labeled: 'Password',
                    controller: _passwordCtrl,
                    isObscured: true,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                    prefixIcon: Assets.assets.images.svg.lock
                        .svg(width: 22, height: 22),
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
                    value: val,
                    onChanged: (v) => _remember.value = v,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Remember Me',
                    style: AppTextStyles.fontStyle14
                        .copyWith(color: AppColours.blackColour)),
                const Spacer(),
                Text('Forget password?',
                    style: AppTextStyles.fontStyle14
                        .copyWith(color: AppColours.blackColour)),
              ]),


              ValueListenableBuilder<String?>(
                valueListenable: _error,
                builder: (_, msg, __) => msg == null || msg.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(msg,
                            style: AppTextStyles.fontStyle14
                                .copyWith(color: Colors.red)),
                      ),
              ),

              const SizedBox(height: 36),
              Center(
                child: PrimaryBtn(
                  label: 'SIGN IN',
                  isImage: true,
                  function: () => _signIn(context),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text('OR',
                    style: AppTextStyles.fontStyle14
                        .copyWith(color: AppColours.darkGreyColour)),
              ),
              const SizedBox(height: 5),
              LoginWithBtn(
                  label: 'Login With Google',
                  assetPath: Assets.assets.images.png.google.path),
              const SizedBox(height: 17),
              LoginWithBtn(
                  label: 'Login With Facebook',
                  assetPath: Assets.assets.images.png.facebook.path),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account? ",
                    style: AppTextStyles.fontStyle14
                        .copyWith(color: AppColours.blackColour)),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/sign_up'),
                  child: Text('Sign Up',
                      style: AppTextStyles.fontStyle14
                          .copyWith(color: AppColours.primaryColour)),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
