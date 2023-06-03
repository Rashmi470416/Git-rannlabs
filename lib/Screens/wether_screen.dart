import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/color_cons.dart';
import '../models/whether_res.dart';
import '../utils/sizes.dart';

class WeatherScreen extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
      final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cBgColor,
        title:const  Text('Rannlab App'),
      ),
      body: Padding(
        padding:const  EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: _formKey,
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Enter Location',
                ),
                validator: (v) {
                if (v!.isEmpty) {
                  return "Please enter Location";
                } else {
                  return null;
                }
              },
              ),
              
              vGap(40),
              ElevatedButton(
                onPressed: () {
                weatherProvider.fetchWeatherData(locationController.text);
                },
                style: ElevatedButton.styleFrom(
                fixedSize: const Size(500,45),
                  backgroundColor: cYellowColor2,
                  textStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                child:const Text('Get Weather'),
              ),
               
               vGap(16),
              if (weatherProvider.isLoading)
                const Padding(
                  padding:  EdgeInsets.all(38.0),
                  child:  CircularProgressIndicator(
                    color: cYellowColor2,
                  ),
                )
              else if (weatherProvider.hasError)
                Text(
                  'An error occurred: ${weatherProvider.errorMessage}',
                  style: const TextStyle(color: cRedColor),
                )
              else if (weatherProvider.weatherData != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Temperature: ${weatherProvider.weatherData?.main?.temp}°C'),
                    Text('Humidity: ${weatherProvider.weatherData?.main?.humidity}%'),
                    Text('Clouds: ${weatherProvider.weatherData?.clouds }'),
                    Text('Weather: ${weatherProvider.weatherData?.weather }'),
                    Text('Rain: ${weatherProvider.weatherData?.rain }'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}



class WeatherProvider with ChangeNotifier {
  WeatherData? _weatherData;
  bool _isLoading = false;
  bool _hasError = false;
  String ?_errorMessage;

  WeatherData ?get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

Future<void> fetchWeatherData(String location) async {
  try {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    //Here i set default API_KEY But it is not correct we should provide the API_KEY acccording to the API URL ....
    // if you provide the api it should easy for me
    // and also i call API FROM OpenWeatherMap
    final  apiKey = ' 95e9d59d43445dfb5954e71cbc9ed84f';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';

    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final weatherJson = jsonDecode(response.data);
      _weatherData = WeatherData.fromJson(weatherJson);
    } else {
      _hasError = true;
      _errorMessage = 'Failed to fetch weather data';
    }
  } catch (error) {
    _hasError = true;
    _errorMessage = 'An error occurred: $error';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}

// https://docs.google.com/document/d/1NT25fs1LypR5IdKcOAzOBVSgpQBsT8Bze_NsUW2IQ9M/edit