library execution_queue;

import 'dart:async';

class Item {
  final completer;
  final job;
  Item({this.completer, this.job});
}

class ExecutionQueue {
  List<Item> _queue = [];
  bool _active = false;

  _check() async {
    if (!_active && _queue.length > 0) {
      this._active = true;
      var item = _queue.removeAt(0);
      item.completer.complete(await item.job());
      this._active = false;
      this._check();
    }
  }

  Future add(Function job) {
    var completer = new Completer();
    this._queue.add(new Item(completer: completer, job: job));
    this._check();
    return completer.future;
  }
}
