import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'apis.dart';
import 'calculations.dart';
import 'constants.dart';

String _baseUrl = "https://moneychat-ai.onrender.com";

/*post request
*
*shareExpenseRequest sample payload {
    "expense":[

  {"name": "House Rent", "color": "Color(0xff455a64)", "amount": 30000},
  {"name": "Power bill", "color": "Color(0xff4caf50)", "amount": 2000},
  {"name": "Netflix", "color": "Color(0xff311b92)", "amount": 780},
  {"name": "Self-care", "color": "Color(0xffbbdefb)", "amount": 4000},
  {"name": "Spotify", "color": "Color(0xff2196f3)", "amount": 300}
],
"income":65000,
"savings": 13876
}*/
Dio dio = Dio();

Future shareExpenseRequest() async {
  final List expenses = [];
  final income = await getIncomes();
  final savings = await getSavings();

  final expense = await getRecords("expenses");
  for (var element in expense.items) {
    expenses.addIf(
        !expenses.contains({
          "name": element.data['name'],
          "color": element.data['color'],
          "amount": element.data['amount'],
        }),
        {
          "name": element.data['name'],
          "color": element.data['color'],
          "amount": element.data['amount'],
        });
  }
  Map<String, dynamic> payload = {"income": income, "savings": savings};

  payload.addAll({"expense": expenses});
  print(payload);
  final results = await dio.post("$_baseUrl/shareExpense", data: payload);

  if (results.statusCode == 200) {
    // Get.find<GraphsController>().isOnline.value=true;
    saveFinancialStatus("expenses", results.data);
    return results.data;
  }
  print(results.data);
}

//getting the user days left and amount balance
Future<Map<String,dynamic>> getDailyExpenditure()async{
  final income = await getIncomes();
  final expenses = await getExpense();
  final savings = await getSavings();
  final balance = (income-expenses)-savings;
  //dates left in the month
  // Get current date
  DateTime now = DateTime.now();

  // Get the last day of the current month
  DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

  // Calculate the number of days left until the end of the month
  int daysLeft = endOfMonth.day - now.day;

  final results = await dio.post("$_baseUrl/dailyExpenditure",data:{
    "amountLeft":balance,
    "daysLeft": daysLeft
  });

  if(results.data!=null){
    // Get.find<GraphsController>().isOnline.value=true;
  }

  return results.data;
}

Future sendMessages(List body)async {
  String userID = await getUserID();
  final results= await dio.post("$_baseUrl/process_messages",data: {
    "messages":body,
    "userID":userID
  });
  // if(results.statusMessage=="OK"){
  //   gettingMessageResults(results.data['encrypted_result']);
  // }
  print(results.statusMessage);
  print(results.data);
  return results.data;
}

Future gettingMessageResults(String value)async{
  final result = await dio.post("$_baseUrl/share_encrypted_data",data: {
    "encrypted_data":value
  });
  return result.data;
}

Future <Map<String,dynamic>> calculateTransactions (Map<String,dynamic> data)async {
  final result = await dio.post("$_baseUrl/calculate",data: data);
  print(result.data);
  return result.data;
}