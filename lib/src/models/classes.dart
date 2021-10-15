class Data {
  final int machineId;

  Data({required this.machineId});
  factory Data.fromJson(Map<String, dynamic> json) {
    final machineId = int.parse(json['machineId']);

    return Data(machineId: machineId);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['machindId'] = machineId;

    return json;
  }
}

class MachineStatus {
  final int machineId;
  final Status status;
  MachineStatus({required this.machineId, required this.status});

  factory MachineStatus.fromJson(Map<String, dynamic> json) {
    final machineId = int.parse(json['machineId']);
    final Status status = Status.fromJson(json['status'])!;

    return MachineStatus(machineId: machineId, status: status);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['machindId'] = machineId;
    json['status'] = status.toJson();
    return json;
  }
}

/// Класс сделан с помощью шаблона генератора openapi_generator
/// https://pub.dev/packages/openapi_generator

class Status {
  /// Instantiate a new enum with the provided [value].
  const Status._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Status && other.value == value;

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    switch (value) {
      case 0:
        return 'ready';
      case 1:
        return 'notOperational';
      case 2:
        return 'busy';
      default:
        throw ArgumentError.value(value, 'value', 'Неизвестное состояние');
    }
  }

  String toJson() => toString();

  static const ready = Status._(0);
  static const notOperational = Status._(1);
  static const busy = Status._(2);

  /// List of normal possible values in this [enum][Status].
  static const values = <Status>[
    ready,
    notOperational,
    busy,
  ];

  static Status? fromJson(dynamic value) =>
      StatusTypeTransformer().decode(value);

  static List<Status?>? listFromJson(
    List<dynamic> json, {
    bool? emptyIsNull,
    bool? growable,
  }) =>
      json.isEmpty
          ? true == emptyIsNull
              ? null
              : <Status>[]
          : json
              .map((value) => Status.fromJson(value))
              .toList(growable: true == growable);
}

/// Transformation class that can [encode] an instance of [Status] to int,
/// and [decode] dynamic data back to [Status].
class StatusTypeTransformer {
  const StatusTypeTransformer._();

  factory StatusTypeTransformer() => _instance ??= StatusTypeTransformer._();

  int encode(Status data) => data.value;

  /// Decodes a [dynamic value][data] to a Status.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [ArgumentError] is thrown.

  Status? decode(dynamic data) {
    switch (data) {
      case 0:
        return Status.ready;
      case 1:
        return Status.notOperational;
      case 2:
        return Status.busy;
      default:
        throw ArgumentError('Unknown enum value to decode: $data');
    }
    return null;
  }

  /// Singleton [StatusTypeTransformer] instance.
  static StatusTypeTransformer? _instance;
}
