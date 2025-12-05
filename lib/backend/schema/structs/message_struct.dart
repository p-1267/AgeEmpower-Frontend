// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageStruct extends FFFirebaseStruct {
  MessageStruct({
    String? id,
    String? threadId,
    String? senderName,
    String? text,
    List<String>? attachments,
    String? sentAt,
    bool? isLocalOnly,
    bool? isDirty,
    String? syncStatus,
    bool? deleted,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _threadId = threadId,
        _senderName = senderName,
        _text = text,
        _attachments = attachments,
        _sentAt = sentAt,
        _isLocalOnly = isLocalOnly,
        _isDirty = isDirty,
        _syncStatus = syncStatus,
        _deleted = deleted,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "threadId" field.
  String? _threadId;
  String get threadId => _threadId ?? '';
  set threadId(String? val) => _threadId = val;

  bool hasThreadId() => _threadId != null;

  // "senderName" field.
  String? _senderName;
  String get senderName => _senderName ?? '';
  set senderName(String? val) => _senderName = val;

  bool hasSenderName() => _senderName != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "attachments" field.
  List<String>? _attachments;
  List<String> get attachments => _attachments ?? const [];
  set attachments(List<String>? val) => _attachments = val;

  void updateAttachments(Function(List<String>) updateFn) {
    updateFn(_attachments ??= []);
  }

  bool hasAttachments() => _attachments != null;

  // "sentAt" field.
  String? _sentAt;
  String get sentAt => _sentAt ?? '';
  set sentAt(String? val) => _sentAt = val;

  bool hasSentAt() => _sentAt != null;

  // "isLocalOnly" field.
  bool? _isLocalOnly;
  bool get isLocalOnly => _isLocalOnly ?? false;
  set isLocalOnly(bool? val) => _isLocalOnly = val;

  bool hasIsLocalOnly() => _isLocalOnly != null;

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

  // "deleted" field.
  bool? _deleted;
  bool get deleted => _deleted ?? false;
  set deleted(bool? val) => _deleted = val;

  bool hasDeleted() => _deleted != null;

  static MessageStruct fromMap(Map<String, dynamic> data) => MessageStruct(
        id: data['id'] as String?,
        threadId: data['threadId'] as String?,
        senderName: data['senderName'] as String?,
        text: data['text'] as String?,
        attachments: getDataList(data['attachments']),
        sentAt: data['sentAt'] as String?,
        isLocalOnly: data['isLocalOnly'] as bool?,
        isDirty: data['isDirty'] as bool?,
        syncStatus: data['sync_status'] as String?,
        deleted: data['deleted'] as bool?,
      );

  static MessageStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'threadId': _threadId,
        'senderName': _senderName,
        'text': _text,
        'attachments': _attachments,
        'sentAt': _sentAt,
        'isLocalOnly': _isLocalOnly,
        'isDirty': _isDirty,
        'sync_status': _syncStatus,
        'deleted': _deleted,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'threadId': serializeParam(
          _threadId,
          ParamType.String,
        ),
        'senderName': serializeParam(
          _senderName,
          ParamType.String,
        ),
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'attachments': serializeParam(
          _attachments,
          ParamType.String,
          isList: true,
        ),
        'sentAt': serializeParam(
          _sentAt,
          ParamType.String,
        ),
        'isLocalOnly': serializeParam(
          _isLocalOnly,
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
        'deleted': serializeParam(
          _deleted,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        threadId: deserializeParam(
          data['threadId'],
          ParamType.String,
          false,
        ),
        senderName: deserializeParam(
          data['senderName'],
          ParamType.String,
          false,
        ),
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        attachments: deserializeParam<String>(
          data['attachments'],
          ParamType.String,
          true,
        ),
        sentAt: deserializeParam(
          data['sentAt'],
          ParamType.String,
          false,
        ),
        isLocalOnly: deserializeParam(
          data['isLocalOnly'],
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
        deleted: deserializeParam(
          data['deleted'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'MessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MessageStruct &&
        id == other.id &&
        threadId == other.threadId &&
        senderName == other.senderName &&
        text == other.text &&
        listEquality.equals(attachments, other.attachments) &&
        sentAt == other.sentAt &&
        isLocalOnly == other.isLocalOnly &&
        isDirty == other.isDirty &&
        syncStatus == other.syncStatus &&
        deleted == other.deleted;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        threadId,
        senderName,
        text,
        attachments,
        sentAt,
        isLocalOnly,
        isDirty,
        syncStatus,
        deleted
      ]);
}

MessageStruct createMessageStruct({
  String? id,
  String? threadId,
  String? senderName,
  String? text,
  String? sentAt,
  bool? isLocalOnly,
  bool? isDirty,
  String? syncStatus,
  bool? deleted,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MessageStruct(
      id: id,
      threadId: threadId,
      senderName: senderName,
      text: text,
      sentAt: sentAt,
      isLocalOnly: isLocalOnly,
      isDirty: isDirty,
      syncStatus: syncStatus,
      deleted: deleted,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MessageStruct? updateMessageStruct(
  MessageStruct? message, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    message
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMessageStructData(
  Map<String, dynamic> firestoreData,
  MessageStruct? message,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (message == null) {
    return;
  }
  if (message.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && message.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final messageData = getMessageFirestoreData(message, forFieldValue);
  final nestedData = messageData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = message.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMessageFirestoreData(
  MessageStruct? message, [
  bool forFieldValue = false,
]) {
  if (message == null) {
    return {};
  }
  final firestoreData = mapToFirestore(message.toMap());

  // Add any Firestore field values
  message.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMessageListFirestoreData(
  List<MessageStruct>? messages,
) =>
    messages?.map((e) => getMessageFirestoreData(e, true)).toList() ?? [];
