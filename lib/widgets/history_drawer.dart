import 'package:flutter/material.dart';

import '../controllers/calculator_controller.dart';
import '../models/history_item.dart';

class HistoryDrawer extends StatelessWidget {
  final CalculatorController controller;

  const HistoryDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle indicator bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Title & Clear History
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculation History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              if (controller.history.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    controller.clearHistory();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  label: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
          const Divider(),

          // History List
          Expanded(
            child: controller.history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          size: 48,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No history yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: controller.history.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final HistoryItem item = controller.history[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        title: Text(
                          item.expression,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        subtitle: Text(
                          '= ${item.result}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        onTap: () {
                          controller.loadHistoryItem(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
