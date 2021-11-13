import 'package:flutter/material.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/models/machine_status.dart';

class SampleController with ChangeNotifier {
  SampleController() {
    final json = testMachines.map((e) => e.toJson()).toList();
    final jsonMachines = Machine.listFromJson(json);

    final xml = Machine.toXmlDocument(testMachines);
    final xmlMachines = Machine.listFromXml(xml);

    final html = Machine.toHtmlDocument(testMachines);
    final htmlMachines = Machine.fromHtml(html);

    items.addAll([...jsonMachines, ...xmlMachines, ...htmlMachines]);

    notifyListeners();
  }
  final List<Machine> items = [];
  static final testMachines = [
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
