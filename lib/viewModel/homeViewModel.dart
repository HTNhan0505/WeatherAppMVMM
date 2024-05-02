import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/helper/getx_helper.dart';
import 'package:weather_app/helper/global_variables.dart';
import 'package:weather_app/model/weatherModel.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends GetxController {
  Rx<WeatherModel> weatherModel = WeatherModel().obs;
  RxString location = 'VietNam,Ho Chi Minh'.obs;

  @override
  void onReady() {
    super.onReady();
  }
  getLocationAndUpdate() {
    location.value = GetStorage().read('lastLocation') ?? 'VietNam,Ho Chi Minh';

    var data = GetStorage().read(location.value) ?? <String,dynamic>{};
    weatherModel.value = WeatherModel.fromJson(data);

    getWeatherUpdate();
  }

  getWeatherUpdate() async{
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
      http.Response response = await http.get(uriValue,headers: header);
      Map<String,dynamic> parsedJson = jsonDecode(response.body);
      GlobalVariables.showLoader.value = false;

      if(parsedJson['cod'] == 200) {
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
}
