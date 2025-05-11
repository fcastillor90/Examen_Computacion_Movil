import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color color;
  final double size;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.color = AppColors.primary,
    this.size = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 4.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // Full screen loading with background
  static Widget fullScreen({String? message, Color? color}) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: LoadingIndicator(
        message: message,
        color: color ?? Colors.white,
      ),
    );
  }
}
