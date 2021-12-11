import 'package:flutter/material.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/models/machine_status.dart';

class MockController with ChangeNotifier {
  MockController(this.machine, {this.onChanged});
  Machine machine;
  final void Function(MachineStatus? status)? onChanged;
  void onStatusChanged(MachineStatus? status) {
    onChanged!(status);
    notifyListeners();
  }
}
