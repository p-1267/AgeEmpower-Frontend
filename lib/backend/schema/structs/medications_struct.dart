// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MedicationsStruct extends FFFirebaseStruct {
  MedicationsStruct({
    int? id,
    String? name,
    String? dose,
    String? schedule,
    String? instructions,
    String? nextDoseTime,
    List<String>? takenHistory,
    bool? isDirty,
    String? syncStatus,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _name = name,
        _dose = dose,
        _schedule = schedule,
        _instructions = instructions,
        _nextDoseTime = nextDoseTime,
        _takenHistory = takenHistory,
        _isDirty = isDirty,
        _syncStatus = syncStatus,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "dose" field.
  String? _dose;
  String get dose => _dose ?? '';
  set dose(String? val) => _dose = val;

  bool hasDose() => _dose != null;

  // "schedule" field.
  String? _schedule;
  String get schedule => _schedule ?? '';
  set schedule(String? val) => _schedule = val;

  bool hasSchedule() => _schedule != null;

  // "instructions" field.
  String? _instructions;
  String get instructions => _instructions ?? '';
  set instructions(String? val) => _instructions = val;

  bool hasInstructions() => _instructions != null;

  // "nextDoseTime" field.
  String? _nextDoseTime;
  String get nextDoseTime => _nextDoseTime ?? '';
  set nextDoseTime(String? val) => _nextDoseTime = val;

  bool hasNextDoseTime() => _nextDoseTime != null;

  // "takenHistory" field.
  List<String>? _takenHistory;
  List<String> get takenHistory => _takenHistory ?? const [];
  set takenHistory(List<String>? val) => _takenHistory = val;

  void updateTakenHistory(Function(List<String>) updateFn) {
    updateFn(_takenHistory ??= []);
  }

  bool hasTakenHistory() => _takenHistory != null;

  // "isDirty" field.
  bool? _isDirty;
  bool get isDirty => _isDirty ?? false;
  set isDirty(bool? val) => _isDirty = val;

  bool hasIsDirty() => _isDirty != null;

  // "sync_status" field.
  String? _syncStatus;
  String get syncStatus => _syncStatus ?? '';
  set syncStatus(String? val) => _syncStatus = val;

  bool hasSyncStatus() => _syncStatus != null;

  static MedicationsStruct fromMap(Map<String, dynamic> data) =>
      MedicationsStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        dose: data['dose'] as String?,
        schedule: data['schedule'] as String?,
        instructions: data['instructions'] as String?,
        nextDoseTime: data['nextDoseTime'] as String?,
        takenHistory: getDataList(data['takenHistory']),
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
      );

  static MedicationsStruct? maybeFromMap(dynamic data) => data is Map
      ? MedicationsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'dose': _dose,
        'schedule': _schedule,
        'instructions': _instructions,
        'nextDoseTime': _nextDoseTime,
        'takenHistory': _takenHistory,
        'isDirty': _isDirty,
        'sync_status': _syncStatus,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'dose': serializeParam(
          _dose,
          ParamType.String,
        ),
        'schedule': serializeParam(
          _schedule,
          ParamType.String,
        ),
        'instructions': serializeParam(
          _instructions,
          ParamType.String,
        ),
        'nextDoseTime': serializeParam(
          _nextDoseTime,
          ParamType.String,
        ),
        'takenHistory': serializeParam(
          _takenHistory,
          ParamType.String,
          isList: true,
        ),
        'isDirty': serializeParam(
          _isDirty,
          ParamType.bool,
        ),
        'sync_status': serializeParam(
          _syncStatus,
          ParamType.String,
        ),
      }.withoutNulls;

  static MedicationsStruct fromSerializableMap(Map<String, dynamic> data) =>
      MedicationsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        dose: deserializeParam(
          data['dose'],
          ParamType.String,
          false,
        ),
        schedule: deserializeParam(
          data['schedule'],
          ParamType.String,
          false,
        ),
        instructions: deserializeParam(
          data['instructions'],
          ParamType.String,
          false,
        ),
        nextDoseTime: deserializeParam(
          data['nextDoseTime'],
          ParamType.String,
          false,
        ),
        takenHistory: deserializeParam<String>(
          data['takenHistory'],
          ParamType.String,
          true,
        ),
        isDirty: deserializeParam(
          data['isDirty'],
          ParamType.bool,
          false,
        ),
        syncStatus: deserializeParam(
          data['sync_status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MedicationsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MedicationsStruct &&
        id == other.id &&
        name == other.name &&
        dose == other.dose &&
        schedule == other.schedule &&
        instructions == other.instructions &&
        nextDoseTime == other.nextDoseTime &&
        listEquality.equals(takenHistory, other.takenHistory) &&
        isDirty == other.isDirty &&
        syncStatus == other.syncStatus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        dose,
        schedule,
        instructions,
        nextDoseTime,
        takenHistory,
        isDirty,
        syncStatus
      ]);
}

MedicationsStruct createMedicationsStruct({
  int? id,
  String? name,
  String? dose,
  String? schedule,
  String? instructions,
  String? nextDoseTime,
  bool? isDirty,
  String? syncStatus,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MedicationsStruct(
      id: id,
      name: name,
      dose: dose,
      schedule: schedule,
      instructions: instructions,
      nextDoseTime: nextDoseTime,
      isDirty: isDirty,
      syncStatus: syncStatus,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MedicationsStruct? updateMedicationsStruct(
  MedicationsStruct? medications, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    medications
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMedicationsStructData(
  Map<String, dynamic> firestoreData,
  MedicationsStruct? medications,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (medications == null) {
    return;
  }
  if (medications.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && medications.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final medicationsData =
      getMedicationsFirestoreData(medications, forFieldValue);
  final nestedData =
      medicationsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = medications.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMedicationsFirestoreData(
  MedicationsStruct? medications, [
  bool forFieldValue = false,
]) {
  if (medications == null) {
    return {};
  }
  final firestoreData = mapToFirestore(medications.toMap());

  // Add any Firestore field values
  medications.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMedicationsListFirestoreData(
  List<MedicationsStruct>? medicationss,
) =>
    medicationss?.map((e) => getMedicationsFirestoreData(e, true)).toList() ??
    [];
