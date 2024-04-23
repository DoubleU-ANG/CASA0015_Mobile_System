import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

const APIKEY = '*******************'; //use your own APIkey

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<HomePage> {
  Position? _currentlocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAdress = "";
  double latitude = 0;
  double longitude = 0;

  double temperature = 0;
  double humidity = 0;
  String rain_rate = '';
  double temperature1 = 0;
  double temperature2 = 0;
  int t1 = 0;
  int t2 = 0;
  late List<Widget> feeds;
  String data1 = '';
  String data2 = '';
  String data3 = '';
  String data4 = '';
  String data5 = '';
  var icon_url = "";
  var weatherType = "";
  int currentindex = 0;

  void getData() async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=55&lon=-0.01&appid=$APIKEY");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;

      var decodeData = jsonDecode(data);

      temperature1 = decodeData['main']['temp_min'];
      temperature2 = decodeData['main']['temp_max'];
      weatherType = decodeData["weather"][0]['main'];
      icon_url =
          "http://openweathermap.org/img/w/${decodeData["weather"][0]['icon']}.png";
      setState(() {
        t1 = temperature1.toInt() - 273;
        t2 = temperature2.toInt() - 273;
      });
      String cityName = decodeData['name'];
      print(temperature1 - 273.15);
      print(temperature2 - 273.15);
      print(t1);
      print(t2);
      print(weatherType);
      print(cityName);
    } else {
      print(response.statusCode);
    }
  }

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    _currentlocation = await Geolocator.getCurrentPosition();
    print('$_currentlocation');
    latitude = _currentlocation!.latitude;
    longitude = _currentlocation!.longitude;

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    feeds = [];
    startMQTT();
    _getCurrentLocation();
    getData();
  }

  updateList(String s) {
    setState(() {
      feeds.add(Text(s));
      if (currentindex == 0) {
        rain_rate = data3;
      } else if (currentindex == 1) {
        rain_rate = data4;
      } else if (currentindex == 2) {
        rain_rate = data5;
      }
    });
  }

  Future<void> startMQTT() async {
    final client = MqttServerClient('mqtt.*******.org', '');//use your own mqtt server here
    client.port = 1884;
    client.setProtocolV311();
    client.keepAlivePeriod = 30;
    final String username = '*******';//use your own username and password here
    final String password = '*******';
    try {
      await client.connect(username, password);
    } catch (e) {
      print('client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    const topic1 = 'student/CASA0014/plant/ucfnaaf/temperature';
    const topic2 = 'student/CASA0014/plant/ucfnaaf/humidity';
    const topic3 = 'student/CASA0014/plant/ucfnaaf/rainrate1';
    const topic4 = 'student/CASA0014/plant/ucfnaaf/rainrate2';
    const topic5 = 'student/CASA0014/plant/ucfnaaf/rainrate3';
    client.subscribe(topic1, MqttQos.atLeastOnce);
    client.subscribe(topic2, MqttQos.atLeastOnce);
    client.subscribe(topic3, MqttQos.atLeastOnce);
    client.subscribe(topic4, MqttQos.atLeastOnce);
    client.subscribe(topic5, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final receivedMessage = c![0].payload as MqttPublishMessage;
      final messageString = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      // print(
      //    'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
      if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/temperature') {
        data1 = messageString;
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/humidity') {
        data2 = messageString;
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/rainrate1') {
        data3 = messageString;
        print("rr1 is ${data3}");
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/rainrate2') {
        data4 = messageString;
        print("rr2 is ${data4}");
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/rainrate3') {
        data5 = messageString;
        print("rr3 is ${data5}");
      }

      updateList(messageString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Welcome to your home",
              style: TextStyle(color: Color.fromRGBO(255, 213, 74, 1)),
            ),
            backgroundColor: const Color.fromRGBO(100, 0, 200, 0.8),
          ),
          body: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: const Text(
                    "Weather",
                    style: TextStyle(
                        fontSize: 45, color: Color.fromRGBO(100, 0, 200, 0.8)),
                  )),
              const SizedBox(
                height: 5,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Image.network(icon_url),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      "$weatherType",
                      style: TextStyle(
                        fontSize: 33,
                        color: Color.fromRGBO(100, 0, 200, 0.8),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    width: 120,
                    alignment: Alignment.centerRight,
                    child: Text(
                      textDirection: TextDirection.ltr,
                      "$t1/$t2℃",
                      style: TextStyle(
                        fontSize: 33,
                        color: Color.fromRGBO(100, 0, 200, 0.8),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 33,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                child: const Text(
                  "Room Data",
                  style: TextStyle(
                      fontSize: 45, color: Color.fromRGBO(100, 0, 200, 0.8)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 55,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(10),
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            print("bedroom");
                            setState(() {
                              currentindex = 0;
                            });
                          },
                          child: const Text(
                            "Bedroom",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 7),
                        ElevatedButton(
                            onPressed: () {
                              print("Living Room");
                              setState(() {
                                currentindex = 1;
                              });
                            },
                            child: const Text(
                              "Living Room",
                              style: TextStyle(fontSize: 20),
                            )),
                        const SizedBox(width: 7),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentindex = 2;
                              });
                              print("Kitchen");
                            },
                            child: const Text(
                              "Kitchen",
                              style: TextStyle(fontSize: 20),
                            )),
                        const SizedBox(width: 7),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentindex = 2;
                              });
                              print("Dining Room");
                            },
                            child: const Text(
                              "Dining Room",
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(100, 0, 200, 0.8),
                        ),
                        child: Text(
                          "Temperature:$data1",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(255, 213, 74, 1),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(100, 0, 200, 0.8),
                        ),
                        child: Text(
                          "Humidity:$data2",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(255, 213, 74, 1),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(100, 0, 200, 0.8),
                        ),
                        child: Text(
                          "Rain Rate:$rain_rate",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(255, 213, 74, 1),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
