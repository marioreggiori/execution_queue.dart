import 'package:execution_queue/execution_queue.dart';
import 'package:collection/collection.dart';

void main() async {
  // create queue
  final queue = ExecutionQueue();
  var numbers = [];

  // add task to queue
  queue.add<void>(
      () => Future.delayed(Duration(seconds: 4), () => numbers.add(1)));

  queue.add<void>(
      () => Future.delayed(Duration(seconds: 2), () => numbers.add(2)));

  queue.add<void>(
      () => Future.delayed(Duration(seconds: 7), () => numbers.add(3)));

  // add task with Future<String> response
  var hello = await queue
      .add<String>(() => Future.delayed(Duration(seconds: 7), () => 'world'));

  assert(hello == 'world');
  assert(ListEquality().equals(numbers, [1, 2, 3]));
}
