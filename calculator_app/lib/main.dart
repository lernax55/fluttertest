import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' show sqrt, pow;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hesap Makinesi',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF90A4AE),
          secondary: Color(0xFFB0BEC5),
          surface: Color(0xFFECEFF1),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF263238),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF37474F),
          secondary: Color(0xFF455A64),
          surface: Color(0xFF1C313A),
        ),
      ),
      themeMode: ThemeMode.system,
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
  String _expression = '';
  String _result = '';
  bool _hasOperator = false;
  bool _isNewCalculation = false;
  int _openParentheses = 0; // Açık parantez sayısını tutmak için
  bool _isDarkMode = false; // Dark mod durumunu tutmak için

  @override
  void initState() {
    super.initState();
    // Başlangıçta sistem ayarını kontrol et
    _isDarkMode =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  bool _isOperator(String text) {
    return text == '+' ||
        text == '-' ||
        text == '×' ||
        text == '÷' ||
        text == '^' ||
        text == '%';
  }

  String _formatExpression(String expression) {
    if (expression.contains('%')) {
      expression = expression.replaceAll('%', '');
      try {
        double number = double.parse(expression);
        expression = (number / 100).toString();
      } catch (e) {
        return 'Hata';
      }
    }

    if (expression.contains('^')) {
      List<String> parts = expression.split('^');
      if (parts.length == 2) {
        try {
          double base = double.parse(parts[0]);
          double exponent = double.parse(parts[1]);
          expression = pow(base, exponent).toString();
        } catch (e) {
          return 'Hata';
        }
      } else {
        return 'Hata';
      }
    }

    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll('÷', '/');

    return expression;
  }

  void _calculateResult() {
    try {
      if (_expression.isEmpty || _expression == '-') {
        _result = '';
        return;
      }

      // Parantezleri kontrol et
      if (!_isBalancedParentheses(_expression)) {
        _result = '';
        return;
      }

      // Önce özel işlemleri yap (%, ^)
      String formattedExp = _formatExpression(_expression);
      if (formattedExp == 'Hata') {
        _result = 'Hata';
        return;
      }

      Parser p = Parser();
      Expression exp = p.parse(formattedExp);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) {
        _result = 'Hata';
        return;
      }

      if (eval == eval.roundToDouble()) {
        _result = eval.round().toString();
      } else {
        _result = eval
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      _result = 'Hata';
    }
  }

  bool _isBalancedParentheses(String expression) {
    int count = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') {
        count++;
      } else if (expression[i] == ')') {
        count--;
      }
      if (count < 0) return false;
    }
    return count == 0;
  }

  int _factorial(int n) {
    if (n < 0) return 0;
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _result = '';
        _hasOperator = false;
        _isNewCalculation = false;
        _openParentheses = 0;
      } else if (buttonText == '⌫') {
        if (_expression.isNotEmpty) {
          String lastChar = _expression[_expression.length - 1];
          if (lastChar == '(') {
            _openParentheses--;
          } else if (lastChar == ')') {
            _openParentheses++;
          }
          _expression = _expression.substring(0, _expression.length - 1);
          if (_isOperator(lastChar)) {
            _hasOperator = false;
          }
          if (_expression.isNotEmpty) {
            _calculateResult();
          } else {
            _result = '';
          }
        }
      } else if (buttonText == '(') {
        if (_expression.isEmpty ||
            _isOperator(_expression[_expression.length - 1]) ||
            _expression[_expression.length - 1] == '(') {
          _expression += '(';
          _openParentheses++;
          _hasOperator = false; // Parantez sonrası operatör eklenebilmeli
        }
      } else if (buttonText == ')') {
        if (_openParentheses > 0 &&
            _expression.isNotEmpty &&
            !_isOperator(_expression[_expression.length - 1])) {
          _expression += ')';
          _openParentheses--;
          _calculateResult();
          _hasOperator = false; // Parantez sonrası operatör eklenebilmeli
        }
      } else if (buttonText == '=') {
        if (_expression.isNotEmpty) {
          // Eksik parantezleri otomatik kapat
          while (_openParentheses > 0) {
            _expression += ')';
            _openParentheses--;
          }
          _calculateResult();
          if (_result != 'Hata') {
            _expression = _result;
            _hasOperator = false;
            _isNewCalculation = true;
          }
        }
      } else if (buttonText == '%') {
        if (_expression.isNotEmpty && !_expression.contains('%')) {
          _expression += '%';
          _calculateResult();
          if (_result != 'Hata') {
            _expression = _result;
            _hasOperator = false;
            _isNewCalculation = true;
          }
        }
      } else if (buttonText == '^') {
        if (_expression.isNotEmpty &&
            !_expression.contains('^') &&
            _result != 'Hata') {
          _expression += '^';
          _hasOperator = true;
          _isNewCalculation = false;
        }
      } else if (_isOperator(buttonText)) {
        if (_expression.isNotEmpty && !_hasOperator && _result != 'Hata') {
          _expression += buttonText;
          _hasOperator = true;
          _isNewCalculation = false;
        } else if (_expression.isEmpty && buttonText == '-') {
          _expression = buttonText;
        }
      } else if (buttonText == '!') {
        try {
          if (_expression.isNotEmpty) {
            double number = double.parse(_expression);
            if (number == number.roundToDouble() &&
                number >= 0 &&
                number <= 20) {
              int result = _factorial(number.round());
              _result = result.toString();
              _expression = _result;
              _isNewCalculation = true;
            } else {
              _result = 'Hata';
            }
          }
        } catch (e) {
          _result = 'Hata';
        }
      } else if (buttonText == '√') {
        if (_expression.isEmpty) {
          _expression = '0';
          _result = '0';
        } else {
          try {
            double number = double.parse(_expression);
            if (number >= 0) {
              double result = sqrt(number);
              if (result == result.roundToDouble()) {
                _result = result.round().toString();
              } else {
                _result = result
                    .toStringAsFixed(8)
                    .replaceAll(RegExp(r'0*$'), '')
                    .replaceAll(RegExp(r'\.$'), '');
              }
              _expression = _result;
              _isNewCalculation = true;
            } else {
              _result = 'Hata';
            }
          } catch (e) {
            _result = 'Hata';
          }
        }
      } else {
        if (_isNewCalculation && !_isOperator(buttonText)) {
          _expression = buttonText;
          _result = '';
          _isNewCalculation = false;
        } else {
          _expression += buttonText;
        }
        if (!_isOperator(buttonText)) {
          _calculateResult();
        }
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color, double size = 1}) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ??
              (_isDarkMode ? const Color(0xFF37474F) : const Color(0xFFE0E0E0)),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(24),
        ),
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 24 * size,
            color: _isDarkMode
                ? (color == Colors.grey[800] ? Colors.white : Colors.white)
                : (color == Colors.grey[800] ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF263238) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor:
            _isDarkMode ? const Color(0xFF1C313A) : const Color(0xFFECEFF1),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _isDarkMode
                  ? const Color(0xFF90A4AE)
                  : const Color(0xFF455A64),
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 700,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _isDarkMode
                  ? const Color(0xFF263238)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _expression,
                          style: TextStyle(
                            fontSize: 24,
                            color: _isDarkMode
                                ? const Color(0xFF90A4AE)
                                : const Color(0xFF455A64),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _result,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode
                                ? const Color(0xFFECEFF1)
                                : const Color(0xFF263238),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? const Color(0xFF1C313A)
                        : const Color(0xFFECEFF1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('√'),
                          _buildButton('%'),
                          _buildButton('^'),
                          _buildButton('!'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('AC', color: Colors.grey[800]),
                          _buildButton('('),
                          _buildButton(')'),
                          _buildButton('÷'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('7'),
                          _buildButton('8'),
                          _buildButton('9'),
                          _buildButton('×'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('4'),
                          _buildButton('5'),
                          _buildButton('6'),
                          _buildButton('-'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('1'),
                          _buildButton('2'),
                          _buildButton('3'),
                          _buildButton('+'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton('0'),
                          _buildButton('.'),
                          _buildButton('⌫'),
                          _buildButton('=', color: Colors.grey[800]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
