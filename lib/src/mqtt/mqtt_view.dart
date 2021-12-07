import 'package:flutter/material.dart';
import 'package:laundry/src/mqtt/mqtt_contoller.dart';

class MqttView extends StatelessWidget {
  MqttView({Key? key}) : super(key: key);

  final MqttController controller = MqttController();

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
