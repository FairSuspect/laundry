import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController with ChangeNotifier {
  MqttController() {
    connect().then((value) {
      client = value;
      notifyListeners();
    });
  }

  String status = 'Uknown';

  late MqttServerClient client;

  Future<MqttServerClient> connect() async {
    status = 'Uknown';
    notifyListeners();
    client = MqttServerClient.withPort(
        'cloudiot.googleapis.com', 'flutter_client', 443)
      ..logging(on: true)
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected
      ..onUnsubscribed = onUnsubscribed
      ..onSubscribed = onSubscribed
      ..onSubscribeFail = onSubscribeFail
      ..pongCallback = pong;

    final connMessage = MqttConnectMessage()
        // .authenticateAs('username', 'password')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    client.keepAlivePeriod = 60;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {});

    return client;
  }

  void sendMessage() {
    const pubTopic = 'topic/test';
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello MQTT');
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

// connection succeeded
  void onConnected() {
    print('Connected');
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
