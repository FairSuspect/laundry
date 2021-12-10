import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/models/machine_status.dart';
import 'package:laundry/src/mqtt/mqtt_contoller.dart';
import 'package:mqtt_client/mqtt_client.dart';

class SampleController with ChangeNotifier {
  SampleController(this.mqttController) {
    // final json = testMachines.map((e) => e.toJson()).toList();
    // final jsonMachines = Machine.listFromJson(json);

    // final xml = Machine.toXmlDocument(testMachines);
    // final xmlMachines = Machine.listFromXml(xml);

    // final html = Machine.toHtmlDocument(testMachines);
    // final htmlMachines = Machine.fromHtml(html);

    // items.addAll([...jsonMachines, ...xmlMachines, ...htmlMachines]);

    mqttController.client.updates?.listen(onMessage);
  }
  String errorText = '';
  late final MqttController mqttController;
  List<Machine> items = [
    Machine(id: 0, status: MachineStatus.notOperational),
    Machine(id: 1, status: MachineStatus.notOperational),
    Machine(id: 2, status: MachineStatus.notOperational),
    Machine(id: 3, status: MachineStatus.notOperational),
    Machine(id: 4, status: MachineStatus.notOperational),
  ];
  void onMessage(List<MqttReceivedMessage<MqttMessage>> data) {
    final message = data.first.payload as MqttPublishMessage;
    final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);
    try {
      final _machine = Machine.fromJson(json.decode(payload));
      errorText = '';
      updateMachine(_machine);
    } catch (e) {
      // controller.items[index].status = MachineStatus.notOperational;
      errorText = 'Не удалось обновить машинку: $payload';
      notifyListeners();
    }
  }

  void reconnect() async {
    await mqttController.connect();
    mqttController.client.updates?.listen(onMessage);
  }

  void updateMachine(Machine _machine) {
    final _index = items.indexWhere((element) => element.id == _machine.id);
    if (_index == -1) return;
    items.removeAt(_index);
    items.insert(_index, _machine);
    notifyListeners();
  }

  void onMachineTap(Machine machine) {
    machine.status = MachineStatus.busy;
    final pubTopic = 'machine_${machine.id}';

    final builder = MqttClientPayloadBuilder();
    builder.addString("$machine");
    mqttController.client
        .publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    notifyListeners();
  }

  void onMachineLongTap(Machine machine) {
    machine.status = MachineStatus.ready;
    final pubTopic = 'machine_${machine.id}';

    final builder = MqttClientPayloadBuilder();
    print(machine);
    builder.addString("$machine");
    mqttController.client
        .publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    notifyListeners();
  }

  String trailingText(Machine model, int index) {
    final int idx = index ~/ 9;
    switch (idx) {
      case 0:
        return 'json';
      case 1:
        return 'xml';
      case 2:
        return 'html';
      default:
        return 'html';
    }
  }
}
