import 'package:flutter/material.dart';

enum ButtonType { number, operator, action, scientific }

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final ButtonType type;
  final int flex;
  final IconData? icon;
  final bool isSelected;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onTap,
    this.type = ButtonType.number,
    this.flex = 1,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;

    switch (type) {
      case ButtonType.operator:
        bgColor = Colors.orangeAccent.shade700;
        textColor = Colors.white;
        break;
      case ButtonType.action:
        bgColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
        textColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF1F2937);
        break;
      case ButtonType.scientific:
        bgColor = isSelected
            ? Colors.indigo.shade600
            : (isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6));
        textColor = isSelected
            ? Colors.white
            : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB));
        break;
      case ButtonType.number:
        bgColor = isDark ? const Color(0xFF1F2937) : Colors.white;
        textColor = isDark ? Colors.white : const Color(0xFF111827);
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          elevation: isDark ? 2 : 3,
          shadowColor: isDark ? Colors.black45 : Colors.grey.shade300,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.orange.withValues(alpha: 0.3),
            highlightColor: Colors.white10,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: icon != null
                  ? Icon(icon, color: textColor, size: 22)
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: type == ButtonType.scientific ? 16 : 22,
                        fontWeight: type == ButtonType.number
                            ? FontWeight.w500
                            : FontWeight.bold,
                        color: textColor,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
