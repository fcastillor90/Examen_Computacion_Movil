import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  }) : super(key: key);

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Aceptar',
    String cancelText = 'Cancelar',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm != null
            ? () {
                Navigator.of(context).pop(true);
                onConfirm();
              }
            : () => Navigator.of(context).pop(true),
        onCancel: onCancel != null
            ? () {
                Navigator.of(context).pop(false);
                onCancel();
              }
            : () => Navigator.of(context).pop(false),
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomButton(
          text: confirmText,
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          color: isDestructive ? AppColors.error : AppColors.primary,
          height: 36,
        ),
      ],
    );
  }
}
