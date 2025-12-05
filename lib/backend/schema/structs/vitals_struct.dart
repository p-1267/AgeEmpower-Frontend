// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class VitalsStruct extends FFFirebaseStruct {
  VitalsStruct({
    int? id,
    String? dateTime,
    int? heartRate,
    int? systolic,
    int? diastolic,
    int? spo2,
    int? steps,
    double? weightKg,
    String? notes,
    bool? isDirty,
    String? syncStatus,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _dateTime = dateTime,
        _heartRate = heartRate,
        _systolic = systolic,
        _diastolic = diastolic,
        _spo2 = spo2,
        _steps = steps,
        _weightKg = weightKg,
        _notes = notes,
        _isDirty = isDirty,
        _syncStatus = syncStatus,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "dateTime" field.
  String? _dateTime;
  String get dateTime => _dateTime ?? '';
  set dateTime(String? val) => _dateTime = val;

  bool hasDateTime() => _dateTime != null;

  // "heartRate" field.
  int? _heartRate;
  int get heartRate => _heartRate ?? 0;
  set heartRate(int? val) => _heartRate = val;

  void incrementHeartRate(int amount) => heartRate = heartRate + amount;

  bool hasHeartRate() => _heartRate != null;

  // "systolic" field.
  int? _systolic;
  int get systolic => _systolic ?? 0;
  set systolic(int? val) => _systolic = val;

  void incrementSystolic(int amount) => systolic = systolic + amount;

  bool hasSystolic() => _systolic != null;

  // "diastolic" field.
  int? _diastolic;
  int get diastolic => _diastolic ?? 0;
  set diastolic(int? val) => _diastolic = val;

  void incrementDiastolic(int amount) => diastolic = diastolic + amount;

  bool hasDiastolic() => _diastolic != null;

  // "spo2" field.
  int? _spo2;
  int get spo2 => _spo2 ?? 0;
  set spo2(int? val) => _spo2 = val;

  void incrementSpo2(int amount) => spo2 = spo2 + amount;

  bool hasSpo2() => _spo2 != null;

  // "steps" field.
  int? _steps;
  int get steps => _steps ?? 0;
  set steps(int? val) => _steps = val;

  void incrementSteps(int amount) => steps = steps + amount;

  bool hasSteps() => _steps != null;

  // "weightKg" field.
  double? _weightKg;
  double get weightKg => _weightKg ?? 0.0;
  set weightKg(double? val) => _weightKg = val;

  void incrementWeightKg(double amount) => weightKg = weightKg + amount;

  bool hasWeightKg() => _weightKg != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  set notes(String? val) => _notes = val;

  bool hasNotes() => _notes != null;

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

  static VitalsStruct fromMap(Map<String, dynamic> data) => VitalsStruct(
        id: castToType<int>(data['id']),
        dateTime: data['dateTime'] as String?,
        heartRate: castToType<int>(data['heartRate']),
        systolic: castToType<int>(data['systolic']),
        diastolic: castToType<int>(data['diastolic']),
        spo2: castToType<int>(data['spo2']),
        steps: castToType<int>(data['steps']),
        weightKg: castToType<double>(data['weightKg']),
        notes: data['notes'] as String?,
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
      );

  static VitalsStruct? maybeFromMap(dynamic data) =>
      data is Map ? VitalsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'dateTime': _dateTime,
        'heartRate': _heartRate,
        'systolic': _systolic,
        'diastolic': _diastolic,
        'spo2': _spo2,
        'steps': _steps,
        'weightKg': _weightKg,
        'notes': _notes,
        'isDirty': _isDirty,
        'sync_status': _syncStatus,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'dateTime': serializeParam(
          _dateTime,
          ParamType.String,
        ),
        'heartRate': serializeParam(
          _heartRate,
          ParamType.int,
        ),
        'systolic': serializeParam(
          _systolic,
          ParamType.int,
        ),
        'diastolic': serializeParam(
          _diastolic,
          ParamType.int,
        ),
        'spo2': serializeParam(
          _spo2,
          ParamType.int,
        ),
        'steps': serializeParam(
          _steps,
          ParamType.int,
        ),
        'weightKg': serializeParam(
          _weightKg,
          ParamType.double,
        ),
        'notes': serializeParam(
          _notes,
          ParamType.String,
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

  static VitalsStruct fromSerializableMap(Map<String, dynamic> data) =>
      VitalsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        dateTime: deserializeParam(
          data['dateTime'],
          ParamType.String,
          false,
        ),
        heartRate: deserializeParam(
          data['heartRate'],
          ParamType.int,
          false,
        ),
        systolic: deserializeParam(
          data['systolic'],
          ParamType.int,
          false,
        ),
        diastolic: deserializeParam(
          data['diastolic'],
          ParamType.int,
          false,
        ),
        spo2: deserializeParam(
          data['spo2'],
          ParamType.int,
          false,
        ),
        steps: deserializeParam(
          data['steps'],
          ParamType.int,
          false,
        ),
        weightKg: deserializeParam(
          data['weightKg'],
          ParamType.double,
          false,
        ),
        notes: deserializeParam(
          data['notes'],
          ParamType.String,
          false,
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
  String toString() => 'VitalsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VitalsStruct &&
        id == other.id &&
        dateTime == other.dateTime &&
        heartRate == other.heartRate &&
        systolic == other.systolic &&
        diastolic == other.diastolic &&
        spo2 == other.spo2 &&
        steps == other.steps &&
        weightKg == other.weightKg &&
        notes == other.notes &&
        isDirty == other.isDirty &&
        syncStatus == other.syncStatus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        dateTime,
        heartRate,
        systolic,
        diastolic,
        spo2,
        steps,
        weightKg,
        notes,
        isDirty,
        syncStatus
      ]);
}

VitalsStruct createVitalsStruct({
  int? id,
  String? dateTime,
  int? heartRate,
  int? systolic,
  int? diastolic,
  int? spo2,
  int? steps,
  double? weightKg,
  String? notes,
  bool? isDirty,
  String? syncStatus,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VitalsStruct(
      id: id,
      dateTime: dateTime,
      heartRate: heartRate,
      systolic: systolic,
      diastolic: diastolic,
      spo2: spo2,
      steps: steps,
      weightKg: weightKg,
      notes: notes,
      isDirty: isDirty,
      syncStatus: syncStatus,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VitalsStruct? updateVitalsStruct(
  VitalsStruct? vitals, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    vitals
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVitalsStructData(
  Map<String, dynamic> firestoreData,
  VitalsStruct? vitals,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (vitals == null) {
    return;
  }
  if (vitals.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && vitals.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final vitalsData = getVitalsFirestoreData(vitals, forFieldValue);
  final nestedData = vitalsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = vitals.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVitalsFirestoreData(
  VitalsStruct? vitals, [
  bool forFieldValue = false,
]) {
  if (vitals == null) {
    return {};
  }
  final firestoreData = mapToFirestore(vitals.toMap());

  // Add any Firestore field values
  vitals.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVitalsListFirestoreData(
  List<VitalsStruct>? vitalss,
) =>
    vitalss?.map((e) => getVitalsFirestoreData(e, true)).toList() ?? [];
