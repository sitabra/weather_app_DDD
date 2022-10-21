import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_ddd_app/application/dashboard/weather_bloc.dart';
import 'package:weather_ddd_app/domain/dashboard/entities/fetched_weather.dart';

var weatherData;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<WeatherBloc, WeatherState>(
          listenWhen: (previous, current) =>
              previous.authFailureOrSuccessOption !=
              current.authFailureOrSuccessOption,
          listener: (context, state) {},
          builder: (context, state) {
            FetchedWeather data;
            state.authFailureOrSuccessOption.fold(() {
              data = const FetchedWeather(data: {});
            }, (a) {
              data = a.getOrElse(() => const FetchedWeather(data: {}));
              weatherData = data.data;
              if (kDebugMode) {
                print("here 2          - ${data.data.toString()}");
              }
            });
            return Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/search(2).jpg"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Weather App", style: TextStyle(color: Colors.grey.shade900,fontSize: 30),),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const ChangeCity(),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    weatherData != null
                        ? "Weather at ${weatherData["name"]}"
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: weatherData != null
                            ? Colors.grey.shade700
                            : Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: ListView(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 1.7,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.32),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/images/splash.png",
                                height: 80,
                              ),
                              Expanded(
                                child: Text(
                                  weatherData != null
                                      ? "${weatherData["main"]["temp"]}°C"
                                      : "N/A",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: weatherData != null
                                          ? Colors.grey.shade300
                                          : Colors.red,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                    const FittedBox(
                                        child: Text(
                                      "Feels Like : ",style: TextStyle(fontSize: 18),
                                    )),
                                    Text(
                                      weatherData != null
                                          ? "${weatherData["main"]["feels_like"]}°C"
                                          : "N/A",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: weatherData != null
                                              ? Colors.grey.shade700
                                              : Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    )
                                  ]),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.32),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, right: 8, top: 8,bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Card(
                                    elevation: 0,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2.5,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(children: [
                                        const FittedBox(
                                            child: Text(
                                          "Min Temp : ",
                                        )),
                                        Expanded(
                                          child: FittedBox(
                                            child: Text(
                                              weatherData != null
                                                  ? "${weatherData["main"]["temp_min"]}°C"
                                                  : "N/A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: weatherData != null
                                                      ? Colors.blue
                                                      : Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                  Card(
                                    elevation: 0,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2.5,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(children: [
                                        const FittedBox(
                                            child: Text(
                                          "Max Temp : ",
                                        )),
                                        Expanded(
                                          child: FittedBox(
                                            child: Text(
                                              weatherData != null
                                                  ? "${weatherData["main"]["temp_max"]}°C"
                                                  : "N/A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: weatherData != null
                                                      ? Colors.blue
                                                      : Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.32),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Card(
                                    child: Container(
                                      height: MediaQuery.of(context).size.width / 7,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        const FittedBox(
                                            child: Text(
                                          "Pressure : ",
                                        )),
                                        Expanded(
                                          child: Text(
                                            weatherData != null
                                                ? "${weatherData["main"]["pressure"]} millibars "
                                                : "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: weatherData != null
                                                    ? Colors.blue
                                                    : Colors.red,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                  Card(
                                    child: Container(
                                      height: MediaQuery.of(context).size.width / 7,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        const FittedBox(
                                            child: Text(
                                          "Humidity : ",
                                        )),
                                        Expanded(
                                          child: Text(
                                            weatherData != null
                                                ? "${weatherData["main"]["humidity"]} % "
                                                : "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: weatherData != null
                                                    ? Colors.blue
                                                    : Colors.red,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                  Card(
                                    child: Container(
                                      height: MediaQuery.of(context).size.width / 7,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        const FittedBox(
                                            child: Text(
                                              "Wind : ",
                                            )),
                                        Expanded(
                                          child: Text(
                                            weatherData != null
                                                ? "${weatherData["wind"]["speed"]} m/sec "
                                                : "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: weatherData != null
                                                    ? Colors.blue
                                                    : Colors.red,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const FittedBox(
                                        child: Text(
                                          "Visibility : ",style: TextStyle(fontSize: 18),
                                        )),
                                    Text(
                                      weatherData != null
                                          ? "${weatherData["visibility"]} m"
                                          : "N/A",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: weatherData != null
                                              ? Colors.grey.shade700
                                              : Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChangeCity extends StatefulWidget {
  const ChangeCity({Key? key}) : super(key: key);

  @override
  State<ChangeCity> createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
        listenWhen: (previous, current) =>
            previous.authFailureOrSuccessOption !=
            current.authFailureOrSuccessOption,
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            previous.showErrorMessages != current.showErrorMessages,
        builder: (context, state) {
          return SafeArea(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.only(right: 10, left: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        onChanged: (v) {
                          context
                              .read<WeatherBloc>()
                              .add(WeatherEvent.cityNameChanged(v));
                        },
                        decoration: InputDecoration(
                          label: Text(
                            "Search city",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          hintText: "Search",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade700,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Get Weather'),
                onPressed: () {
                  weatherData = null;
                  context
                      .read<WeatherBloc>()
                      .add(const WeatherEvent.searchOnButtonPress());
                },
              ),
            ],
          ));
        });
  }
}
