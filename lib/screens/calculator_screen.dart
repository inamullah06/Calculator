import 'package:flutter/material.dart';

import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display_section.dart';
import '../widgets/history_drawer.dart';
import '../widgets/scientific_keypad.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const CalculatorScreen({super.key, required this.onToggleTheme});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => HistoryDrawer(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              children: [
                // Top Display Section
                Expanded(
                  flex: 3,
                  child: DisplaySection(
                    controller: _controller,
                    onToggleTheme: widget.onToggleTheme,
                    onOpenHistory: _openHistory,
                  ),
                ),

                const Divider(height: 1, thickness: 1),

                // Keypad Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Expandable Scientific Keypad
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: ScientificKeypad(controller: _controller),
                        crossFadeState: _controller.isScientific
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),

                      if (_controller.isScientific) const SizedBox(height: 6),

                      // Standard Keypad Rows
                      Row(
                        children: [
                          CalculatorButton(
                            text: _controller.expression.isEmpty ? 'AC' : 'C',
                            type: ButtonType.action,
                            onTap: () {
                              if (_controller.expression.isEmpty) {
                                _controller.allClear();
                              } else {
                                _controller.clear();
                              }
                            },
                          ),
                          CalculatorButton(
                            text: '+/-',
                            type: ButtonType.action,
                            onTap: _controller.toggleSign,
                          ),
                          CalculatorButton(
                            text: '%',
                            type: ButtonType.action,
                            onTap: () => _controller.append('%'),
                          ),
                          CalculatorButton(
                            text: '÷',
                            type: ButtonType.operator,
                            onTap: () => _controller.append('÷'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalculatorButton(
                            text: '7',
                            type: ButtonType.number,
                            onTap: () => _controller.append('7'),
                          ),
                          CalculatorButton(
                            text: '8',
                            type: ButtonType.number,
                            onTap: () => _controller.append('8'),
                          ),
                          CalculatorButton(
                            text: '9',
                            type: ButtonType.number,
                            onTap: () => _controller.append('9'),
                          ),
                          CalculatorButton(
                            text: '×',
                            type: ButtonType.operator,
                            onTap: () => _controller.append('×'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalculatorButton(
                            text: '4',
                            type: ButtonType.number,
                            onTap: () => _controller.append('4'),
                          ),
                          CalculatorButton(
                            text: '5',
                            type: ButtonType.number,
                            onTap: () => _controller.append('5'),
                          ),
                          CalculatorButton(
                            text: '6',
                            type: ButtonType.number,
                            onTap: () => _controller.append('6'),
                          ),
                          CalculatorButton(
                            text: '-',
                            type: ButtonType.operator,
                            onTap: () => _controller.append('-'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalculatorButton(
                            text: '1',
                            type: ButtonType.number,
                            onTap: () => _controller.append('1'),
                          ),
                          CalculatorButton(
                            text: '2',
                            type: ButtonType.number,
                            onTap: () => _controller.append('2'),
                          ),
                          CalculatorButton(
                            text: '3',
                            type: ButtonType.number,
                            onTap: () => _controller.append('3'),
                          ),
                          CalculatorButton(
                            text: '+',
                            type: ButtonType.operator,
                            onTap: () => _controller.append('+'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CalculatorButton(
                            text: '0',
                            type: ButtonType.number,
                            onTap: () => _controller.append('0'),
                          ),
                          CalculatorButton(
                            text: '.',
                            type: ButtonType.number,
                            onTap: () => _controller.append('.'),
                          ),
                          CalculatorButton(
                            text: '⌫',
                            icon: Icons.backspace_outlined,
                            type: ButtonType.action,
                            onTap: _controller.delete,
                          ),
                          CalculatorButton(
                            text: '=',
                            type: ButtonType.operator,
                            onTap: _controller.evaluate,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
