import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:budgeting_module/daily_expenditure_graphs.dart';
import 'package:budgeting_module/financial_status_pie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:moneychat/python_apis.dart';
import 'package:more_module/more_page.dart';
import 'constants.dart';
import 'bills_expenses.dart';
import 'text_widget.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(BillController());
    return GetMaterialApp(
      title: 'MoneyChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Color(0xffF1F1f1),
        body: EntryPoint(),
      ),
    );
  }
}

class EntryPoint extends GetView {
  RxInt topSectionCurrentValue = 0.obs;
  List bottomNavItems = [
    {"name": "Dashboard", "icon": "assets/dashboard.png", "index": 0},
    {"name": "Expenses", "icon": "assets/bills.png", "index": 1},
    {"name": "Targets", "icon": "assets/savings.png", "index": 2},
    {"name": "More", "icon": "assets/more.png", "index": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1f1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => displayMain()),
      ),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 15.0),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                          children: bottomNavItems.map((e) {
                        return Expanded(
                            child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    topSectionCurrentValue.value == e['index']
                                        ? Color(yellowIntColor).withOpacity(0.6)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    e['icon'],
                                    width: 25,
                                    height: 25,
                                  ),
                                  TextWidget(
                                    text: "${e['name']}",
                                    color: greenIntColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            bottomNavFunction(e['index']);
                            // controller.isOnline.value=false;
                          },
                        ));
                      }).toList()),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(greenIntColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void bottomNavFunction(index) {
    switch (index) {
      default:
        topSectionCurrentValue.value = index as int;
        break;
    }
  }

  Widget displayMain() {
    switch (topSectionCurrentValue.value) {
      case 0:
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FinancialStatusPieChart(),
            ),
            DailyExpenditureBarGraph(),
            // InkWell(
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 8.0,top: 8.0),
            //     child: Container(
            //       height: 50,
            //       width: Get.width,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         border: Border.all(color: Color(yellowIntColor)),
            //         color: Color(yellowIntColor),
            //       ),
            //       child: Center(
            //         child: TextWidget(
            //           text: "Sync Message",
            //           color: greenIntColor,
            //           fontSize: 15,
            //           fontWeight: FontWeight.w500,
            //           textAlign: TextAlign.start,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: ()async{
            //     // getMessage();
            //     SmsQuery query = SmsQuery();
            //     int index = 0 ;
            //     List<SmsMessage> messages = await query.getAllSms;
            //     for (var element in messages) {
            //       if(element.address!.toUpperCase()=="EQUITY BANK"&&!moneyMsg.contains(element.body)){
            //         index +=1;
            //         moneyMsg.add(element.body);
            //       }
            //       if(element.address!.toUpperCase()=="MPESA"&&!moneyMsg.contains(element.body)){
            //         index +=1;
            //         moneyMsg.add(element.body);
            //       }
            //     }
            //     if (index == moneyMsg.length) {
            //       sendMessages(moneyMsg).then((value){
            //         Get.showSnackbar(GetSnackBar(
            //           title: "Message Syncing",
            //           message: "Successfully synced your message.",
            //           backgroundColor: Color(greenIntColor),
            //           snackStyle: SnackStyle.GROUNDED,
            //         ));
            //       }).onError((error, stackTrace){
            //         print(error);
            //       });
            //     }
            //   },
            // ),
          ],
        );
      case 1:
        return BillAndExpenditureBarGraph();
      case 3:
        return MorePage();
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FinancialStatusPieChart(),
        ),
        DailyExpenditureBarGraph(),
      ],
    );
  }

  List moneyMsg = [];
  Future getMessage()async {
    SmsQuery query = SmsQuery();
    int index = 0 ;
    List<SmsMessage> messages = await query.getAllSms;
    for (var element in messages) {
      if(element.address!.toUpperCase()=="EQUITY BANK"&&!moneyMsg.contains(element.body)){
        index +=1;
        moneyMsg.add(element.body);
      }
      if(element.address!.toUpperCase()=="MPESA"&&!moneyMsg.contains(element.body)){
        index +=1;
        moneyMsg.add(element.body);
      }
    }
    if (index == moneyMsg.length) {

      sendMessages(moneyMsg).then((value){
        Get.showSnackbar(GetSnackBar(
          title: "Message Syncing",
          message: "Successfully synced your message.",
          backgroundColor: Color(greenIntColor),
          snackStyle: SnackStyle.GROUNDED,
        ));
        print("--success--:$value");
      }).onError((error, stackTrace){
        print("--error:$error");
      });
    }
  }
}


