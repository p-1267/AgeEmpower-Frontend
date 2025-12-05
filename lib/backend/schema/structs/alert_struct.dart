// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AlertStruct extends FFFirebaseStruct {
  AlertStruct({
    String? id,
    String? type,
    String? time,
    bool? resolved,
    String? notes,
    bool? isDirty,
    String? syncStatus,
    String? createdAt,
    String? updatedAt,
    bool? deleted,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _type = type,
        _time = time,
        _resolved = resolved,
        _notes = notes,
        _isDirty = isDirty,
        _syncStatus = syncStatus,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _deleted = deleted,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "time" field.
  String? _time;
  String get time => _time ?? '';
  set time(String? val) => _time = val;

  bool hasTime() => _time != null;

  // "resolved" field.
  bool? _resolved;
  bool get resolved => _resolved ?? false;
  set resolved(bool? val) => _resolved = val;

  bool hasResolved() => _resolved != null;

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

  // "createdAt" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  String? _updatedAt;
  String get updatedAt => _updatedAt ?? '';
  set updatedAt(String? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "deleted" field.
  bool? _deleted;
  bool get deleted => _deleted ?? false;
  set deleted(bool? val) => _deleted = val;

  bool hasDeleted() => _deleted != null;

  static AlertStruct fromMap(Map<String, dynamic> data) => AlertStruct(
        id: data['id'] as String?,
        type: data['type'] as String?,
        time: data['time'] as String?,
        resolved: data['resolved'] as bool?,
        notes: data['notes'] as String?,
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deleted: data['deleted'] as bool?,
      );

  static AlertStruct? maybeFromMap(dynamic data) =>
      data is Map ? AlertStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type,
        'time': _time,
        'resolved': _resolved,
        'notes': _notes,
        'isDirty': _isDirty,
        'sync_status': _syncStatus,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
        'deleted': _deleted,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'time': serializeParam(
          _time,
          ParamType.String,
        ),
        'resolved': serializeParam(
          _resolved,
          ParamType.bool,
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
        'createdAt': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'updatedAt': serializeParam(
          _updatedAt,
          ParamType.String,
        ),
        'deleted': serializeParam(
          _deleted,
          ParamType.bool,
        ),
      }.withoutNulls;

  static AlertStruct fromSerializableMap(Map<String, dynamic> data) =>
      AlertStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        time: deserializeParam(
          data['time'],
          ParamType.String,
          false,
        ),
        resolved: deserializeParam(
          data['resolved'],
          ParamType.bool,
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
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.String,
          false,
        ),
        updatedAt: deserializeParam(
          data['updatedAt'],
          ParamType.String,
          false,
        ),
        deleted: deserializeParam(
          data['deleted'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'AlertStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AlertStruct &&
        id == other.id &&
        type == other.type &&
        time == other.time &&
        resolved == other.resolved &&
        notes == other.notes &&
        isDirty == other.isDirty &&
        syncStatus == other.syncStatus &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        deleted == other.deleted;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        type,
        time,
        resolved,
        notes,
        isDirty,
        syncStatus,
        createdAt,
        updatedAt,
        deleted
      ]);
}

AlertStruct createAlertStruct({
  String? id,
  String? type,
  String? time,
  bool? resolved,
  String? notes,
  bool? isDirty,
  String? syncStatus,
  String? createdAt,
  String? updatedAt,
  bool? deleted,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AlertStruct(
      id: id,
      type: type,
      time: time,
      resolved: resolved,
      notes: notes,
      isDirty: isDirty,
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deleted: deleted,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AlertStruct? updateAlertStruct(
  AlertStruct? alert, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    alert
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAlertStructData(
  Map<String, dynamic> firestoreData,
  AlertStruct? alert,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (alert == null) {
    return;
  }
  if (alert.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && alert.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final alertData = getAlertFirestoreData(alert, forFieldValue);
  final nestedData = alertData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = alert.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAlertFirestoreData(
  AlertStruct? alert, [
  bool forFieldValue = false,
]) {
  if (alert == null) {
    return {};
  }
  final firestoreData = mapToFirestore(alert.toMap());

  // Add any Firestore field values
  alert.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAlertListFirestoreData(
  List<AlertStruct>? alerts,
) =>
    alerts?.map((e) => getAlertFirestoreData(e, true)).toList() ?? [];
