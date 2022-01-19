/*
 * 1. Написать функцию в которой результаты одной Future будут обрабатываться с помощью
 * then, а другой - с помощью await. В чем разница?
 * разница - метод используется then() для регистрации обратного вызова. 
 * Этот обратный вызов сработает, когда future завершится.
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
 * 2. Написать функцию в которой Future будут выполняться последовательно друг за
 * другом двумя способами. Как это лучше делать: с помощью then или await?
 * Обоснуйте свой выбор.
 * для последовательного - await. каждый новый await НЕ стартует, пока не завершится предыдущий,
 * в одном блоке всегда выполняется только одна команда await
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
 * 3. Написать функцию, в которой будет ожидаться 2 Future (с помощью await). В начале
 * и в конце функции выведите на экран время. А так же после исполнения каждой Future.
 * Future выполнялись одновременно или друг за другом? Как ты это понял?
 * 
 * выполнялись одновременно параллельно. вызов каждой асинхронной функции передавал управление дальше, 
 * блокируя только последующие функции своего блока. результаты видно по логам.
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
 * 4. Написать функцию с обработчиком ошибки полученной из Future двумя способами.
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
  /* второго способа обработки ошибок не нашел */
}

/*
 * 5. Исходя из задания 3 перепиши функцию таким образом, чтобы ожидался результат
 * 2 Future, но которые будут выполнены параллельно. Как ты понял, что они выполнились
 * параллельно?
 * 
 * фактически повторил пример 3 testMulti, по логу видно параллельное выполнение
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


/* Общие вопросы (ответы написать в следующей строке после вопроса):
 * 1. Является ли ошибкой функция помеченная async, при этом в теле функции
 * слово await не использовалось?
 * - нет, не ошибка. функция будет выполнена как обычная синхронная.
 * 2. Какие именованные конструкторы имеются у класса Future для помощи
 * в разработке? Самые основные
 * Future - создает класс, результат которого uncomlited до завершения асинхронного процесса и complited после
 * Future<T>.delayed(
 *   Duration duration,
 *   [FutureOr<T> computation()?]
 *  )
 *  Creates a future that runs its computation after a delay.
 * Future<T>.error Creates a future that completes with an error.
   
 * 3. какие методы существуют у класса Future (помимо catchError) для обработки
 * результата? При каких обстоятельствах они могут не вызваться?
 * then - Register callbacks to be called when this future completes
 * timeout - Time-out the future computation after timeLimit has passed.
 */