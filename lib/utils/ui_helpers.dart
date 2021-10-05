import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../utils.dart';
import '../models.dart';
import '../models/master.dart';
import './rx_value.dart';
import 'package:built_collection/built_collection.dart';


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
        (v) => _(this.inp) != null ? v(_(this.inp)) : null
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

Widget selectTags(ValueNotifier<BuiltSet> selected, BuiltSet source) {
  var toggle = (tag) {
    var coll = selected.value.toBuilder();
    
    if (selected.value.contains(tag)) {
      coll.remove(tag);
    } else {
      coll.add(tag);
    }
    
    selected.value = coll.build();
  };

  Widget tagsCloud(selected, ctx) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        for(var tag in source)
        InputChip(
          label: Text(tag.name),
          selected: selected.contains(tag),
          onPressed: () => toggle(tag),
        ),
      ]
    );
  }

  return autow(tagsCloud, selected);
}

CircleAvatar avatar(Master doc) {
  return CircleAvatar(
    backgroundColor: Colors.white,
    // child: Image()
  );
}

class FormInput {
  Map<Symbol, ValueNotifier<String?>> _inputs = {};

  FormInput();

  ValueChanged<String> call(Symbol inputName) {
    _inputs[inputName] ??= ValueNotifier<String?>(null);
    
    ValueChanged<String> handleInput = (value) {
      _inputs[inputName]?.value = value;
    };

    return handleInput;
  }

  ValueNotifier<String?>? operator [](Symbol key) {
    _inputs[key] ??= ValueNotifier<String?>(null);

    return _inputs[key];
  }
}

Future<dynamic> openDialog(ctx, widget, {onDone}) async {
  return showDialog(
    context: ctx,
    builder: (BuildContext ctx) =>
    Dialog(
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 15),
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
            maxWidth: MediaQuery.of(ctx).size.width * 0.8
          ),
          child: Column(
            children: [
              (widget is Function) ? widget(ctx) : widget,
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("CANCEL"),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);

                      if(onDone != null) {
                        onDone();
                      }
                    },
                    child: Text("DONE"),
                  )
                ]
              )
            ]
          )  
        )
      )
    )
  );
}
