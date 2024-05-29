import 'dart:convert';

import 'package:budgeting_module/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


int yellowIntColor = 0xffFFC100;
int greenIntColor = 0xff0D3224;
NumberFormat format = NumberFormat.decimalPattern('en_US');

String convertDate() {
  String month='${DateTime.now().month}';
  String year='${DateTime.now().year}'.substring(2);

  if(month.length.isLowerThan(2)){
    month = '0${DateTime.now().month}';
  }
  return "$month/$year";
}


Future saveFinancialStatus(String key, var payload) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final results = preferences.setString(key, jsonEncode(payload));
  print("-----$results");
}

Future<Map<String, dynamic>> getFinancialStatus(var key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? results = preferences.getString(key);
  print(results);
  return jsonDecode(results!);
}

Widget holder(String title, var value) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextWidget(
            text: title,
            color: greenIntColor,
            fontSize:
            title == "Total balance" || title == "Total Amount" ? 14 : 12,
            fontWeight: title == "Total balance" || title == "Total Amount"
                ? FontWeight.w500
                : FontWeight.w300,
            textAlign: TextAlign.start,
          ),
        ),
        TextWidget(
          text: value.toString(),
          color: value.toString() == "Success"? 0xff228B22 :value.toString().contains("Extremely high ~ ")?0xffFF0000:
          value.toString().contains("High ~ ")?0xffFF0000:
          value.toString().contains("Moderate ~ ")?yellowIntColor: greenIntColor,
          fontSize: title == "Total balance" || title == "Total Amount"
              ? 20
              : title == "Consuming rate"
              ? 12
              : value == "calculating...."
              ? 10
              : 12,
          fontWeight: title == "Total balance" || title == "Total Amount"
              ? FontWeight.w600
              : title == "Consuming rate" || value.toString() == "Success"
              ? FontWeight.w600
              : FontWeight.w400,
          textAlign: TextAlign.end,
        ),
      ],
    ),
  );
}