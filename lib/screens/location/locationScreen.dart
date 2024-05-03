import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/viewModel/locationViewModel.dart';
import 'package:weather_app/widgets/custom_textfields.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final LocationViewModel viewModel = Get.put(LocationViewModel());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locations')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            CustomTextField(
              hint: 'Search Location...',
              prefixIcon: Icons.location_on,
              onChanged: (value) {
                viewModel.onSearchLocation(value);
              },
              controller: _textEditingController,
              onPressed: (value) {

                 viewModel.onFindWeatherLocation(value);
              },
            ),
            divider(),

            Text(
              'Recommend City',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),

            ),
            divider(),

            Expanded(
              child: Obx(
                      () =>
                  viewModel.filterLocation.isNotEmpty ?
                  ListView.separated(
                      itemBuilder: (context, index) {
                        return listViewItem(index);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: viewModel.filterLocation.length) : Center(
                    child:Text('No location found'),)
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listViewItem(int index) {
    return ListTile(
      tileColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
         viewModel.onSelectLocation(index);

      },
      leading: Icon(
        Icons.location_on,
        color: Colors.white,
        size: 22,
      ),
      title: Text(
        viewModel.filterLocation[index],
        style: TextStyle(color: Colors.white),
      ),
    );
  }
  Widget divider() {
    return Divider(height: 28);
  }
}
