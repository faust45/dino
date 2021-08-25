import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../utils.dart';

abstract class CallableWidget {
  Widget call(); 
}

class Cell<T> extends ChangeNotifier implements ValueListenable<T> {
  Function _body;
  Set _rxToObserv = {};
  bool isInit = false;
  late T _value; 

  Cell(this._body);

  T get value {
    if (!isInit) {
      this._value = this._body(_get);
      isInit = true;
    }

    return this._value;
  }

  Widget operator ~() {
    return ValueListenableBuilder(
      valueListenable: this,
      builder: (context, value, child) => value as Widget
    );
  }

  void dispose() {
    _rxToObserv.forEach((v) { 
        v.removeListener(_onChange);
    });
    super.dispose();
  }

  void _onChange() {
    _rxToObserv.forEach((v) { 
        v.removeListener(_onChange);
    });
    _rxToObserv = {};
    var newValue = _body(_get);

    if (_value == newValue)
    return;

    _value = newValue;
    notifyListeners();
  }

  dynamic _get(ValueListenable rx) {
    if (!_rxToObserv.contains(rx)) {
      _rxToObserv.add(rx);
      rx.addListener(_onChange);
    }

    return rx.value;
  }
}


ValueListenableBuilder autob(f) {
  var widget = Cell(f);
  return ValueListenableBuilder(
    valueListenable: widget,
    builder: (context, value, child) => value
  );
}

ValueListenableBuilder autow(f, rxval) {
  return ValueListenableBuilder(
    valueListenable: rxval,
    builder: (context, value, child) => f(value) as Widget
  );
} 

ValueListenableBuilder autowc(f, ctx, rxval) {
  return ValueListenableBuilder(
    valueListenable: rxval,
    builder: (ctx, value, child) => f(ctx, value) as Widget
  );
}

extension AB on Function {
  Cell operator ~() {
    return Cell(this);
  }
}

extension AutoBuildF on Function {
  Widget get autobuild {
    var widget = Cell(this);
    return ValueListenableBuilder(
      valueListenable: widget,
      builder: (context, value, child) => value as Widget
    );
  }
}

