import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:eventhub/core/constant/widget/FormBox.dart';
import 'package:eventhub/core/constant/widget/PrimaryBtn.dart';
import 'package:eventhub/features/auth/presentation/ui/compoents/LoginWithBtn.dart';
import 'package:eventhub/features/auth/presentation/ui/loginScreen.dart';
import 'package:eventhub/generated/assets.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final  formKey = GlobalKey<FormState>();
  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign Up",
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
                    labeled: "Person",
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Assets.assets.images.svg.profile.svg(
                      width: 22,
                      height: 22,
                    ),
                    validator:  (value){
                      if(value!.isEmpty || value == null){}
                      return "Enter your name ";                    },
                  ),
                  SizedBox(height: 19),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password';
                      }
                      else if (value.length < 6 ){
                        return "Make your password more than 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 19),
                  FormBox(
                    labeled: "Confirm Password",
                    controller: confirmPasswordController,
                    isObscured: true,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: Icon(Icons.remove_red_eye_outlined),
                    prefixIcon: Assets.assets.images.svg.lock.svg(
                      width: 22,
                      height: 22,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      else if (value != passwordController.text ){
                        return "Password do not match";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height:14),
            Center(
              child: PrimaryBtn(
                label: "SIGN UP",
                isImage: true,
                function: () {},
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
                Text("Already have an account? ",style: AppTextStyles.fontStyle14.copyWith(color: AppColours.blackColour),),
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                }, child: Text("Sign In",style: AppTextStyles.fontStyle14.copyWith(color: AppColours.primaryColour),))
              ],)
          ],
        ),
      ),
    );
  }
}

