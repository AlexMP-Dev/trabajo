import 'package:delivery_master2/src/utils/app_colors.dart';
import 'package:flutter/material.dart';


class InputDropdownButtonWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final String? labelText;
  final String? disabledHint;
  final List<DropdownMenuItem<String>>? items;
  //final FormFieldValidator<dynamic>? validator;
  final String? Function(String?)? validator;
  final dynamic value;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onSaved;

  const InputDropdownButtonWidget({
    super.key,
    this.margin,
    this.labelText,
    this.validator,
    this.disabledHint,
    this.items,
    this.value,
    this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: DropdownButtonFormField<String>(
        style: const TextStyle(
            fontFamily: "MonB", color: AppColors.oscureColor, fontSize: 17),
        icon: const Icon(Icons.arrow_drop_down_rounded,
            color: AppColors.colorAcento, size: 30),
        value: value,
        disabledHint: disabledHint != null ? Text(disabledHint!) : null,
        items: items,
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              const TextStyle(color: AppColors.oscureColor, fontFamily: "MonB"),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.oscureColor,
              // aquí se establece el color del borde
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.oscureColor,
              // aquí se establece el color del borde
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.oscureColor,
              // aquí se establece el color del borde
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.oscureColor,
              // aquí se establece el color del borde
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
