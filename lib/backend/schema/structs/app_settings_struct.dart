// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AppSettingsStruct extends FFFirebaseStruct {
  AppSettingsStruct({
    String? id,
    String? accentColor,
    String? textSize,
    bool? notificationsOn,
    String? language,
    bool? offlineMode,
    int? pendingSyncCount,
    bool? isDirty,
    String? syncStatus,
    String? createdAt,
    String? updatedAt,
    bool? deleted,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _accentColor = accentColor,
        _textSize = textSize,
        _notificationsOn = notificationsOn,
        _language = language,
        _offlineMode = offlineMode,
        _pendingSyncCount = pendingSyncCount,
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

  // "accentColor" field.
  String? _accentColor;
  String get accentColor => _accentColor ?? '';
  set accentColor(String? val) => _accentColor = val;

  bool hasAccentColor() => _accentColor != null;

  // "textSize" field.
  String? _textSize;
  String get textSize => _textSize ?? '';
  set textSize(String? val) => _textSize = val;

  bool hasTextSize() => _textSize != null;

  // "notificationsOn" field.
  bool? _notificationsOn;
  bool get notificationsOn => _notificationsOn ?? false;
  set notificationsOn(bool? val) => _notificationsOn = val;

  bool hasNotificationsOn() => _notificationsOn != null;

  // "language" field.
  String? _language;
  String get language => _language ?? '';
  set language(String? val) => _language = val;

  bool hasLanguage() => _language != null;

  // "offlineMode" field.
  bool? _offlineMode;
  bool get offlineMode => _offlineMode ?? false;
  set offlineMode(bool? val) => _offlineMode = val;

  bool hasOfflineMode() => _offlineMode != null;

  // "pendingSyncCount" field.
  int? _pendingSyncCount;
  int get pendingSyncCount => _pendingSyncCount ?? 0;
  set pendingSyncCount(int? val) => _pendingSyncCount = val;

  void incrementPendingSyncCount(int amount) =>
      pendingSyncCount = pendingSyncCount + amount;

  bool hasPendingSyncCount() => _pendingSyncCount != null;

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

  static AppSettingsStruct fromMap(Map<String, dynamic> data) =>
      AppSettingsStruct(
        id: data['id'] as String?,
        accentColor: data['accentColor'] as String?,
        textSize: data['textSize'] as String?,
        notificationsOn: data['notificationsOn'] as bool?,
        language: data['language'] as String?,
        offlineMode: data['offlineMode'] as bool?,
        pendingSyncCount: castToType<int>(data['pendingSyncCount']),
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deleted: data['deleted'] as bool?,
      );

  static AppSettingsStruct? maybeFromMap(dynamic data) => data is Map
      ? AppSettingsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'accentColor': _accentColor,
        'textSize': _textSize,
        'notificationsOn': _notificationsOn,
        'language': _language,
        'offlineMode': _offlineMode,
        'pendingSyncCount': _pendingSyncCount,
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
        'accentColor': serializeParam(
          _accentColor,
          ParamType.String,
        ),
        'textSize': serializeParam(
          _textSize,
          ParamType.String,
        ),
        'notificationsOn': serializeParam(
          _notificationsOn,
          ParamType.bool,
        ),
        'language': serializeParam(
          _language,
          ParamType.String,
        ),
        'offlineMode': serializeParam(
          _offlineMode,
          ParamType.bool,
        ),
        'pendingSyncCount': serializeParam(
          _pendingSyncCount,
          ParamType.int,
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

  static AppSettingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      AppSettingsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        accentColor: deserializeParam(
          data['accentColor'],
          ParamType.String,
          false,
        ),
        textSize: deserializeParam(
          data['textSize'],
          ParamType.String,
          false,
        ),
        notificationsOn: deserializeParam(
          data['notificationsOn'],
          ParamType.bool,
          false,
        ),
        language: deserializeParam(
          data['language'],
          ParamType.String,
          false,
        ),
        offlineMode: deserializeParam(
          data['offlineMode'],
          ParamType.bool,
          false,
        ),
        pendingSyncCount: deserializeParam(
          data['pendingSyncCount'],
          ParamType.int,
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
  String toString() => 'AppSettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AppSettingsStruct &&
        id == other.id &&
        accentColor == other.accentColor &&
        textSize == other.textSize &&
        notificationsOn == other.notificationsOn &&
        language == other.language &&
        offlineMode == other.offlineMode &&
        pendingSyncCount == other.pendingSyncCount &&
        isDirty == other.isDirty &&
        syncStatus == other.syncStatus &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        deleted == other.deleted;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        accentColor,
        textSize,
        notificationsOn,
        language,
        offlineMode,
        pendingSyncCount,
        isDirty,
        syncStatus,
        createdAt,
        updatedAt,
        deleted
      ]);
}

AppSettingsStruct createAppSettingsStruct({
  String? id,
  String? accentColor,
  String? textSize,
  bool? notificationsOn,
  String? language,
  bool? offlineMode,
  int? pendingSyncCount,
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
    AppSettingsStruct(
      id: id,
      accentColor: accentColor,
      textSize: textSize,
      notificationsOn: notificationsOn,
      language: language,
      offlineMode: offlineMode,
      pendingSyncCount: pendingSyncCount,
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

AppSettingsStruct? updateAppSettingsStruct(
  AppSettingsStruct? appSettings, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    appSettings
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAppSettingsStructData(
  Map<String, dynamic> firestoreData,
  AppSettingsStruct? appSettings,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (appSettings == null) {
    return;
  }
  if (appSettings.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && appSettings.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final appSettingsData =
      getAppSettingsFirestoreData(appSettings, forFieldValue);
  final nestedData =
      appSettingsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = appSettings.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAppSettingsFirestoreData(
  AppSettingsStruct? appSettings, [
  bool forFieldValue = false,
]) {
  if (appSettings == null) {
    return {};
  }
  final firestoreData = mapToFirestore(appSettings.toMap());

  // Add any Firestore field values
  appSettings.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAppSettingsListFirestoreData(
  List<AppSettingsStruct>? appSettingss,
) =>
    appSettingss?.map((e) => getAppSettingsFirestoreData(e, true)).toList() ??
    [];
