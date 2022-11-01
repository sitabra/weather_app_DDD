import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_ddd_app/application/dashboard/weather_bloc.dart';
import 'package:weather_ddd_app/domain/core/error/api_failures.dart';
import 'package:weather_ddd_app/domain/dashboard/entities/fetched_weather.dart';
import 'package:weather_ddd_app/domain/dashboard/entities/weather.dart';
import 'package:weather_ddd_app/presentation/dashboard/homepage.dart';

class WeatherFormBlocMock extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late WeatherBloc weatherBlocMock;

  group('Home Screen', () {
    setUp(() {
      weatherBlocMock = WeatherFormBlocMock();
      when(() => weatherBlocMock.state).thenReturn(WeatherState.initial());
    });

    testWidgets("Find by KEY", (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (context) => weatherBlocMock,
            ),
          ],
          child: const MaterialApp(home: Dashboard()),
        ),
      );
      // Create the Finders.
      final cityNameTextField = find.byKey(const Key('cityNameField'));
      final elevatedButton = find.byKey(const Key('elevatedButton'));
      final elevatedButtonText = find.text("Get Weather");
      final appTitle = find.byKey(const Key('weatherAppTitle'));
      expect(cityNameTextField, findsOneWidget);
      expect(elevatedButton, findsOneWidget);
      expect(elevatedButtonText, findsOneWidget);
      expect(appTitle, findsOneWidget);
    });

    testWidgets("Find by Type", (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (context) => weatherBlocMock,
            ),
          ],
          child: const MaterialApp(home: Dashboard()),
        ),
      );
      // Create the Finders.
      final sizedBox = find.byType(SizedBox);
      final scaffoldWidget = find.byType(Scaffold);
      final listView = find.byType(ListView);
      final searchIcon = find.byIcon(Icons.search);
      expect(sizedBox, findsNWidgets(6));
      expect(scaffoldWidget, findsNWidgets(1));
      expect(listView, findsNWidgets(1));
      expect(searchIcon, findsNWidgets(1));
    });

    testWidgets('Test weather when correct city name', (tester) async {
      final expectedStates = [
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Right(Weather(city: "Kolkata")),
          ),
          showErrorMessages: false,
        ),
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Right(FetchedWeather(data: {})),
          ),
          showErrorMessages: false,
        ),
      ];
      whenListen(weatherBlocMock, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (context) => weatherBlocMock,
            ),
          ],
          child: const MaterialApp(home: Dashboard()),
        ),
      );

      final errorMessage = find.byType(SnackBar);

      expect(errorMessage, findsNothing);
      await tester.pump();

      expect(errorMessage, findsNothing);
    });

    testWidgets('Test weather when wrong city name', (tester) async {
      final expectedStates = [
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Right(Weather(city: "msjfdgh")),
          ),
          showErrorMessages: true,
        ),
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Left(ApiFailure.other("Http status error [404]")),
          ),
          showErrorMessages: false,
        ),
      ];
      whenListen(weatherBlocMock, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (context) => weatherBlocMock,
            ),
          ],
          child: const MaterialApp(home: Dashboard()),
        ),
      );

      final errorMessage = find.byType(SnackBar);
      final errorText = find.text("Http status error [404]");

      expect(errorMessage, findsNothing);
      expect(errorText, findsNothing);

      await tester.pump();

      expect(errorMessage, findsOneWidget);
      expect(errorText, findsOneWidget);
    });


    testWidgets('Test weather when correct city name', (tester) async {
      final expectedStates = [
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Right(Weather(city: "Kolkata")),
          ),
          showErrorMessages: false,
        ),
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Right(FetchedWeather(data: {})),
          ),
          showErrorMessages: false,
        ),
      ];
      whenListen(weatherBlocMock, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (context) => weatherBlocMock,
            ),
          ],
          child: const MaterialApp(home: Dashboard()),
        ),
      );

      final errorMessage = find.byType(SnackBar);

      expect(errorMessage, findsNothing);
      await tester.pump();

      expect(errorMessage, findsNothing);
    });

    testWidgets('Test weather when empty city name', (tester) async {
      final expectedStates = [
        WeatherState.initial().copyWith(
          authFailureOrSuccessOption: optionOf(
            const Left(ApiFailure.cityNotFound()),
          ),
          showErrorMessages: true,
        ),
      ];
      whenListen(weatherBlocMock, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WeatherBloc>(
              create: (context) => weatherBlocMock,
            ),
          ],
          child: const MaterialApp(home: Dashboard()),
        ),
      );

      final errorMessage = find.byType(SnackBar);
      final errorText = find.text("City Not Found");

      expect(errorMessage, findsNothing);
      expect(errorText, findsNothing);

      await tester.pump();

      expect(errorMessage, findsOneWidget);
      expect(errorText, findsOneWidget);
    });
  });
}
