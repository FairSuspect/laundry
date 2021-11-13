// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/models/machine_status.dart';
import 'package:laundry/src/sample_feature/file.dart';

void main() {
  group("Html parser", () {
    test("Three good machines", () {
      final html = Machine.toHtmlDocument(testMachines);
      saveFile('index.html', html);

      final machines = Machine.fromHtml(html);
      print(machines);
    });
  });
  group("Json parser", () {
    test("Three good machines", () {
      final json = testMachines.map((e) => e.toJson()).toList();
      saveFile('index.json', json.toString());
      final machines = Machine.listFromJson(json);
      String jsonString = '[';
      for (var machine in machines) {
        jsonString += machine.toString();
        if (machine != machines.last) {
          jsonString += ',';
        }
      }
      jsonString += ']';
      saveFile('text.json', jsonString);
      print(machines);
    });
  });
  group("XML parser", () {
    test("Three good machines", () {
      final xml = Machine.toXmlDocument(testMachines);
      saveFile('index.xml', xml);
      final machines = Machine.listFromXml(xml);
      print(machines);
    });
  });
}

final List<Machine> testMachines = [
  Machine(id: 1, status: MachineStatus.busy),
  Machine(id: 2, status: MachineStatus.busy),
  Machine(id: 3, status: MachineStatus.ready),
];
