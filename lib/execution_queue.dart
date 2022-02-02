library execution_queue;

import 'dart:async';

/// Queue element wrapper
class _Item {
  final completer;
  final job;
  _Item(this.completer, this.job);
}

/// Queue async jobs to run one after another
class ExecutionQueue {
  List<_Item> _queue = [];
  bool _active = false;

  // check if ready for next job
  void _check() async {
    if (!_active && _queue.isNotEmpty) {
      this._active = true;
      var item = _queue.removeAt(0);
      try {
        var result = await item.job();
        item.completer.complete(result);
      } catch (e) {
        item.completer.completeError(e);
      }
      this._active = false;
      this._check();
    }
  }

  /// add async job to queue
  Future<T> add<T>(Function job) {
    var completer = Completer<T>();
    this._queue.add(_Item(completer, job));
    this._check();
    return completer.future;
  }
}
