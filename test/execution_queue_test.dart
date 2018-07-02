import 'package:test/test.dart';
import 'dart:async';
import 'package:execution_queue/execution_queue.dart';

void main() {
  test('queues jobs', () async {
    final queue = ExecutionQueue();
    var a = '';

    String b = await queue
        .add<String>(() => Future.delayed(Duration(seconds: 4), () => a + 'Hello'));

    String c = await queue
        .add<String>(() => Future.delayed(Duration(seconds: 2), () => b + ' World!'));

    expect(b, 'Hello');
    expect(c, 'Hello World!');
  });
}
