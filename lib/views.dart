import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crona_finder/consts/image.dart';
import 'package:crona_finder/consts/string.dart';
import 'package:crona_finder/controller/themController.dart';
import 'package:crona_finder/model/horly_weather_mode.dart';
import 'package:crona_finder/model/weather_data_model.dart';
import 'package:crona_finder/services/api_services.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
// import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:intl/intl.dart';

class View extends StatelessWidget {
  const View({super.key});

  @override
  Widget build(BuildContext context) {
    var date = DateFormat('yMMMMd').format(DateTime.now());

    var controller = Get.put(MainController());
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    const colorizeTextStyle = TextStyle(
        fontSize: 40.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          date,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: controller.isDark.value ? Colors.white : Colors.grey[500]),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.changethem();
              },
              icon: Icon(
                  controller.isDark.value ? Icons.light_mode : Icons.dark_mode),
              color: controller.isDark.value ? Colors.white : Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            color: controller.isDark.value ? Colors.black : Colors.grey[500],
          )
        ],
      ),
      body: Obx(() => controller.isloading.value == true
          ? Container(
              padding: const EdgeInsets.all(12.0),
              child: FutureBuilder(
                future: getCurrentApi(latitude, longitude),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    CurrentWetherData data = snapshot.data;
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText('${data.name}',
                                  textStyle: colorizeTextStyle),
                              ColorizeAnimatedText(
                                '${data.name}',
                                textStyle: colorizeTextStyle,
                                colors: colorizeColors,
                              ),
                            ],
                            isRepeatingAnimation: true,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/weather/${data.weather![0].icon}.png",
                                width: 80,
                                height: 80,
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: " ${data.main!.temp}",
                                    style: TextStyle(
                                        color: controller.isDark.value
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                        fontFamily: ('poppin'),
                                        fontSize: 64)),
                                TextSpan(
                                    text: "${data.weather![0].main}",
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontFamily: ('poppin_light'),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))
                              ]))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.expand_less_rounded,
                                    color: Colors.grey[400],
                                  ),
                                  label: Text("${data.main!.tempMax}$degree")),
                              TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.expand_more_rounded,
                                    color: Colors.grey[400],
                                  ),
                                  label: Text("${data.main!.tempMin} $degree"))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(3, (index) {
                                  var iconlist = [clouds, humidity, windspeed];
                                  var value = [
                                    "${data.clouds!.all}",
                                    "${data.main!.humidity}",
                                    "${data.wind!.speed} km/h"
                                  ];
                                  return Column(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      Image.asset(
                                        iconlist[index],
                                        width: 60,
                                        height: 60,
                                      ),
                                      Text(value[index])
                                    ],
                                  );
                                })),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          FutureBuilder(
                            future: getHourlyApi(latitude, longitude),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                HourlyWeatherData hourlydata = snapshot.data;
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: hourlydata.list!.length > 6
                                        ? 6
                                        : hourlydata.list!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      var time = DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              hourlydata.list![index].dt!
                                                      .toInt() *
                                                  1000));
                                      return Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          children: [
                                            Text(
                                              time,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Image.asset(
                                              "assets/weather/${hourlydata.list![index].weather![0].icon}.png",
                                              width: 80,
                                            ),
                                            Text(
                                              "${hourlydata.list![index].main!.temp}$degree",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Next 7 days",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 21),
                              ),
                              TextButton(
                                  onPressed: () {}, child: Text("View_All")),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FutureBuilder(
                            future: getHourlyApi(latitude, longitude),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                HourlyWeatherData fivedatw = snapshot.data;
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  itemBuilder: (context, index) {
                                    var days = DateFormat('EEEE').format(
                                        DateTime.now()
                                            .add(Duration(days: index + 1)));
                                    return Card(
                                      shadowColor:
                                          Color.fromARGB(255, 13, 9, 244),
                                      child: Container(
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 74, 56, 54),
                                              blurRadius: 5,
                                              offset: Offset(1, 75))
                                        ]),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                days,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Image.asset(
                                                    'assets/weather/${fivedatw.list![index].weather![0].icon}.png',
                                                    width: 40,
                                                  ),
                                                  label: Text(
                                                      "${fivedatw.list![index].main!.temp}$degree")),
                                            ),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      '${fivedatw.list![index].main!.tempMax}$degree/',
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 16)),
                                              TextSpan(
                                                  text:
                                                      '${fivedatw.list![index].main!.tempMin}$degree',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16))
                                            ]))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              ;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ))
          : const Center(
              child: CircularProgressIndicator(),
            )),
    );
  }
}
