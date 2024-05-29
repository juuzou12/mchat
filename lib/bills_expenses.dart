import 'package:budgeting_module/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneychat/python_apis.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'apis.dart';
import 'constants.dart';

class BillAndExpenditureBarGraph extends GetView <BillController>{

  late TooltipBehavior _tooltip;
  final List<ChartData> chartData = [
    ChartData('Daily spending', 2500),
    ChartData("Today's spending", 1000),
  ];


  @override
  Widget build(BuildContext context) {
    _tooltip = TooltipBehavior(enable: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          FutureBuilder(future: getRecords("expenses"),
            builder: (BuildContext context, AsyncSnapshot<ResultList<RecordModel>> snapshot) {
              if(snapshot.hasData){
                print(snapshot.data!.items[0].data);
                return pieChart(controller.data(snapshot.data!.items));
              }
              return FutureBuilder(
                future: getFinancialStatus("monthlyExpenses"),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> s) {
                  List<ChartData> d = [];
                  if (s.hasData) {
                    s.data!.forEach((key, value) {
                      d.addIf(
                          !d.contains(ChartData(
                              key, double.parse(value.toString()))),
                          ChartData(
                              key, double.parse(value.toString())));
                    });
                    return pieChart(d);
                  }
                  return pieChart([
                    ChartData('Loading...', 0),
                    ChartData("Loading...", 0),
                  ]);
                },
              );
            },),
          FutureBuilder(future: shareExpenseRequest(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              {
                                "key": "Remaining balance",
                                "value": snapshot.data['remaining_balance']
                              },
                              {
                                "key": "Total expenditure",
                                "value": snapshot.data['total_amount']
                              },
                              {
                                "key": "Total yearly spending",
                                "value": snapshot.data['total_yearly_spent']
                              },
                            ]
                                .map((e) => holder(e['key'].toString(),
                                    "KES: ${format.format(e['value'])}"))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: TextWidget(
                        text: "Recently Paid Expenses",
                        color: greenIntColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffFFFFFF))),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            child: Icon(
                              Icons.credit_card_rounded,
                              size: 20,
                            ),
                          ),
                          title: TextWidget(
                            text: "House Rent",
                            color: greenIntColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: "KES: 5,000.0",
                                  color: greenIntColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  textAlign: TextAlign.start,
                                ),
                                TextWidget(
                                  text: "MPESA SERVICES",
                                  color: greenIntColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xffFFFFFF))),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              child: Icon(
                                Icons.credit_card_rounded,
                                size: 20,
                              ),
                            ),
                            title: TextWidget(
                              text: "Netflix and Spotify",
                              color: greenIntColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    text: "KES: 700.0",
                                    color: greenIntColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    textAlign: TextAlign.start,
                                  ),
                                  TextWidget(
                                    text: "MPESA SERVICES",
                                    color: greenIntColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    comparing(snapshot.data['highest_expense'],snapshot.data['lowest_expense']),
                  ],
                );
              }
              return FutureBuilder(future: getFinancialStatus("expenses"),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  {
                                    "key": "Remaining balance",
                                    "value": snapshot.data!['remaining_balance']
                                  },
                                  {
                                    "key": "Total expenditure",
                                    "value": snapshot.data!['total_amount']
                                  },
                                  {
                                    "key": "Total yearly spending",
                                    "value": snapshot.data!['total_yearly_spent']
                                  },
                                ]
                                    .map((e) => holder(e['key'].toString(),
                                    "KES: ${format.format(e['value'])}"))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: TextWidget(
                            text: "Recently Paid Expenses",
                            color: greenIntColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xffFFFFFF))),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                child: Icon(
                                  Icons.credit_card_rounded,
                                  size: 20,
                                ),
                              ),
                              title: TextWidget(
                                text: "House Rent",
                                color: greenIntColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      text: "KES: 5,000.0",
                                      color: greenIntColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      textAlign: TextAlign.start,
                                    ),
                                    TextWidget(
                                      text: "MPESA SERVICES",
                                      color: greenIntColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xffFFFFFF))),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    Icons.credit_card_rounded,
                                    size: 20,
                                  ),
                                ),
                                title: TextWidget(
                                  text: "Netflix and Spotify",
                                  color: greenIntColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: "KES: 700.0",
                                        color: greenIntColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        textAlign: TextAlign.start,
                                      ),
                                      TextWidget(
                                        text: "MPESA SERVICES",
                                        color: greenIntColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        comparing(snapshot.data!['highest_expense'],snapshot.data!['lowest_expense']),
                      ],
                    );
                  }
                  return SizedBox();
                },);
            },)
        ],
      ),
    );
  }
  Widget pieChart(var d){
    return Container(
      width: Get.width-16,
      height: 350,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SfCircularChart(
          tooltipBehavior: _tooltip,
          title: ChartTitle(
              text: "Monthly Expenses & Bills",
              alignment: ChartAlignment.near,
              textStyle: GoogleFonts.getFont(
                  "Poppins",
                  fontSize: 11,
                  fontWeight: FontWeight.w500
              )
          ),
          legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom,
              itemPadding: 8),
          series: <CircularSeries<ChartData, String>>[
            DoughnutSeries<ChartData, String>(
                dataSource: d,
                radius: '80%',opacity: 0.6,
                legendIconType: LegendIconType.seriesType,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition:
                    ChartDataLabelPosition.outside,
                    connectorLineSettings:
                    ConnectorLineSettings()),
                innerRadius: '50%',
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                name: 'Gold')
          ]),
    );
  }
  Widget comparing(var valueOne, var valueTwo){
    final totalWidth = 330.0;
    final totalValue = valueOne['amount'] + valueTwo['amount'];
    return Padding(
      padding: const EdgeInsets.only(top:20.0,bottom: 20.0),
      child: Column(
        children: [
          Container(
            width: totalWidth,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100)
            ),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: (valueOne['amount']).roundToDouble()*totalWidth/totalValue,
                  decoration: BoxDecoration(
                      color: Color(yellowIntColor),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          topLeft: Radius.circular(100)
                      )
                  ),
                ),
                Container(
                  height: 20,
                  width: (valueTwo['amount']).roundToDouble()*totalWidth/totalValue,
                  decoration: BoxDecoration(
                      color: Color(greenIntColor),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(100),
                          topRight: Radius.circular(100)
                      )
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: "Highest expense",
                          color: greenIntColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          textAlign: TextAlign.start,
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Color(yellowIntColor),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: "${valueOne['name']}",
                            color: greenIntColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextWidget(
                          text: "KES: ${format.format(valueOne['amount'])}",
                          color: greenIntColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: "Lowest expense",
                          color: greenIntColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          textAlign: TextAlign.start,
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Color(greenIntColor),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: "${valueTwo['name']}",
                            color: greenIntColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextWidget(
                          text: "KES: ${format.format(valueTwo['amount'])}",
                          color: greenIntColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BillController {
  List<ChartData> data (List<RecordModel> expenseList){
    List<ChartData> d= [];
    Map<String,dynamic> offlineSaving={};
    d.clear();
    for (var element in expenseList) {
      d.add(ChartData(element.data['name'], double.parse(element.data['amount'].toString())));
      offlineSaving.addIf(!offlineSaving.containsKey(element.data['name']), element.data['name'], element.data['amount'].toString());
      print(d.length);
    }
    saveFinancialStatus("monthlyExpenses", offlineSaving);
    return d;
  }

}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
class ChartDataColor {
  ChartDataColor(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
