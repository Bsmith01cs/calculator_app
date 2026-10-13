import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator State Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _accumulator;
  String? _pendingOperator;
  bool _awaitingOperand = false;
  bool _afterEquals = false;
  bool _hasError = false;
  String _message = 'Enter a number to begin.';

  void _resetState() {
    _display = '0';
    _accumulator = null;
    _pendingOperator = null;
    _awaitingOperand = false;
    _afterEquals = false;
    _hasError = false;
    _message = 'Calculator cleared.';
  }

  void _pressDigit(String digit) {
    if (_afterEquals || _hasError) _resetState();
    if (_awaitingOperand || _display == '0') {
      _display = digit;
      _awaitingOperand = false;
    } else {
      _display += digit;
    }
    _afterEquals = false;
    _message = _pendingOperator == null
        ? 'Enter an operator or another digit.'
        : 'Enter another digit, operator, or equals.';
  }

  double? _calculate(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '−':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? null : a / b;
      default:
        return null;
    }
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toString();
  }

  void _showCalculationError() {
    _display = 'Error';
    _accumulator = null;
    _pendingOperator = null;
    _awaitingOperand = false;
    _afterEquals = false;
    _hasError = true;
    _message =
        'Cannot divide by zero or use an invalid result. Tap AC or a digit.';
  }

  void _pressOperator(String operator) {
    if (_hasError) return;
    if (_awaitingOperand) {
      _pendingOperator = operator;
      _message = 'Operator replaced. Enter the next number.';
      return;
    }

    final current = double.tryParse(_display);
    if (current == null || !current.isFinite) {
      _showCalculationError();
      return;
    }

    if (_pendingOperator != null && _accumulator != null) {
      final result = _calculate(_accumulator!, current, _pendingOperator!);
      if (result == null || !result.isFinite) {
        _showCalculationError();
        return;
      }
      _accumulator = result;
      _display = _formatNumber(result);
    } else {
      _accumulator = current;
    }

    _pendingOperator = operator;
    _awaitingOperand = true;
    _afterEquals = false;
    _message = 'Enter the next number.';
  }

  void _pressEquals() {
    if (_hasError) return;
    if (_awaitingOperand) {
      // Preserve the pending operator: "7 + =" does nothing to the display.
      _message = 'Enter a number before pressing equals.';
      return;
    }
    if (_pendingOperator == null || _accumulator == null) {
      _afterEquals = true;
      _message = 'Enter a digit to start a fresh calculation.';
      return;
    }

    final current = double.tryParse(_display);
    if (current == null || !current.isFinite) {
      _showCalculationError();
      return;
    }
    final result = _calculate(_accumulator!, current, _pendingOperator!);
    if (result == null || !result.isFinite) {
      _showCalculationError();
      return;
    }

    _display = _formatNumber(result);
    _accumulator = null;
    _pendingOperator = null;
    _awaitingOperand = false;
    _afterEquals = true;
    _message = 'Result. Enter a digit to start a new calculation.';
  }

  void _press(String label) {
    setState(() {
      if (label == 'AC') {
        _resetState();
      } else if (RegExp(r'^\d$').hasMatch(label)) {
        _pressDigit(label);
      } else if (label == '=') {
        _pressEquals();
      } else {
        _pressOperator(label);
      }
    });
  }

  String _buttonLabel(String label) {
    switch (label) {
      case 'AC':
        return 'All clear';
      case '=':
        return 'Equals';
      case '+':
        return 'Add';
      case '−':
        return 'Subtract';
      case '×':
        return 'Multiply';
      case '÷':
        return 'Divide';
      default:
        return 'Digit $label';
    }
  }

  Widget _calculatorButton(String label) {
    final isOperator = const ['+', '−', '×', '÷'].contains(label);
    final background = label == 'AC'
        ? const Color(0xFF9F1239)
        : label == '='
        ? const Color(0xFF047857)
        : isOperator
        ? const Color(0xFF374151)
        : const Color(0xFF1F2937);
    return Expanded(
      flex: (label == 'AC' || label == '0') ? 3 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(16),
          child: Semantics(
            button: true,
            label: _buttonLabel(label),
            child: InkWell(
              key: Key('key_$label'),
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white30,
              highlightColor: Colors.white12,
              onTap: () => _press(label),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (final label in labels) _calculatorButton(label)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'LEFT-TO-RIGHT CALCULATOR',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 75,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Semantics(
                            liveRegion: true,
                            label: 'Calculator display: $_display',
                            child: Text(
                              _display,
                              key: const Key('display_text'),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 58,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 46,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _message,
                            key: const Key('message_text'),
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buttonRow(['AC', '÷']),
                    _buttonRow(['7', '8', '9', '×']),
                    _buttonRow(['4', '5', '6', '−']),
                    _buttonRow(['1', '2', '3', '+']),
                    _buttonRow(['0', '=']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
