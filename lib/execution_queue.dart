library execution_queue;

import 'dart:async';

class _Item {
  final completer;
  final job;
  _Item(this.completer, this.job);
}

class ExecutionQueue {
  List<_Item> _queue = [];
  bool _active = false;

  void _check() async {
    if (!_active && _queue.length > 0) {
      this._active = true;
      var item = _queue.removeAt(0);
      item.completer.complete(await item.job());
      this._active = false;
      this._check();
    }
  }

  Future<T> add<T>(Function job) {
    var completer = Completer<T>();
    this._queue.add(_Item(completer, job));
    this._check();
    return completer.future;
  }
}
