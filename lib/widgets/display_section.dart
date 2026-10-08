import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/calculator_controller.dart';

class DisplaySection extends StatelessWidget {
  final CalculatorController controller;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenHistory;

  const DisplaySection({
    super.key,
    required this.controller,
    required this.onToggleTheme,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Theme Toggle Button
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? Colors.amber : Colors.indigo,
                ),
                onPressed: onToggleTheme,
                tooltip: 'Toggle Theme',
              ),

              // Badges for DEG/RAD & Scientific Mode
              Row(
                children: [
                  GestureDetector(
                    onTap: controller.toggleDegree,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: controller.isDegree
                            ? Colors.indigo.shade600
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.isDegree ? 'DEG' : 'RAD',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: controller.isDegree
                              ? Colors.white
                              : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: controller.toggleScientific,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: controller.isScientific
                            ? Colors.teal.shade600
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'SCI',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: controller.isScientific
                              ? Colors.white
                              : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // History Button
              IconButton(
                icon: Badge(
                  label: Text('${controller.history.length}'),
                  isLabelVisible: controller.history.isNotEmpty,
                  child: const Icon(Icons.history_outlined),
                ),
                onPressed: onOpenHistory,
                tooltip: 'Calculation History',
              ),
            ],
          ),

          const Spacer(),

          // Formula Expression Display
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              controller.expression.isEmpty ? '0' : controller.expression,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Real-time / Evaluated Result Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (controller.result.isNotEmpty && controller.result != controller.expression)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  tooltip: 'Copy Result',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.result));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                )
              else
                const SizedBox.shrink(),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    controller.result.isEmpty
                        ? (controller.expression.isEmpty ? '0' : '')
                        : controller.result,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
