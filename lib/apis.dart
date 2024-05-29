import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_uuid/device_uuid.dart';

Future<String?> getPlatformIdentifier() async {
  String? deviceId = await DeviceUuid().getUUID();
  return deviceId;
}

String baseUrl = "https://moneychat.pockethost.io";
final pocketBase = PocketBase(baseUrl);

Future authApi(Map<String, dynamic> payload) async {
  final authData = await pocketBase.collection("users").create(body: payload);
  print(authData.id);
  saveUserID(authData.id);
}

Future addIncome(Map<String, dynamic> payload) async {
  String id = await getUserID();
  payload.addAll({"userID": id});
  final addIncome = await pocketBase.collection("income").create(body: payload);
  print(addIncome);
}

Future addExpense(Map<String, dynamic> payload) async {
  String id = await getUserID();
  payload.addAll({"userID": id});
  final addIncome =
      await pocketBase.collection("expenses").create(body: payload);
  print(addIncome);
}

Future addSavings(Map<String, dynamic> payload) async {
  String id = await getUserID();
  payload.addAll({"userID": id});
  final addIncome =
      await pocketBase.collection("savings").create(body: payload);
  print(addIncome);
}

Future addMobileMoney(Map<String, dynamic> payload) async {
  String id = await getUserID();
  final mobileMoney = await getRecords("mobileMoney");
  String? deviceId = await getPlatformIdentifier();
  payload.addAll({"userID": id, "deviceID": deviceId!});
  if (mobileMoney.items.isNotEmpty) {
    for (var element in mobileMoney.items) {
      if (element.data['deviceID'] == deviceId) {
        pocketBase
            .collection('mobileMoney')
            .update(element.id, body: payload)
            .then((value) => print("success"))
            .onError((error, stackTrace) => print("error---$error"));
      }
    }
  } else {
    pocketBase
        .collection("mobileMoney")
        .create(body: payload)
        .then((value) => print("success"))
        .onError((error, stackTrace) => print("error---$error"));
  }
}

Future addNewGoal(Map<String, dynamic> payload) async {
  String id = await getUserID();
  payload.addAll({"userID": id});
  final addIncome = await pocketBase.collection("goals").create(body: payload);
  print(addIncome);
}

Future addDailyRoutine(Map<String, dynamic> payload) async {
  final addIncome =
      await pocketBase.collection("dailyRoutines").create(body: payload);
  print(addIncome);
}

Future saveUserID(String userID) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("userID", userID);
}

Future<String> getUserID() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("userID")??"220zwr4ecrg2b9j".toString();
}

Future<ResultList<RecordModel>> getRecords(String v) async {
  String userID = await getUserID();
  final record = await pocketBase.collection(v).getList(
        filter: 'userID = "$userID"',
      );
  return record;
}
