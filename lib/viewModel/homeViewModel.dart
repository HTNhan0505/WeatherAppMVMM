import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/model/weatherModel.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/screens/location/locationScreen.dart';

import '../components/getx_helper.dart';
import '../components/global_variables.dart';

class HomeViewModel extends GetxController {
  Rx<WeatherModel> weatherModel = WeatherModel().obs;
  RxString location = 'VietNam,Ho Chi Minh'.obs;
  RxString url = ''.obs;

  @override
  void onReady() {
    getLocationAndUpdate();
    print("Create Home");
    super.onStart();
  }

  void changeLocation() async {
    var result = await Get.to(() => LocationScreen());
    if (result != null) {
      location.value = result;
      GetStorage().write('lastLocation', location.value);
      getLocationAndUpdate();
    }
  }

  getLocationAndUpdate() {
    location.value = GetStorage().read('lastLocation') ?? 'VietNam,Ho Chi Minh';

    var data = GetStorage().read(location.value) ?? <String, dynamic>{};
    weatherModel.value = WeatherModel.fromJson(data);
    getWeatherUpdate();

  }

  getWeatherUpdate() async {
    try {
      //   Handle Header
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      //   Url
      String url = 'https://api.openweathermap.org/data/2.5/weather';
      Map<String, String> params = {
        'appid': 'b6e1f8abe0d86706d18b0053dcfbe133',
        'q': location.value,
        'units': 'metric'
      };
      Uri uriValue = Uri.parse(url).replace(queryParameters: params);
      GlobalVariables.showLoader.value = true;
      http.Response response = await http.get(uriValue, headers: header);
      Map<String, dynamic> parsedJson = jsonDecode(response.body);
      GlobalVariables.showLoader.value = false;

      if (parsedJson['cod'] == 200) {
        weatherModel.value = WeatherModel.fromJson(parsedJson);
        GetStorage().write(location.value, parsedJson);
        GetXHelper.showSnackBar(message: 'Success');
      } else {
        GetXHelper.showSnackBar(message: 'Failed');
      }
    } catch (e) {
      GetXHelper.showSnackBar(message: e.toString());
    }
  }

  String getDate() {
    String date = '';
    DateTime dateTime = DateTime.now();
    date = DateFormat("EEE | MMM dd").format(dateTime);

    return date;
  }

  String timeStamptoTime(int? timeStamp) {
    String time = 'N/A';
    if (timeStamp != null) {
      DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
      time = DateFormat("hh:mm a").format(dateTime);
    }
    return time;
  }
}
