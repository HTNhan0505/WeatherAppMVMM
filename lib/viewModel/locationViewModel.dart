import 'package:get/get.dart';

class LocationViewModel extends GetxController {
  List<String> filterLocation = <String>[].obs;
  List<String> locationList = [
    'VietNam,Ho Chi Minh',
    'Seattle, Washington',
    'Fort Worth, Texas',
    'San Diego, California',
    'New York,US',
    'Multan,Pakistan',
    'San Antonio, Texas',
    'Barcelona',
    'Paris',
    'Seoul',
    'Daegu',
    'Gwangju',
    'Chicago, Illinois',
    'Phoenix, Arizona',
  ];

  @override
  void onReady() {
    filterLocation.addAll(locationList);
    print("Create Local");
    super.onReady();
  }
  @override
  void onCreate() {
    // print("Create");
    // super.onInit();
  }

  onSearchLocation(String value) {
    filterLocation.clear();
    filterLocation.addAll(
        locationList.where((element) =>
            element.toLowerCase().contains(value.toLowerCase())));
  }
  onSelectLocation(int index) {
    Get.back(result: filterLocation[index]);

  }
  onFindWeatherLocation(String location) {
    Get.back(result: location);
  }
}