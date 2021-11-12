import 'machine_status.dart';

class Machine {
  final int id;
  final MachineStatus status;
  Machine({required this.id, required this.status});

  factory Machine.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final MachineStatus status = MachineStatus.fromJson(json['status'])!;

    return Machine(id: id, status: status);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['status'] = status.toJson();
    return json;
  }

  static List<Machine> listFromJson(List<dynamic>? json) =>
      json == null ? [] : json.map((e) => Machine.fromJson(e)).toList();

  String toHtml() => "<h6 class = 'machine'>$id: ${status.toJson()}</h6></br>";
  static String toHtmlDocument(List<Machine> machines) {
    String _machines = '';
    for (var macihne in machines) {
      _machines += macihne.toHtml();
    }
    return '''
      <html>
        <body>
        $_machines
        </body>
      </html>
    '''
        .trim();
  }

  static List<Machine> fromHtml(String html) {
    int start = html.indexOf('<body>') + 6;
    int end = html.indexOf('</body>');
    html = html
        .substring(start, end)
        .trim()
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[()]'), '');
    final strings = html.split('</h6></br>');
    print(strings);
    for (var string in strings) {
      print("item: $string");
    }
    List<Machine> machines = [];
    for (var string in strings) {
      final int idStart = string.indexOf('>') + 1;
      final int idEnd = string.indexOf(':');
      if (idStart == 0 || idEnd == -1) continue;
      final String idStr = string.substring(idStart, idEnd);
      final int id = int.parse(idStr);
      string = string.substring(idEnd + 1);
      final MachineStatus machineStatus =
          MachineStatus.fromJson(int.tryParse(string))!;
      machines.add(Machine(id: id, status: machineStatus));
    }
    return machines;
  }
}
