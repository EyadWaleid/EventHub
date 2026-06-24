import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/core/constant/widget/FormBox.dart';
import 'package:eventhub/core/constant/widget/PrimaryBtn.dart';
import 'package:eventhub/features/auth/presentation/ui/compoents/LoginWithBtn.dart';
import 'package:eventhub/features/auth/presentation/ui/loginScreen.dart';
import 'package:eventhub/generated/assets.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _value = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    print("Rebuild me ");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Assets.assets.images.svg.secondLogo.svg()),
            Text(
              "Sign in",
              style: AppTextStyles.fontStyle24.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 21),
            Form(
              key: formKey,
              child: Column(
                children: [
                  FormBox(
                    labeled: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Assets.assets.images.svg.message.svg(
                      width: 22,
                      height: 22,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      }
                      else if (!StringExtension(value).isValidEmail()){
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 19),
                  FormBox(
                    labeled: "Password",
                    controller: passwordController,
                    isObscured: true,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: Icon(Icons.remove_red_eye_outlined),
                    prefixIcon: Assets.assets.images.svg.lock.svg(
                      width: 22,
                      height: 22,
                    ),
                    validator: (value){
                      if(value!.isEmpty || value == null){}
                      return "Enter your password ";                    },
                  ),
                ],
              ),
            ),
            SizedBox(height:14),
            Row(
              children: [
              ValueListenableBuilder<bool>(
              valueListenable: _value,
              builder: (context, value, _) {
                return Switch(
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColours.primaryColour,
                  value: value,
                  onChanged: (val) => _value.value = val,
                );
              },
            ),

                SizedBox(width: 8),
                Text(
                  "Remember Me ",
                  style: AppTextStyles.fontStyle14.copyWith(
                    color: AppColours.blackColour,
                  ),
                ),
                Spacer(),
                Text(
                  "Forget password?",
                  style: AppTextStyles.fontStyle14.copyWith(
                    color: AppColours.blackColour,
                  ),
                ),
              ],
            ),
            SizedBox(height:36),
            Center(
              child: PrimaryBtn(
                label: "SIGN IN",
                isImage: true,
                function: () {
                  if(formKey.currentState!.validate()){

                  }
                },
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                "OR",
                style: AppTextStyles.fontStyle14.copyWith(
                  color: AppColours.darkGreyColour,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5),
            LoginWithBtn(label: 'Login With Google', assetPath: Assets.assets.images.png.google.path),
            SizedBox(height: 17,),
            LoginWithBtn(label: 'Login With Facebook', assetPath: Assets.assets.images.png.facebook.path),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Don't have an account? ",style: AppTextStyles.fontStyle14.copyWith(color: AppColours.blackColour),),
              TextButton(onPressed: (){
                Navigator.pushReplacementNamed(context, '/sign_up');

              }, child: Text("Sign Up",style: AppTextStyles.fontStyle14.copyWith(color: AppColours.primaryColour),))
            ],)
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {

  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }


}
