import 'package:flutter/material.dart';
import 'package:laundry/src/mock/mock_controller.dart';
import 'package:laundry/src/models/machine_status.dart';

class MockView extends StatelessWidget {
  const MockView({Key? key, required this.controller}) : super(key: key);
  final MockController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mock объект"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return ListView(children: [
                Text(
                  "Статус машинки №${controller.machine.id}",
                  style: Theme.of(context).textTheme.headline6,
                ),
                ...MachineStatus.values
                    .map((e) => RadioListTile(
                          value: e,
                          title: Text(e.toString()),
                          groupValue: controller.machine.status,
                          onChanged: controller.onStatusChanged,
                        ))
                    .toList()
              ]);
            }),
      ),
    );
  }
}
