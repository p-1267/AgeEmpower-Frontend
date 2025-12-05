// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class MessageThreadStruct extends FFFirebaseStruct {
  MessageThreadStruct({
    String? id,
    String? title,
    String? fromName,
    String? toName,
    String? preview,
    String? lastMessageTime,
    int? unreadCount,
    bool? isDirty,
    String? syncStatus,
    String? createdAt,
    String? updatedAt,
    bool? deleted,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _fromName = fromName,
        _toName = toName,
        _preview = preview,
        _lastMessageTime = lastMessageTime,
        _unreadCount = unreadCount,
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

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "fromName" field.
  String? _fromName;
  String get fromName => _fromName ?? '';
  set fromName(String? val) => _fromName = val;

  bool hasFromName() => _fromName != null;

  // "toName" field.
  String? _toName;
  String get toName => _toName ?? '';
  set toName(String? val) => _toName = val;

  bool hasToName() => _toName != null;

  // "preview" field.
  String? _preview;
  String get preview => _preview ?? '';
  set preview(String? val) => _preview = val;

  bool hasPreview() => _preview != null;

  // "lastMessageTime" field.
  String? _lastMessageTime;
  String get lastMessageTime => _lastMessageTime ?? '';
  set lastMessageTime(String? val) => _lastMessageTime = val;

  bool hasLastMessageTime() => _lastMessageTime != null;

  // "unreadCount" field.
  int? _unreadCount;
  int get unreadCount => _unreadCount ?? 0;
  set unreadCount(int? val) => _unreadCount = val;

  void incrementUnreadCount(int amount) => unreadCount = unreadCount + amount;

  bool hasUnreadCount() => _unreadCount != null;

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

  static MessageThreadStruct fromMap(Map<String, dynamic> data) =>
      MessageThreadStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        fromName: data['fromName'] as String?,
        toName: data['toName'] as String?,
        preview: data['preview'] as String?,
        lastMessageTime: data['lastMessageTime'] as String?,
        unreadCount: castToType<int>(data['unreadCount']),
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
        createdAt: data['createdAt'] as String?,
        updatedAt: data['updatedAt'] as String?,
        deleted: data['deleted'] as bool?,
      );

  static MessageThreadStruct? maybeFromMap(dynamic data) => data is Map
      ? MessageThreadStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'fromName': _fromName,
        'toName': _toName,
        'preview': _preview,
        'lastMessageTime': _lastMessageTime,
        'unreadCount': _unreadCount,
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
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'fromName': serializeParam(
          _fromName,
          ParamType.String,
        ),
        'toName': serializeParam(
          _toName,
          ParamType.String,
        ),
        'preview': serializeParam(
          _preview,
          ParamType.String,
        ),
        'lastMessageTime': serializeParam(
          _lastMessageTime,
          ParamType.String,
        ),
        'unreadCount': serializeParam(
          _unreadCount,
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

  static MessageThreadStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageThreadStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        fromName: deserializeParam(
          data['fromName'],
          ParamType.String,
          false,
        ),
        toName: deserializeParam(
          data['toName'],
          ParamType.String,
          false,
        ),
        preview: deserializeParam(
          data['preview'],
          ParamType.String,
          false,
        ),
        lastMessageTime: deserializeParam(
          data['lastMessageTime'],
          ParamType.String,
          false,
        ),
        unreadCount: deserializeParam(
          data['unreadCount'],
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
  String toString() => 'MessageThreadStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageThreadStruct &&
        id == other.id &&
        title == other.title &&
        fromName == other.fromName &&
        toName == other.toName &&
        preview == other.preview &&
        lastMessageTime == other.lastMessageTime &&
        unreadCount == other.unreadCount &&
        isDirty == other.isDirty &&
        syncStatus == other.syncStatus &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        deleted == other.deleted;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        fromName,
        toName,
        preview,
        lastMessageTime,
        unreadCount,
        isDirty,
        syncStatus,
        createdAt,
        updatedAt,
        deleted
      ]);
}

MessageThreadStruct createMessageThreadStruct({
  String? id,
  String? title,
  String? fromName,
  String? toName,
  String? preview,
  String? lastMessageTime,
  int? unreadCount,
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
    MessageThreadStruct(
      id: id,
      title: title,
      fromName: fromName,
      toName: toName,
      preview: preview,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
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

MessageThreadStruct? updateMessageThreadStruct(
  MessageThreadStruct? messageThread, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    messageThread
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMessageThreadStructData(
  Map<String, dynamic> firestoreData,
  MessageThreadStruct? messageThread,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (messageThread == null) {
    return;
  }
  if (messageThread.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && messageThread.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final messageThreadData =
      getMessageThreadFirestoreData(messageThread, forFieldValue);
  final nestedData =
      messageThreadData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = messageThread.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMessageThreadFirestoreData(
  MessageThreadStruct? messageThread, [
  bool forFieldValue = false,
]) {
  if (messageThread == null) {
    return {};
  }
  final firestoreData = mapToFirestore(messageThread.toMap());

  // Add any Firestore field values
  messageThread.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMessageThreadListFirestoreData(
  List<MessageThreadStruct>? messageThreads,
) =>
    messageThreads
        ?.map((e) => getMessageThreadFirestoreData(e, true))
        .toList() ??
    [];
