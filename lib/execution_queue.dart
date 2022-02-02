library execution_queue;

import 'dart:async';

/// Queue element wrapper
class _Item<T> {
  final Completer<T> completer;
  final Function job;

  const _Item(this.completer, this.job);
}

/// Queue async jobs to run one after another
class ExecutionQueue {
  final List<_Item> _queue = [];
  bool _active = false;

  /// An optional timeout for a job. If the job is not completed in the given
  /// duration a TimeoutException will be thrown.
  Duration? timeLimit;

  ExecutionQueue({this.timeLimit});

  // check if ready for next job
  void _check() async {
    if (!_active && _queue.isNotEmpty) {
      this._active = true;
      _Item item = _queue.removeAt(0);
      try {
        Future future = item.job();
        if (timeLimit != null) {
          future = future.timeout(timeLimit!, onTimeout: () {
            throw TimeoutException(
                "Timeout after ${timeLimit.toString()}: ${item.job}");
          });
        }
        var result = await future;
        item.completer.complete(result);
      } catch (e) {
        item.completer.completeError(e);
      }
      this._active = false;
      this._check();
    }
  }

  /// adds async job to queue
  Future<T> add<T>(Function job) {
    var completer = Completer<T>();
    this._queue.add(_Item<T>(completer, job));
    this._check();
    return completer.future;
  }

  /// clears the queue as soon as the current job is completed. Returns a
  /// future which is completed when the clear() is finished.
  Future clear() {
    if (_queue.isEmpty) return Future.value();
    var completer = Completer();
    this._queue.insert(
        0,
        _Item(completer, () {
          _queue.clear();
        }));
    this._check();
    return completer.future;
  }
}
