import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:math_expressions/math_expressions.dart';
import '../models/history_item.dart';

class CalculatorController extends ChangeNotifier {
  String _expression = '';
  String _result = '';
  String _lastAns = '';
  bool _isDegree = true;
  bool _isScientific = false;
  final List<HistoryItem> _history = [];

  String get expression => _expression;
  String get result => _result;
  String get lastAns => _lastAns;
  bool get isDegree => _isDegree;
  bool get isScientific => _isScientific;
  List<HistoryItem> get history => List.unmodifiable(_history);

  void append(String text) {
    // If text is an operator and expression is empty, but we have lastAns, prepend lastAns
    if (['+', '-', '×', '÷', '^', '%'].contains(text) && _expression.isEmpty && _lastAns.isNotEmpty) {
      _expression = 'Ans';
    }

    // Handle functions that need opening parenthesis
    if (['sin', 'cos', 'tan', 'log', 'ln', '√'].contains(text)) {
      _expression += '$text(';
    } else {
      _expression += text;
    }

    _calculateRealTimeResult();
    notifyListeners();
  }

  void delete() {
    if (_expression.isEmpty) return;

    // Check if ends with function name + parenthesis e.g. "sin(", "cos(", "tan(", "log(", "ln(", "√("
    final functions = ['sin(', 'cos(', 'tan(', 'log(', 'ln(', '√('];
    bool deletedFunc = false;
    for (var f in functions) {
      if (_expression.endsWith(f)) {
        _expression = _expression.substring(0, _expression.length - f.length);
        deletedFunc = true;
        break;
      }
    }

    if (!deletedFunc) {
      if (_expression.endsWith('Ans')) {
        _expression = _expression.substring(0, _expression.length - 3);
      } else {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    }

    _calculateRealTimeResult();
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '';
    notifyListeners();
  }

  void allClear() {
    _expression = '';
    _result = '';
    notifyListeners();
  }

  void toggleDegree() {
    _isDegree = !_isDegree;
    _calculateRealTimeResult();
    notifyListeners();
  }

  void toggleScientific() {
    _isScientific = !_isScientific;
    notifyListeners();
  }

  void insertAns() {
    if (_lastAns.isNotEmpty) {
      append('Ans');
    }
  }

  void toggleSign() {
    if (_expression.isEmpty) return;

    // Check if the current expression can be wrapped or negated
    if (_expression.startsWith('-(') && _expression.endsWith(')')) {
      _expression = _expression.substring(2, _expression.length - 1);
    } else if (_expression.startsWith('-')) {
      _expression = _expression.substring(1);
    } else {
      _expression = '-($_expression)';
    }

    _calculateRealTimeResult();
    notifyListeners();
  }

  void evaluate() {
    if (_expression.isEmpty) return;

    String finalResult = _parseAndEvaluate(_expression);
    if (finalResult != 'Error' && finalResult != 'Infinity' && finalResult != 'NaN') {
      _result = finalResult;
      _lastAns = finalResult;
      _history.insert(
        0,
        HistoryItem(
          expression: _expression,
          result: finalResult,
          timestamp: DateTime.now(),
        ),
      );
      _expression = finalResult; // Set result as current expression for chaining
    } else {
      _result = finalResult;
    }
    notifyListeners();
  }

  void loadHistoryItem(HistoryItem item) {
    _expression = item.expression;
    _result = item.result;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  void _calculateRealTimeResult() {
    if (_expression.trim().isEmpty) {
      _result = '';
      return;
    }
    String eval = _parseAndEvaluate(_expression);
    if (eval != 'Error') {
      _result = eval;
    } else {
      _result = '';
    }
  }

  String _parseAndEvaluate(String exprStr) {
    try {
      String sanitized = exprStr;

      // Replace symbols
      sanitized = sanitized.replaceAll('Ans', _lastAns.isNotEmpty ? _lastAns : '0');
      sanitized = sanitized.replaceAll('×', '*');
      sanitized = sanitized.replaceAll('÷', '/');
      sanitized = sanitized.replaceAll('√(', 'sqrt(');
      sanitized = sanitized.replaceAll('π', math.pi.toString());
      sanitized = sanitized.replaceAll('e', math.e.toString());

      // Replace percentages e.g., 50% -> (50/100)
      sanitized = sanitized.replaceAllMapped(
        RegExp(r'(\d+(\.\d+)?)%'),
        (match) => '(${match.group(1)}/100)',
      );

      // Handle trig conversions if Degree mode is active
      if (_isDegree) {
        // Convert sin(arg), cos(arg), tan(arg) arguments from degrees to radians
        sanitized = _convertTrigDegreesToRadians(sanitized);
      }

      GrammarParser parser = GrammarParser();
      Expression exp = parser.parse(sanitized);
      double eval = RealEvaluator().evaluate(exp).toDouble();

      if (eval.isNaN) return 'NaN';
      if (eval.isInfinite) return 'Infinity';

      return _formatNumber(eval);
    } catch (e) {
      return 'Error';
    }
  }

  String _convertTrigDegreesToRadians(String expr) {
    // Regex for matching sin(...), cos(...), tan(...)
    final trigRegex = RegExp(r'(sin|cos|tan)\(([^()]+)\)');
    String result = expr;

    // Iteratively replace inner trig calls
    int limit = 0;
    while (trigRegex.hasMatch(result) && limit < 10) {
      result = result.replaceAllMapped(trigRegex, (match) {
        String func = match.group(1)!;
        String arg = match.group(2)!;
        return '$func(($arg) * ${math.pi} / 180)';
      });
      limit++;
    }
    return result;
  }

  String _formatNumber(double number) {
    if (number.abs() < 1e-10 && number != 0) {
      return '0';
    }

    // Check if integer or practically integer
    if ((number - number.roundToDouble()).abs() < 1e-10) {
      return number.round().toString();
    }

    // Format with max 8 decimal places and strip trailing zeros
    String formatted = number.toStringAsFixed(8);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }
}
