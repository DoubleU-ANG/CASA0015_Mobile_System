import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(const ControlPage());
}

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double i = 50;
  double j = 50;
  double k = 50;
  late List<Widget> feeds;
  String data1 = '';
  String data2 = '';
  String data3 = '';
  String data4 = '';
  String data5 = '';
  static const topic6 = 'student/CASA0014/plant/ucfnaaf/servo1';
  static const topic7 = 'student/CASA0014/plant/ucfnaaf/servo2';
  static const topic8 = 'student/CASA0014/plant/ucfnaaf/servo3';
  final builder = MqttClientPayloadBuilder();
  final client = MqttServerClient('mqtt.cetools.org', '');

  @override
  void initState() {
    super.initState();
    feeds = [];
    startMQTT();
  }

  updateList(String s) {
    setState(() {
      feeds.add(Text(s));
    });
  }

  Future<void> startMQTT() async {
    client.port = 1884;
    client.setProtocolV311();
    client.keepAlivePeriod = 30;
    final String username = 'student';
    final String password = 'ce2021-mqtt-forget-whale';
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
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $messageString -->');
      if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/temperature') {
        data1 = messageString;
        print("temperature is ${data1}");
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/humidity') {
        data2 = messageString;
        print("humidity is ${data2}");
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/rainrate1') {
        data3 = messageString;
        print("rainrate1 is ${data3}");
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/rainrate2') {
        data4 = messageString;
        print("rainrate2 is ${data4}");
      } else if (c[0].topic == 'student/CASA0014/plant/ucfnaaf/rainrate3') {
        data5 = messageString;
        print("rainrate3 is ${data5}");
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
            "Control Center",
            style: TextStyle(color: Color.fromRGBO(255, 213, 74, 1)),
          ),
          backgroundColor: const Color.fromRGBO(100, 0, 200, 0.8),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                "Window Assistance",
                style: TextStyle(
                  fontSize: 35,
                  color: Color.fromRGBO(100, 0, 200, 0.8),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(60, 5, 60, 5),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(100, 0, 200, 0.8),
              ),
              child: Text(
                "Control your window here",
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(255, 213, 74, 1),
                ),
              ),
            ),
            SizedBox(
              height: 10,
              width: double.infinity,
            ),
            Container(
              child: const Text(
                "Bedroom:",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(100, 0, 200, 0.8)),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: i * 2,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(100, 0, 200, 0.8),
                  ),
                ),
                Container(
                  width: 160 - i * 2,
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (i >= 10) {
                          i = i - 10;
                          double ii = i / 10;
                          builder.clear();
                          builder.addString("$ii");
                          client.publishMessage(
                              topic6, MqttQos.atLeastOnce, builder.payload!);
                        }
                      });
                    },
                    child: const Text(
                      "-",
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (i <= 60) {
                          i = i + 10;
                          double ii = i / 10;
                          builder.clear();
                          builder.addString("$ii");
                          client.publishMessage(
                              topic6, MqttQos.atLeastOnce, builder.payload!);
                        }
                      });
                    },
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
            Container(
              child: const Text(
                "Living Room:",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(100, 0, 200, 0.8)),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: j * 2,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(100, 0, 200, 0.8),
                  ),
                ),
                Container(
                  width: 160 - j * 2,
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (j >= 10) {
                          j = j - 10;
                          double jj = j / 10;
                          builder.clear();
                          builder.addString("$jj");
                          client.publishMessage(
                              topic7, MqttQos.atLeastOnce, builder.payload!);
                        }
                      });
                    },
                    child: const Text(
                      "-",
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (j <= 60) {
                          j = j + 10;
                          double jj = j / 10;
                          builder.clear();
                          builder.addString("$jj");
                          client.publishMessage(
                              topic7, MqttQos.atLeastOnce, builder.payload!);
                        }
                      });
                    },
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
            Container(
              child: const Text(
                "Dining Room:",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(100, 0, 200, 0.8)),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: k * 2,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(100, 0, 200, 0.8),
                  ),
                ),
                Container(
                  width: 160 - k * 2,
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (k >= 10) {
                          k = k - 10;
                          double kk = k / 10;
                          builder.clear();
                          builder.addString("$kk");
                          client.publishMessage(
                              topic8, MqttQos.atLeastOnce, builder.payload!);
                        }
                      });
                    },
                    child: const Text(
                      "-",
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (k <= 60) {
                          k = k + 10;
                          double kk = k / 10;
                          builder.clear();
                          builder.addString("$kk");
                          client.publishMessage(
                              topic8, MqttQos.atLeastOnce, builder.payload!);
                        }
                      });
                    },
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
