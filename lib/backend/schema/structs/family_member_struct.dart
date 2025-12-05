// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class FamilyMemberStruct extends FFFirebaseStruct {
  FamilyMemberStruct({
    String? id,
    String? fullName,
    String? relation,
    String? phone,
    String? email,
    bool? shareAccess,
    bool? isEmergencyContact,
    bool? isDirty,
    String? syncStatus,
    String? createdAt,
    String? updatedAt,
    bool? deleted,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _fullName = fullName,
        _relation = relation,
        _phone = phone,
        _email = email,
        _shareAccess = shareAccess,
        _isEmergencyContact = isEmergencyContact,
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

  // "relation" field.
  String? _relation;
  String get relation => _relation ?? '';
  set relation(String? val) => _relation = val;

  bool hasRelation() => _relation != null;

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

  // "shareAccess" field.
  bool? _shareAccess;
  bool get shareAccess => _shareAccess ?? false;
  set shareAccess(bool? val) => _shareAccess = val;

  bool hasShareAccess() => _shareAccess != null;

  // "isEmergencyContact" field.
  bool? _isEmergencyContact;
  bool get isEmergencyContact => _isEmergencyContact ?? false;
  set isEmergencyContact(bool? val) => _isEmergencyContact = val;

  bool hasIsEmergencyContact() => _isEmergencyContact != null;

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

  static FamilyMemberStruct fromMap(Map<String, dynamic> data) =>
      FamilyMemberStruct(
        id: data['id'] as String?,
        fullName: data['fullName'] as String?,
        relation: data['relation'] as String?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        shareAccess: data['shareAccess'] as bool?,
        isEmergencyContact: data['isEmergencyContact'] as bool?,
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deleted: data['deleted'] as bool?,
      );

  static FamilyMemberStruct? maybeFromMap(dynamic data) => data is Map
      ? FamilyMemberStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'fullName': _fullName,
        'relation': _relation,
        'phone': _phone,
        'email': _email,
        'shareAccess': _shareAccess,
        'isEmergencyContact': _isEmergencyContact,
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
        'relation': serializeParam(
          _relation,
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
        'shareAccess': serializeParam(
          _shareAccess,
          ParamType.bool,
        ),
        'isEmergencyContact': serializeParam(
          _isEmergencyContact,
          ParamType.bool,
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

  static FamilyMemberStruct fromSerializableMap(Map<String, dynamic> data) =>
      FamilyMemberStruct(
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
        relation: deserializeParam(
          data['relation'],
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
        shareAccess: deserializeParam(
          data['shareAccess'],
          ParamType.bool,
          false,
        ),
        isEmergencyContact: deserializeParam(
          data['isEmergencyContact'],
          ParamType.bool,
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
  String toString() => 'FamilyMemberStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FamilyMemberStruct &&
        id == other.id &&
        fullName == other.fullName &&
        relation == other.relation &&
        phone == other.phone &&
        email == other.email &&
        shareAccess == other.shareAccess &&
        isEmergencyContact == other.isEmergencyContact &&
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
        relation,
        phone,
        email,
        shareAccess,
        isEmergencyContact,
        isDirty,
        syncStatus,
        createdAt,
        updatedAt,
        deleted
      ]);
}

FamilyMemberStruct createFamilyMemberStruct({
  String? id,
  String? fullName,
  String? relation,
  String? phone,
  String? email,
  bool? shareAccess,
  bool? isEmergencyContact,
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
    FamilyMemberStruct(
      id: id,
      fullName: fullName,
      relation: relation,
      phone: phone,
      email: email,
      shareAccess: shareAccess,
      isEmergencyContact: isEmergencyContact,
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

FamilyMemberStruct? updateFamilyMemberStruct(
  FamilyMemberStruct? familyMember, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    familyMember
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFamilyMemberStructData(
  Map<String, dynamic> firestoreData,
  FamilyMemberStruct? familyMember,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (familyMember == null) {
    return;
  }
  if (familyMember.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && familyMember.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final familyMemberData =
      getFamilyMemberFirestoreData(familyMember, forFieldValue);
  final nestedData =
      familyMemberData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = familyMember.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFamilyMemberFirestoreData(
  FamilyMemberStruct? familyMember, [
  bool forFieldValue = false,
]) {
  if (familyMember == null) {
    return {};
  }
  final firestoreData = mapToFirestore(familyMember.toMap());

  // Add any Firestore field values
  familyMember.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFamilyMemberListFirestoreData(
  List<FamilyMemberStruct>? familyMembers,
) =>
    familyMembers?.map((e) => getFamilyMemberFirestoreData(e, true)).toList() ??
    [];
