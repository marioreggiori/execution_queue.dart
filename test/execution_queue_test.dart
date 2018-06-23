import 'package:test/test.dart';
import 'dart:async';
import 'package:execution_queue/execution_queue.dart';

void main() {
  test('queues jobs', () async {
    final queue = new ExecutionQueue();
    var a = '';

    var b = await queue
        .add(() => Future.delayed(Duration(seconds: 4), () => a + 'Hello'));

    var c = await queue
        .add(() => Future.delayed(Duration(seconds: 2), () => b + ' World!'));

    expect(b, 'Hello');
    expect(c, 'Hello World!');
  });
}
