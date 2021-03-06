import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../utils.dart';


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

extension AutoW on Function {
  AutoBuildW operator ~() {
    return AutoBuildW(builder: this);
  }
}

class AutoBuild<T> extends StatefulWidget {
  const AutoBuild({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.child,
  }) : assert(valueListenable != null),
       assert(builder != null),
       super(key: key);

  final ValueListenable<T> valueListenable;

  final ValueWidgetBuilder<T> builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _AutoBuildState<T>();
}

class _AutoBuildState<T> extends State<AutoBuild<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(AutoBuild<T> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    if(widget.valueListenable.value != null) {
      setState(() { value = widget.valueListenable.value; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}

AutoBuild autow(f, rxval) {
  return AutoBuild(
    valueListenable: rxval,
    builder: (ctx, value, child) => f(value, ctx) as Widget
  );
} 

class AutoBuildW<T> extends StatefulWidget {
  const AutoBuildW({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Function builder;

  @override
  State<StatefulWidget> createState() => _AutoBuildWState<T>();
}

class _AutoBuildWState<T> extends State<AutoBuildW<T>> {
  final Set<ValueNotifier> _listenToValues = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(AutoBuildW<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for(var v in _listenToValues) {
      v.removeListener(_valueChanged);
      _listenToValues.remove(v);
    }
    
    super.dispose();
  }

  void _valueChanged() {
    setState(() { });
  }

  dynamic _read(ValueNotifier notifier) {
    if(!_listenToValues.contains(notifier)) {
      _listenToValues.add(notifier);
      notifier.addListener(_valueChanged);
    }

    return notifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _read);
  }
}
