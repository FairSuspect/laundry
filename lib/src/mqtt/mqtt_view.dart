import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/mqtt/mqtt_contoller.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttView extends StatelessWidget {
  const MqttView(this.controller, {Key? key}) : super(key: key);

  final MqttController controller;

  static const String routeName = '/mqtt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MQTT"),
      ),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  controller.status == 'Uknown'
                      ? const CircularProgressIndicator()
                      : Text(controller.status),
                  StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
                    stream: controller.client.updates,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final MqttPublishMessage message =
                            snapshot.data!.first.payload as MqttPublishMessage;
                        final payload =
                            MqttPublishPayload.bytesToStringAsString(
                                message.payload.message);
                        String output;
                        try {
                          final _machine =
                              Machine.fromJson(json.decode(payload));

                          output = '${_machine.id} : ${_machine.status}';
                        } catch (e) {
                          print(e);
                          output = payload;
                        }

                        // print(payload);
                        return Text(output);
                      } else {
                        return const Text("Нет информации");
                      }
                    },
                  ),
                  ElevatedButton(
                      onPressed: controller.sendMessage,
                      child: const Text("Отправить сообщение")),
                  ElevatedButton(
                      onPressed: controller.connect,
                      child: Text("Переподключиться"))
                ],
              ),
            );
          }),
    );
  }
}
