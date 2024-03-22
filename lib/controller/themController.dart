import 'package:crona_finder/model/horly_weather_mode.dart';
import 'package:crona_finder/model/weather_data_model.dart';
import 'package:crona_finder/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    getUserLocation();
    getCurrentApi(latitude.value, longitude.value);
    getHourlyApi(latitude.value, longitude.value);

    super.onInit();
    // update();
  }

  var isDark = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  // dynamic weathercurrentdata;
  // dynamic hourlyWeatherData;
  var isloading = false.obs;

  changethem() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
  }

  getUserLocation() async {
    var isLocationEnable;
    var userPermission;
    isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnable) {
      return Future.error("Location is not Enable");
    }
    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever) {
      return Future.error("Location is denied Forever");
    } else if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();

      if (userPermission == LocationPermission.denied)
        return Future.error("Permission is denied");
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      isloading.value = true;
    });
  }
}
