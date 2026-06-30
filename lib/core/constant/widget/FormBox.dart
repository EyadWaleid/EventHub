
import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/appTextStyles/AppTextStyles.dart';
import 'package:flutter/material.dart';

class FormBox extends StatelessWidget {
  String labeled;
  Widget? suffixIcon;
  bool? isObscured;
  TextInputType? keyboardType;
  final Widget? prefixIcon;
  String? Function(String?)? validator;
  void Function()? onPressed ;
  TextEditingController controller;

  FormBox({super.key,this.onPressed,required this.labeled,this.isObscured, this.validator,this.keyboardType,required this.controller,this.suffixIcon, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      keyboardType: keyboardType??null,
      controller:controller ,
      maxLines: 1,
      obscureText: isObscured??false,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      style:AppTextStyles.fontStyle14.copyWith(color:AppColours.blackColour,fontSize:16),
      decoration:  InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        labelText:labeled,
        labelStyle: AppTextStyles.fontStyle14 ,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelStyle:   TextStyle(color:AppColours.blackColour,fontSize: 20),
        //the status of the form box in the enable focus and error
        focusedBorder:OutlineInputBorder(borderRadius:const BorderRadius.all(Radius.circular(12)),borderSide:BorderSide(color: AppColours.greyColour,width: 1,)),
        enabledBorder: OutlineInputBorder(borderRadius:const BorderRadius.all(Radius.circular(12)),borderSide:BorderSide(color: AppColours.greyColour,width: 1,)),
        errorBorder: const OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12)),borderSide: BorderSide(color: Colors.red) ),
        //the icons of the form box
        suffixIcon:IconButton(color:AppColours.greyColour, onPressed:onPressed, icon:suffixIcon ??Icon(null) ),
        prefixIcon: UnconstrainedBox(
          child: prefixIcon ?? Icon(null)
          ),
      ),
      cursorColor: Colors.black,
      validator: validator??(value){

      },

    );
  }
}
