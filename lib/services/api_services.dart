import 'package:crona_finder/consts/string.dart';
import 'package:crona_finder/model/horly_weather_mode.dart';
import 'package:crona_finder/model/weather_data_model.dart';
import 'package:http/http.dart' as http;


getCurrentApi(lat,long) async {

var link ="https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";

  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = currentWetherDataFromJson(res.body.toString());
    print("data is Recived");
    return data;
  }
}

getHourlyApi(lat,long) async {
var link ="https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";

  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = hourlyWeatherDataFromJson(res.body.toString());
    print("hourly data is Recived");
    return data;
  }
}
