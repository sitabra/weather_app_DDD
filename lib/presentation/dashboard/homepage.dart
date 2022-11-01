import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_ddd_app/application/dashboard/weather_bloc.dart';
import 'package:weather_ddd_app/domain/core/error/api_failures.dart';
import 'package:weather_ddd_app/domain/dashboard/entities/fetched_weather.dart';
import 'package:weather_ddd_app/presentation/core/snackbar.dart';

var weatherData = {};

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
          listener: (context, state) {
            state.authFailureOrSuccessOption.fold(
                  () {},
                  (either) => either.fold(
                    (failure) {
                  final failureMessage = failure.failureMessage;
                  showSnackBar(
                    context: context,
                    message: failureMessage,
                  );
                },
                    (_) {
                  context.read<WeatherBloc>().add(const WeatherEvent.authCheck());
                },
              ),
            );
          },
          builder: (context, state) {
            FetchedWeather data;
            state.authFailureOrSuccessOption.fold(() {
              data = const FetchedWeather(data: {});
            }, (a) {
              data = a.getOrElse(() => const FetchedWeather(data: {}));
              weatherData = data.data;
              if (kDebugMode) {
                print("Response data:-                 ${data.data.toString()}");
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
                      child: Text(
                        "Weather App",
                        key: const Key('weatherAppTitle'),
                        style: TextStyle(color: Colors.grey.shade900,fontSize: 30),),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const ChangeCity(),
                  const SizedBox(
                    height: 40,
                  ),
                  Card(
                    child: Text(
                      weatherData.containsKey("name")
                          ? "Weather at ${weatherData["name"]}"
                          : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: weatherData == {}
                              ? Colors.red
                              : Colors.grey.shade700,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
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
                                      weatherData.containsKey("main")
                                          ? "${weatherData["main"]["temp"]}°C"
                                          : "N/A",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: weatherData == {}
                                              ? Colors.red
                                              : Colors.grey.shade300,
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
                                              weatherData.containsKey("main")
                                                  ? "${weatherData["main"]["feels_like"]}°C"
                                                  : "N/A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: weatherData == {}
                                                      ? Colors.red
                                                      : Colors.grey.shade700,
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
                                              weatherData.containsKey("main")
                                                  ? "${weatherData["main"]["temp_min"]}°C"
                                                  : "N/A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: weatherData == {}
                                                      ? Colors.red
                                                      : Colors.grey.shade700,
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
                                              weatherData.containsKey("main")
                                                  ? "${weatherData["main"]["temp_max"]}°C"
                                                  : "N/A",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: weatherData == {}
                                                      ? Colors.red
                                                      : Colors.grey.shade700,
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
                                            weatherData.containsKey("main")
                                                ? "${weatherData["main"]["pressure"]} millibars "
                                                : "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: weatherData == {}
                                                    ? Colors.red
                                                    : Colors.grey.shade700,
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
                                            weatherData.containsKey("main")
                                                ? "${weatherData["main"]["humidity"]} % "
                                                : "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: weatherData == {}
                                                    ? Colors.red
                                                    : Colors.grey.shade700,
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
                                            weatherData.containsKey("main")
                                                ? "${weatherData["wind"]["speed"]} m/sec "
                                                : "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: weatherData == {}
                                                    ? Colors.red
                                                    : Colors.grey.shade700,
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
                                      weatherData.containsKey("visibility")
                                          ? "${weatherData["visibility"]} m"
                                          : "N/A",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: weatherData == {}
                                              ? Colors.red
                                              : Colors.grey.shade700,
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
                          height: 50,
                          child: TextFormField(
                            key: const Key('cityNameField'),
                            cursorHeight: 18,
                            style: const TextStyle(color: Colors.black,fontSize: 18,height: 0),
                            onChanged: (v) {
                              context
                                  .read<WeatherBloc>()
                                  .add(WeatherEvent.cityNameChanged(v));
                            },
                            validator: (_) =>
                                context.read<WeatherBloc>().state.city.value.fold(
                                      (f) => f.maybeMap(
                                    empty: (_) => 'City name cannot be empty.',
                                    orElse: () => null,
                                  ),
                                      (_) => null,
                                ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              label: Text(
                                "Search city",
                                style: TextStyle(color: Colors.grey.shade700,fontSize: 16),
                              ),
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
                    key: const Key("elevatedButton"),
                    child: const Text('Get Weather'),
                    onPressed: () {
                      weatherData = {};
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