import 'package:flutter/material.dart';

import '../controllers/calculator_controller.dart';
import 'calculator_button.dart';

class ScientificKeypad extends StatelessWidget {
  final CalculatorController controller;

  const ScientificKeypad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CalculatorButton(
              text: 'sin',
              type: ButtonType.scientific,
              onTap: () => controller.append('sin'),
            ),
            CalculatorButton(
              text: 'cos',
              type: ButtonType.scientific,
              onTap: () => controller.append('cos'),
            ),
            CalculatorButton(
              text: 'tan',
              type: ButtonType.scientific,
              onTap: () => controller.append('tan'),
            ),
            CalculatorButton(
              text: 'log',
              type: ButtonType.scientific,
              onTap: () => controller.append('log'),
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: 'ln',
              type: ButtonType.scientific,
              onTap: () => controller.append('ln'),
            ),
            CalculatorButton(
              text: '√',
              type: ButtonType.scientific,
              onTap: () => controller.append('√'),
            ),
            CalculatorButton(
              text: 'x^y',
              type: ButtonType.scientific,
              onTap: () => controller.append('^'),
            ),
            CalculatorButton(
              text: '%',
              type: ButtonType.scientific,
              onTap: () => controller.append('%'),
            ),
          ],
        ),
        Row(
          children: [
            CalculatorButton(
              text: '(',
              type: ButtonType.scientific,
              onTap: () => controller.append('('),
            ),
            CalculatorButton(
              text: ')',
              type: ButtonType.scientific,
              onTap: () => controller.append(')'),
            ),
            CalculatorButton(
              text: 'π',
              type: ButtonType.scientific,
              onTap: () => controller.append('π'),
            ),
            CalculatorButton(
              text: 'e',
              type: ButtonType.scientific,
              onTap: () => controller.append('e'),
            ),
          ],
        ),
      ],
    );
  }
}
