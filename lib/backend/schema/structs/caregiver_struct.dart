// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CaregiverStruct extends FFFirebaseStruct {
  CaregiverStruct({
    String? id,
    String? fullName,
    String? role,
    String? phone,
    String? email,
    bool? onDuty,
    String? notes,
    bool? isDirty,
    String? syncStatus,
    String? createdAt,
    String? updatedAt,
    bool? deleted,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _fullName = fullName,
        _role = role,
        _phone = phone,
        _email = email,
        _onDuty = onDuty,
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

  // "fullName" field.
  String? _fullName;
  String get fullName => _fullName ?? '';
  set fullName(String? val) => _fullName = val;

  bool hasFullName() => _fullName != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "onDuty" field.
  bool? _onDuty;
  bool get onDuty => _onDuty ?? false;
  set onDuty(bool? val) => _onDuty = val;

  bool hasOnDuty() => _onDuty != null;

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

  static CaregiverStruct fromMap(Map<String, dynamic> data) => CaregiverStruct(
        id: data['id'] as String?,
        fullName: data['fullName'] as String?,
        role: data['role'] as String?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        onDuty: data['onDuty'] as bool?,
        notes: data['notes'] as String?,
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deleted: data['deleted'] as bool?,
      );

  static CaregiverStruct? maybeFromMap(dynamic data) => data is Map
      ? CaregiverStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'fullName': _fullName,
        'role': _role,
        'phone': _phone,
        'email': _email,
        'onDuty': _onDuty,
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
        'fullName': serializeParam(
          _fullName,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'onDuty': serializeParam(
          _onDuty,
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

  static CaregiverStruct fromSerializableMap(Map<String, dynamic> data) =>
      CaregiverStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        fullName: deserializeParam(
          data['fullName'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        onDuty: deserializeParam(
          data['onDuty'],
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
  String toString() => 'CaregiverStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CaregiverStruct &&
        id == other.id &&
        fullName == other.fullName &&
        role == other.role &&
        phone == other.phone &&
        email == other.email &&
        onDuty == other.onDuty &&
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
        fullName,
        role,
        phone,
        email,
        onDuty,
        notes,
        isDirty,
        syncStatus,
        createdAt,
        updatedAt,
        deleted
      ]);
}

CaregiverStruct createCaregiverStruct({
  String? id,
  String? fullName,
  String? role,
  String? phone,
  String? email,
  bool? onDuty,
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
    CaregiverStruct(
      id: id,
      fullName: fullName,
      role: role,
      phone: phone,
      email: email,
      onDuty: onDuty,
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

CaregiverStruct? updateCaregiverStruct(
  CaregiverStruct? caregiver, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    caregiver
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCaregiverStructData(
  Map<String, dynamic> firestoreData,
  CaregiverStruct? caregiver,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (caregiver == null) {
    return;
  }
  if (caregiver.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && caregiver.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final caregiverData = getCaregiverFirestoreData(caregiver, forFieldValue);
  final nestedData = caregiverData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = caregiver.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCaregiverFirestoreData(
  CaregiverStruct? caregiver, [
  bool forFieldValue = false,
]) {
  if (caregiver == null) {
    return {};
  }
  final firestoreData = mapToFirestore(caregiver.toMap());

  // Add any Firestore field values
  caregiver.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCaregiverListFirestoreData(
  List<CaregiverStruct>? caregivers,
) =>
    caregivers?.map((e) => getCaregiverFirestoreData(e, true)).toList() ?? [];
