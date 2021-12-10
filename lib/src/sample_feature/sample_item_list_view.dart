import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laundry/src/models/machine.dart';
import 'package:laundry/src/models/machine_status.dart';
import 'package:laundry/src/mqtt/mqtt_contoller.dart';
import 'package:laundry/src/mqtt/mqtt_view.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../settings/settings_view.dart';
import 'sample_controller.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  SampleItemListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  final SampleController controller = SampleController(MqttController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.connect_without_contact),
            onPressed: () {
              Navigator.pushNamed(context, MqttView.routeName,
                  arguments: controller.mqttController);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.reconnect,
        child: const Icon(Icons.refresh),
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            print('_________________________________________________');
            print('_________________________________________________');
            print(controller.items);
            print('_________________________________________________');
            print('_________________________________________________');
            return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'sampleItemListView',
              itemCount: controller.items.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == controller.items.length) {
                  return AnimatedBuilder(
                      animation: controller.mqttController,
                      builder: (context, _) {
                        return Center(
                            child: Text(controller.mqttController.status));
                      });
                }
                if (index == controller.items.length + 1) {
                  return Text(controller.errorText);
                }

                final item = controller.items[index];

                return ListTile(
                  title: Text(item.status.toString()),
                  leading: CircleAvatar(
                    // Display the Flutter Logo image asset.
                    child: Text('${item.id}'),
                  ),
                  trailing: Text(controller.trailingText(item, index)),
                  onTap: () {
                    controller.onMachineTap(controller.items[index]);
                  },
                  onLongPress: () {
                    controller.onMachineLongTap(controller.items[index]);
                  },
                );
              },
            );
          }),
    );
  }
}
