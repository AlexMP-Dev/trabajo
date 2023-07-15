import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:flutter/material.dart';


class InputDecorationWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? margin;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? initialValue;
  final bool obscureText;
  final bool autofocus;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool? showCursor;
  final bool? enabled;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final int maxLines;

  const InputDecorationWidget({
    Key? key,
    this.controller,
    this.validator,
    required this.hintText,
    this.labelText,
    this.margin,
    this.keyboardType = TextInputType.number,
    this.onFieldSubmitted,
    this.onChanged,
    this.initialValue,
    this.obscureText = false,
    this.autofocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.enabled,
    this.onSaved,
    this.maxLines = 1,
    this.showCursor, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        autocorrect: true,
        onTap: onTap,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: obscureText,
        initialValue: initialValue,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autofocus: autofocus,
        validator: validator,
        controller: controller,
        maxLines: null,
        scrollPadding: EdgeInsets.zero,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: "MonM",
        ),
        textAlign: TextAlign.justify,
        cursorColor: AppColors.oscureColor,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText,
          hintStyle: const TextStyle(
              color: AppColors.oscureColor, fontSize: 15, fontFamily: "MonM"),
          labelStyle: const TextStyle(
              color: AppColors.oscureColor, fontSize: 15, fontFamily: "MonB"),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            //AQUI LE CAMBIO EL COLOR DEL BORDE DONDE ESTA EL CALENDARIO
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          //MANTIENE EL COLOR CUANDO EL ENABLED ESTA EN FALSE
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColors.blueAcents,
              width: 2,
            ),
          ),
          //MANTIENE BORDE CUANDO NO SE ESCRIBE NADA
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          //COLOR DEL BORDE EN GENERAL
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          //MANTIENE EL COLOR DEL BORDE
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}



class InputDecorationWidget2 extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final String? labelText;
  final String? prefix;
  final String? prefixText;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry? margin;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? initialValue;
  final bool obscureText;
  final bool autofocus;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool? showCursor;
  final bool? enabled;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final int maxLines;

  const InputDecorationWidget2({
    Key? key,
    this.controller,
    this.validator,
    required this.hintText,
    this.labelText,
    this.prefix = "+51",
    this.prefixText,
    this.margin,
    this.keyboardType = TextInputType.number,
    this.onFieldSubmitted,
    this.onChanged,
    this.initialValue,
    this.obscureText = false,
    this.autofocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.enabled,
    this.onSaved,
    this.maxLines = 1,
    this.showCursor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        autocorrect: true,
        onTap: onTap,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: obscureText,
        initialValue: initialValue,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autofocus: autofocus,
        validator: validator,
        controller: controller,
        
        //maxLines: null,
        scrollPadding: EdgeInsets.zero,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: "MonM",
        ),
        textAlign: TextAlign.justify,
        cursorColor: AppColors.oscureColor,
        decoration: InputDecoration(
          prefix: null,
          prefixText: prefixText,
          prefixStyle: const TextStyle(color: AppColors.oscureColor, fontSize: 15, fontFamily: "MonM"),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText,
          hintStyle: const TextStyle(
              color: AppColors.oscureColor, fontSize: 15, fontFamily: "MonM"),
          labelStyle: const TextStyle(
              color: AppColors.oscureColor, fontSize: 15, fontFamily: "MonB"),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            //AQUI LE CAMBIO EL COLOR DEL BORDE DONDE ESTA EL CALENDARIO
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          //MANTIENE EL COLOR CUANDO EL ENABLED ESTA EN FALSE
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: AppColors.blueAcents,
              width: 2,
            ),
          ),
          //MANTIENE BORDE CUANDO NO SE ESCRIBE NADA
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          //COLOR DEL BORDE EN GENERAL
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
          //MANTIENE EL COLOR DEL BORDE
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: AppColors.oscureColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
