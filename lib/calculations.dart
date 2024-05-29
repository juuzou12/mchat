
import 'dart:async';
import 'dart:ui';

import 'apis.dart';

Future<int> getIncomes() async {
  int amount = 0;
  final results = await getRecords("income");
  List list = results.items;
  // list.forEach((element) { })
  amount= results.items[0].data['amount'];
  return amount;
}
Future<int> getExpense() async {
  int amount = 0;
  final results = await getRecords("expenses");
  List items = results.items;
  for (var element in items) {
    amount = (amount + element.data['amount']) as int;
  }
  return amount;
}

Future <int> getSavings()async{
  int amount = 0;
  final results = await getRecords("savings");
  List items = results.items;
  for (var element in items) {
    amount = (amount + element.data['amount']) as int;
  }
  return amount;
}

Future <int> getBalance()async{
  int amount = 0;
  int income = await getIncomes();
  int savings = await getSavings();
  int expense = await getExpense();
  amount = income - expense - savings;
  return amount;
}