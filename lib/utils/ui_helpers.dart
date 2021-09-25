import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../utils.dart';
import './rx_value.dart';


var textDateLabel = TextStyle(fontSize: 20);
var textLabelButton = TextStyle(
  fontSize: 18,
  decoration: TextDecoration.underline,
  decorationColor: Colors.blue,
  decorationStyle: TextDecorationStyle.dotted
);
var textLabel = TextStyle(
  fontSize: 18,
);

class Valid {
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    
    return null;
  }

  static String? number(String? value) {
    var reg = new RegExp(r"^\d+$");
    if (value != null && !value.isEmpty && !reg.hasMatch(value)) {
      return 'Only numbers';
    }
    
    return null;
  }

  static String? phoneNumber(String? value) {
    var reg = new RegExp(r"^\d{10}$");
    if (value != null && !value.isEmpty && !reg.hasMatch(value)) {
      return 'Only 10 digist';
    }
    
    return null;
  }
}

class TextInp extends StatelessWidget {
  final TextInputType? keyboardType;
  final InputBorder? border;
  final int? maxLines;
  final Symbol? attr;
  final IconData? icon;
  final String? labelText;
  final String? helperText;
  final List<Function> valid;
  late final ValueNotifier<String?> inp;
  late final Cell error;
  
  TextInp(
    {String value = "", this.attr, this.keyboardType,
      this.maxLines, this.border,
      this.icon, this.labelText, this.helperText,
      this.valid = const [],}
  ) {
    this.inp = ValueNotifier(null);
    this.error = ~(_) {
      return this.valid.map(
        (v) => v(_(this.inp))
      ).firstWhere(notNull, orElse: () => null);
    };
  }
  
  Widget build(BuildContext ctx) {
    var ctrl;
    
    ctrl ??= TextEditingController(
      text: this.inp.value
    );
    
    return ~Cell<Widget>((_) =>
      TextField(
        onChanged: (v) => this.inp.value = v,
        controller: ctrl,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: border,
          errorText: _(error),
          icon: Icon(icon),
          labelText: labelText,
          helperText: helperText
        ),
      )
    );
  }
} 
