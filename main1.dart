/*
 * 1. �������� ������� � ������� ���������� ����� Future ����� �������������� � �������
 * then, � ������ - � ������� await. � ��� �������?
 * ������� - ����� ������������ then() ��� ����������� ��������� ������. 
 * ���� �������� ����� ���������, ����� future ����������.
 */

const oneSecond = Duration(seconds: 1);
const twoSecond = Duration(seconds: 2);
const threeSecond = Duration(seconds: 3);

Future<void> printWithDelay(String message) async {
  await Future.delayed(twoSecond);
  print(message);
}

Future<String> stringWithDelay(String message) async {
  await Future.delayed(threeSecond);
  return message;
}

Future<void> printWithDelay2(String message) async {
  final future = stringWithDelay(message);
  return future.then(print);
}

void testFirst() async {
  print('1 waiting for message...');
  printWithDelay('awaited message1');
  printWithDelay2('awaited message3');
  await Future.delayed(oneSecond);
  print('awaited message2');  
}

/*
 * 2. �������� ������� � ������� Future ����� ����������� ��������������� ���� ��
 * ������ ����� ���������. ��� ��� ����� ������: � ������� then ��� await?
 * ��������� ���� �����.
 * ��� ����������������� - await. ������ ����� await �� ��������, ���� �� ���������� ����������,
 * � ����� ����� ������ ����������� ������ ���� ������� await
 */

Future<void> printWithDelay3(String message) async {
  await Future.delayed(threeSecond);
  print(message);
}

void testSecond() async {
  print('2 waiting for messages...');
  await printWithDelay2('awaited message2-1');
  await printWithDelay2('awaited message2-2');
}

/*
 * 3. �������� �������, � ������� ����� ��������� 2 Future (� ������� await). � ������
 * � � ����� ������� �������� �� ����� �����. � ��� �� ����� ���������� ������ Future.
 * Future ����������� ������������ ��� ���� �� ������? ��� �� ��� �����?
 * 
 * ����������� ������������ �����������. ����� ������ ����������� ������� ��������� ���������� ������, 
 * �������� ������ ����������� ������� ������ �����. ���������� ����� �� �����.
 */

Future<void> printWithDelayAndLog(String message) async {
  var now = DateTime.now();
  print('start print message $message $now');
  await Future.delayed(twoSecond);
  print(message);
  now = DateTime.now();
  print('finish print message $message $now');
}

void testMulti() async {
  print('3 waiting for message...');
  printWithDelayAndLog('awaited message3-1');
  printWithDelayAndLog('awaited message3-2');
}

void printDate([String comment = 'main']) => print('$comment: ${DateTime.now()}');

/*
 * 4. �������� ������� � ������������ ������ ���������� �� Future ����� ���������.
 */
Future<void> printWithDelay4(String message) async {
  final future = stringWithDelay(message);
  if (true) {
    throw Exception('printWithDelay4 exception'); 
  }
  return future.then(print);
}

void test4() async {
  try {
    print('4 waiting for message...');
    await printWithDelay4('awaited message4-1');
  } catch (err) {
    print('Caught error: $err');
  }  
  /* ������� ������� ��������� ������ �� ����� */
}

/*
 * 5. ������ �� ������� 3 �������� ������� ����� �������, ����� �������� ���������
 * 2 Future, �� ������� ����� ��������� �����������. ��� �� �����, ��� ��� �����������
 * �����������?
 * 
 * ���������� �������� ������ 3 testMulti, �� ���� ����� ������������ ����������
 */

Future<void> printWithDelayAndLog5(String message) async {
  var now = DateTime.now();
  print('start print message $message $now');
  await Future.delayed(twoSecond);
  print(message);
  now = DateTime.now();
  print('finish print message $message $now');
}

void test5() async {
  print('5 waiting for message...');
  printWithDelayAndLog5('awaited message5-1');
  printWithDelayAndLog5('awaited message5-2');
}

void main() {
//  testFirst();
//   testSecond();
//   testMulti();
//   test4();
   test5();
}


/* ����� ������� (������ �������� � ��������� ������ ����� �������):
 * 1. �������� �� ������� ������� ���������� async, ��� ���� � ���� �������
 * ����� await �� ��������������?
 * - ���, �� ������. ������� ����� ��������� ��� ������� ����������.
 * 2. ����� ����������� ������������ ������� � ������ Future ��� ������
 * � ����������? ����� ��������
 * Future - ������� �����, ��������� �������� uncomlited �� ���������� ������������ �������� � complited �����
 * Future<T>.delayed(
 *   Duration duration,
 *   [FutureOr<T> computation()?]
 *  )
 *  Creates a future that runs its computation after a delay.
 * Future<T>.error Creates a future that completes with an error.
   
 * 3. ����� ������ ���������� � ������ Future (������ catchError) ��� ���������
 * ����������? ��� ����� ��������������� ��� ����� �� ���������?
 * then - Register callbacks to be called when this future completes
 * timeout - Time-out the future computation after timeLimit has passed.
 */