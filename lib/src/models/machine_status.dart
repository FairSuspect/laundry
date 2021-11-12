/// Класс сделан с помощью шаблона генератора openapi_generator
/// https://pub.dev/packages/openapi_generator

class MachineStatus {
  /// Instantiate a new enum with the provided [value].
  const MachineStatus._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MachineStatus && other.value == value;

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

  int toJson() => value;

  static const ready = MachineStatus._(0);
  static const notOperational = MachineStatus._(1);
  static const busy = MachineStatus._(2);

  /// List of normal possible values in this [enum][MachineStatus].
  static const values = <MachineStatus>[
    ready,
    notOperational,
    busy,
  ];

  static MachineStatus? fromJson(dynamic value) =>
      StatusTypeTransformer().decode(value);

  static List<MachineStatus?>? listFromJson(
    List<dynamic> json, {
    bool? emptyIsNull,
    bool? growable,
  }) =>
      json.isEmpty
          ? true == emptyIsNull
              ? null
              : <MachineStatus>[]
          : json
              .map((value) => MachineStatus.fromJson(value))
              .toList(growable: true == growable);
}

/// Transformation class that can [encode] an instance of [MachineStatus] to int,
/// and [decode] dynamic data back to [MachineStatus].
class StatusTypeTransformer {
  const StatusTypeTransformer._();

  factory StatusTypeTransformer() => _instance ??= StatusTypeTransformer._();

  int encode(MachineStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a MachineStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [ArgumentError] is thrown.

  MachineStatus? decode(dynamic data) {
    switch (data) {
      case 0:
        return MachineStatus.ready;
      case 1:
        return MachineStatus.notOperational;
      case 2:
        return MachineStatus.busy;
      default:
        throw ArgumentError('Unknown enum value to decode: $data');
    }
    return null;
  }

  /// Singleton [StatusTypeTransformer] instance.
  static StatusTypeTransformer? _instance;
}
