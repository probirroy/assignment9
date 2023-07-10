import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const apiKey = '4e7e12104089e40237206f1c39f1ba50';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool isLoading = false;
  bool fetchingError = true;
  String location = 'Your location';
  String temperature = 'N/A';
  String weatherDescription = 'N/A';
  String max = "N/A";
  String min = "N/A";
  Image weatherIcon = Image.network("https://www.noaa.gov/weather");

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  Future<void> getWeather() async {
    isLoading = true;
    fetchingError = false;
    setState(() {});
    var url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=Dhaka&units=metric&appid=$apiKey");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      location = jsonData['name'];
      temperature = jsonData['main']['temp'].toString();
      min = jsonData['main']['temp_min'].toString();
      max = jsonData['main']['temp_max'].toString();

      weatherDescription = jsonData['weather'][0]['description'];
      weatherIcon = Image.network(
        'https://openweathermap.org/img/wn/${jsonData['weather'][0]['icon']}.png',
      );
      setState(() {});
    } else {
      temperature = 'N/A';
      weatherDescription = 'N/A';
      weatherIcon = Image.network("https://www.noaa.gov/weather",);
      setState(() {});
    }
    isLoading = false;
    fetchingError = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
        ),
        centerTitle: true,
        elevation: 20,
        backgroundColor: Colors.black12,
        actions: [
          IconButton(
            onPressed: () {
              getWeather();
            },
            icon: const Icon(
              Icons.refresh,
              size: 32,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : fetchingError
          ? const Center(
        child:
        Text("There is a error in fetching the data from api!"),
      )
          : Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffb0dff6),
              Color(0xffb0dff6),
              Color(0xffb0dff6),
              Color(0xffb0dff6),
              Color(0xfff7f9fa),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                location,
                style: GoogleFonts.acme(fontSize: 45),
              ),

              Text(
                "Updated: ${DateTime.now().hour}:${DateTime.now().minute}",
                style: const TextStyle(fontSize: 16),
              ), // create a new DateTime instance with current time only

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  weatherIcon,
                  const SizedBox(
                    width: 50,
                  ),
                  Text(
                    "$temperature °C",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      Text("$max °C"),
                      Text("$min °C"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                weatherDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
