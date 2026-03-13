import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {

  double? temperature;
  double? windspeed;
  bool loading = true;

  //เมือง + พิกัด
  final Map<String, Map<String, double>> cities = {
    "Chiang Mai": {"lat": 18.79, "lon": 98.98},
    "Bangkok": {"lat": 13.75, "lon": 100.50},
    "Phuket": {"lat": 7.88, "lon": 98.39},
    "Khon Kaen": {"lat": 16.44, "lon": 102.83},
  };

  String selectedCity = "Chiang Mai";

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(); // ⭐ icon หมุนตลอด

    fetchWeather();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Fetch API
  Future<void> fetchWeather() async {

    setState(() => loading = true);

    final lat = cities[selectedCity]!["lat"];
    final lon = cities[selectedCity]!["lon"];

    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        temperature = data['current_weather']['temperature'];
        windspeed = data['current_weather']['windspeed'];
        loading = false;
      });
    }
  }

  // ⭐ icon ตามอุณหภูมิ
  IconData getWeatherIcon() {
    if (temperature == null) return Icons.help;
    if (temperature! > 32) return Icons.wb_sunny;
    if (temperature! > 25) return Icons.wb_cloudy;
    if (temperature! > 18) return Icons.cloud;
    return Icons.ac_unit;
  }

  // ⭐ gradient
  List<Color> getGradient() {
    if (temperature == null) return [Colors.blueGrey, Colors.grey];
    if (temperature! > 32) return [Colors.orange, Colors.red];
    if (temperature! > 25) return [Colors.blue, Colors.lightBlueAccent];
    return [Colors.indigo, Colors.blueGrey];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather API Demo")),

      body: RefreshIndicator(
        onRefresh: fetchWeather,

        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: getGradient(),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: ListView(
            children: [

              const SizedBox(height: 30),

              // ⭐ Dropdown เมือง
              Center(
                child: DropdownButton<String>(
                  value: selectedCity,
                  dropdownColor: Colors.white,
                  items: cities.keys.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value!;
                    });
                    fetchWeather();
                  },
                ),
              ),

              const SizedBox(height: 80),

              Center(
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              // ⭐ Animated Icon
                              RotationTransition(
                                turns: controller,
                                child: Icon(
                                  getWeatherIcon(),
                                  size: 70,
                                  color: Colors.orange,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "$temperature °C",
                                style: const TextStyle(fontSize: 34),
                              ),

                              Text("Wind: $windspeed km/h"),

                              const SizedBox(height: 10),
                              const Text("Pull down to refresh")
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//////////////////////////////////////////////////////////////
// HOURLY PAGE
//////////////////////////////////////////////////////////////

class HourlyPage extends StatefulWidget {
  const HourlyPage({super.key});

  @override
  State<HourlyPage> createState() => _HourlyPageState();
}

class _HourlyPageState extends State<HourlyPage> {

  List temps = [];
  List humidity = [];
  List wind = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHourly();
  }

  Future<void> fetchHourly() async {

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=18.79&longitude=98.98&past_days=1&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      setState(() {
        temps = data['hourly']['temperature_2m'];
        humidity = data['hourly']['relative_humidity_2m'];
        wind = data['hourly']['wind_speed_10m'];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hourly Weather")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: temps.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text("Temp: ${temps[i]} °C"),
                  subtitle: Text(
                      "Humidity: ${humidity[i]}% | Wind: ${wind[i]} km/h"),
                );
              },
            ),
    );
  }
}
