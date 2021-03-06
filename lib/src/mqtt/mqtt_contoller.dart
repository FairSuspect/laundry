import 'dart:io';
import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/models/machine_status.dart';
import 'package:laundry/src/services/dotenv.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';

class MqttController with ChangeNotifier {
  MqttController() {
    connect().then((value) {
      client = value;
      notifyListeners();
    });
  }
  // void Function(List<MqttReceivedMessage<MqttMessage>> data) onMessage;

  String status = 'Uknown';
  static const projectId = 'shining-env-334012';
  late MqttServerClient client;
  late Stream<List<MqttReceivedMessage<MqttMessage>>>? stream;
  Future<MqttServerClient> connect() async {
    status = 'Uknown';
    notifyListeners();
    // final jwt = JWT(
    //   {
    //     "iat": DateTime.now().millisecondsSinceEpoch * 1000,
    //     "exp": DateTime.now().millisecondsSinceEpoch * 1000 +
    //         20 * 60, // 20 minutes
    //     "aud": projectId,
    //   },
    // );
    // final _key =
    //     jwt.sign(SecretKey(File('rsa_private.pem').readAsStringSync()));
    // final dir = Directory.current;
    // final token =
    //     JWT.verify(_key, SecretKey(File('rsa_private.pem').readAsStringSync()));
    // print(token.payload);
    // JWTAlgorithm.ES256;
    // final int _index = Random().nextInt(10000);

    final index = Random().nextInt(100);
    client = MqttServerClient.withPort(
        '497f5615f9534f0b93945ab950868f16.s2.eu.hivemq.cloud',
        '497f5615f9534f0b93945ab950868f16$index',
        8883)
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..keepAlivePeriod = 20
      ..logging(on: true)
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected
      ..onUnsubscribed = onUnsubscribed
      ..onSubscribed = onSubscribed
      ..onSubscribeFail = onSubscribeFail
      ..pongCallback = pong;
    stream = client.updates;

    // stream = client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final MqttPublishMessage message = c[0].payload;
    //   final payload =
    //   MqttPublishPayload.bytesToStringAsString(message.payload.message);

    //   print('Received message:$payload from topic: ${c[0].topic}>');
    // });
    final connMessage = MqttConnectMessage()
        // .authenticateAs('username', 'password')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    client.keepAlivePeriod = 60;
    try {
      await client.connect(env.userName, env.password);
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {});

    return client;
  }

  static final testMachines = [
    Machine(id: 0, status: MachineStatus.busy),
    Machine(id: 1, status: MachineStatus.busy),
    Machine(id: 2, status: MachineStatus.busy),
    Machine(id: 3, status: MachineStatus.ready),
    Machine(id: 4, status: MachineStatus.notOperational),
    Machine(id: 5, status: MachineStatus.notOperational),
    Machine(id: 6, status: MachineStatus.notOperational),
    Machine(id: 7, status: MachineStatus.busy),
    Machine(id: 8, status: MachineStatus.ready),
    Machine(id: 9, status: MachineStatus.notOperational),
  ];
  void sendMessage() {
    const pubTopic = 'machine_0';
    final builder = MqttClientPayloadBuilder();

    final machine = testMachines[0]..status = MachineStatus.busy;

    builder.addString("$machine");

    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

// connection succeeded
  void onConnected() {
    print('Connected');
    for (int i = 0; i < 5; i++) {
      client.subscribe("machine_$i", MqttQos.atLeastOnce);
    }
    changeState("Connected");
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
    changeState("Disconnected");
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
    changeState("Subscribed");
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
    changeState("Failed to subscribe");
  }

// unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
    changeState("Unsubscribed");
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

  void changeState(String _status) {
    status = _status;
    notifyListeners();
  }
}
