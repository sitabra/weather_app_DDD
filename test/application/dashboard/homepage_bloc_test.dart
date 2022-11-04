import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:weather_ddd_app/application/dashboard/weather_bloc.dart';
import 'package:weather_ddd_app/domain/core/error/api_failures.dart';
import 'package:weather_ddd_app/domain/dashboard/entities/fetched_weather.dart';
import 'package:weather_ddd_app/domain/dashboard/value/value_objects.dart';
import 'package:weather_ddd_app/infrastructure/dashboard/repository/weather_repository.dart';

class WeatherRepoMock extends Mock implements WeatherRepository {}

void main() {
  final WeatherRepository weatherRepoMock = WeatherRepoMock();
  var weatherState = WeatherState.initial();
  group('Weather bloc', () {
    blocTest(
      'Try to get weather with empty city name',
      build: () => WeatherBloc(dashRepository: weatherRepoMock),
      setUp: () {
        weatherState = WeatherState.initial();
        when(() => weatherRepoMock.loadCity()).thenAnswer(
              (invocation) async => const Left(
            ApiFailure.other('initial'),
          ),
        );

        when(() => weatherRepoMock.weatherData(city: City(''))).thenAnswer((invocation) async =>
        const Left(ApiFailure.cityNotFound())
        );

      },
      act: (WeatherBloc bloc) => [
      bloc..add(const WeatherEvent.cityNameChanged('')),
      bloc..add(const WeatherEvent.searchOnButtonPress()),
      ],
      expect: () => [
        weatherState.copyWith(
          city: City(''),
          isSubmitting: false,
          showErrorMessages: false,
            authFailureOrSuccessOption: none()
        ),
        weatherState.copyWith(
            city: City(''),
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccessOption: optionOf(
              const Left(ApiFailure.cityNotFound()),
            )
        ),
      ],
    );


    blocTest(
      'Try to get weather with city name changed',
      build: () => WeatherBloc(dashRepository: weatherRepoMock),
      setUp: () {
        weatherState = WeatherState.initial();
        when(() => weatherRepoMock.loadCity()).thenAnswer(
              (invocation) async => const Left(
            ApiFailure.other('initial'),
          ),
        );

      },
      act: (WeatherBloc bloc) => [
      bloc..add(const WeatherEvent.cityNameChanged('kolkata')),
      ],
      expect: () => [
        weatherState.copyWith(
          city: City('kolkata'),
          isSubmitting: false,
          showErrorMessages: false,
            authFailureOrSuccessOption: none()
        ),
      ],
    );

    blocTest(
      'Try to get weather with correct city name and button pressed',
      build: () => WeatherBloc(dashRepository: weatherRepoMock),
      setUp: () {
        when(() => weatherRepoMock.weatherData(city: City('Kolkata'))).thenAnswer(
              (invocation) async => const Right(FetchedWeather(data: {})),
        );

      },
      act: (WeatherBloc bloc) => bloc
        ..add(const WeatherEvent.cityNameChanged('Kolkata'))
        ..add(const WeatherEvent.searchOnButtonPress()),
      expect: () => [
        weatherState.copyWith(
            city: City('Kolkata'),
            isSubmitting: false,
            showErrorMessages: false,
            authFailureOrSuccessOption: none()
        ),
        weatherState.copyWith(
            city: City('Kolkata'),
            isSubmitting: true,
            showErrorMessages: false,
            authFailureOrSuccessOption: none()
        ),
        weatherState.copyWith(
            city: City('Kolkata'),
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccessOption: optionOf(const Right(FetchedWeather(data: {})))
        ),
      ],
    );

    blocTest(
      'Try to get weather with incorrect city name and button pressed',
      build: () => WeatherBloc(dashRepository: weatherRepoMock),
      setUp: () {
        when(() => weatherRepoMock.weatherData(city: City('ksadjf'))).thenAnswer(
              (invocation) async => const Left(ApiFailure.cityNotFound()),
        );

      },
      act: (WeatherBloc bloc) => bloc
        ..add(const WeatherEvent.cityNameChanged('ksadjf'))
        ..add(const WeatherEvent.searchOnButtonPress()),
      expect: () => [
        weatherState.copyWith(
            city: City('ksadjf'),
            isSubmitting: false,
            showErrorMessages: false,
            authFailureOrSuccessOption: none()
        ),
        weatherState.copyWith(
            city: City('ksadjf'),
            isSubmitting: true,
            showErrorMessages: false,
            authFailureOrSuccessOption: none()
        ),
        weatherState.copyWith(
            city: City('ksadjf'),
            isSubmitting: false,
            showErrorMessages: true,
            authFailureOrSuccessOption: optionOf(const Left(ApiFailure.cityNotFound()))
        ),
      ],
    );
  });
}