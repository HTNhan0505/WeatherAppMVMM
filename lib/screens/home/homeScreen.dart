// import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:weather_app/viewModel/homeViewModel.dart';
import 'package:weather_app/widgets/loader_view.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeViewModel viewModel = Get.put(HomeViewModel());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xFF3C6FD1), Color(0xFF7CA9FF)],
          stops: [0.25, 0.87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    iconAndTemperature(),
                    divider(),
                    weatherValues(),
                  ],
                ),
              ),
            ),
            LoaderView()
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Obx(() => Text(viewModel.location.value)),
      actions: [
        IconButton(
          onPressed: () {
            viewModel.changeLocation();
          },
          icon: Icon(Icons.location_on_outlined),
        )
      ],
    );
  }

  Widget iconAndTemperature() {
    return Column(
      children: [
        weatherImage(),
        Text(
          viewModel.getDate(),
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        Wrap(
          children: [
            Obx(
              () => Text(
                (viewModel.weatherModel.value.main?.temp ?? 00)
                    .toStringAsFixed(0),
                style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              ' o',
              style: TextStyle(
                  color: Colors.white,
                  fontFeatures: [FontFeature.superscripts()]),
            )
          ],
        ),
        Obx(
          () => Text(
            viewModel.weatherModel.value.weather?.first.main ?? 'N/A',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget weatherImage() {
    return CachedNetworkImage(
      imageUrl:
          'https://openweathermap.org/img/wn/${viewModel.weatherModel.value.weather?.first.icon}@4x.png',
      height: 120,
      width: 120,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset('assets/images/clouds.png'),
        );
      },
      placeholder: (context, url) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget divider() {
    return Divider(height: 28);
  }

  Widget weatherValues() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                  title: 'Minimum',
                  value:
                      '${viewModel.weatherModel.value.main?.tempMin ?? 'N/A'}',
                  icon: CupertinoIcons.down_arrow,
                  unit: ''),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                  title: 'Maximum',
                  value:
                      '${viewModel.weatherModel.value.main?.tempMax ?? 'N/A'}',
                  icon: CupertinoIcons.up_arrow,
                  unit: ''),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                  title: 'Wind',
                  value: '${viewModel.weatherModel.value.wind?.speed ?? 'N/A'}',
                  icon: Icons.wind_power,
                  unit: 'm/s '),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                  title: 'Feel',
                  value:
                      '${viewModel.weatherModel.value.main?.feelsLike ?? 'N/A'}',
                  icon: Icons.cloudy_snowing,
                  unit: ''),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                  title: 'Pressure',
                  value:
                      '${viewModel.weatherModel.value.main?.pressure ?? 'N/A'}',
                  icon: Icons.thermostat,
                  unit: 'mbar'),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                  title: 'Humidity',
                  value:
                      '${viewModel.weatherModel.value.main?.humidity ?? 'N/A'}',
                  icon: Icons.water_drop_outlined,
                  unit: '%'),
            ),
          ],
        ),
        divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                  title: 'Sun Rise',
                  value: viewModel.timeStamptoTime(
                      viewModel.weatherModel.value.sys?.sunrise),
                  icon: Icons.sunny,
                  unit: ''),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                  title: 'Sun set',
                  value: viewModel.timeStamptoTime(
                      viewModel.weatherModel.value.sys?.sunset),
                  icon: Icons.sunny_snowing,
                  unit: ''),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                  title: 'Latitude',
                  value: '${viewModel.weatherModel.value.coord?.lat ?? 'N/A'}',
                  icon: Icons.location_on,
                  unit: ''),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                  title: 'Longitude',
                  value: '${viewModel.weatherModel.value.coord?.lon ?? 'N/A'}',
                  icon: Icons.location_on,
                  unit: ''),
            ),
          ],
        ),
      ],
    );
  }

  Widget detailItem(
      {required String title,
      required String value,
      required IconData icon,
      required String unit}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.17)),
        child: Row(
          children: [
            Icon(icon, size: 32),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value != 'N/A' ? '$value $unit' : value,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
