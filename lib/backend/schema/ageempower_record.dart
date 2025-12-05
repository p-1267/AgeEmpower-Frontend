import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AgeempowerRecord extends FirestoreRecord {
  AgeempowerRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "edited_time" field.
  DateTime? _editedTime;
  DateTime? get editedTime => _editedTime;
  bool hasEditedTime() => _editedTime != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  bool hasBio() => _bio != null;

  // "user_name" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  // "systolic_bp" field.
  int? _systolicBp;
  int get systolicBp => _systolicBp ?? 0;
  bool hasSystolicBp() => _systolicBp != null;

  // "diastolic_bp" field.
  int? _diastolicBp;
  int get diastolicBp => _diastolicBp ?? 0;
  bool hasDiastolicBp() => _diastolicBp != null;

  // "heart_rate" field.
  int? _heartRate;
  int get heartRate => _heartRate ?? 0;
  bool hasHeartRate() => _heartRate != null;

  // "oxygen_level" field.
  int? _oxygenLevel;
  int get oxygenLevel => _oxygenLevel ?? 0;
  bool hasOxygenLevel() => _oxygenLevel != null;

  // "temperature_f" field.
  double? _temperatureF;
  double get temperatureF => _temperatureF ?? 0.0;
  bool hasTemperatureF() => _temperatureF != null;

  // "recorded_at" field.
  DateTime? _recordedAt;
  DateTime? get recordedAt => _recordedAt;
  bool hasRecordedAt() => _recordedAt != null;

  // "notes" field.
  int? _notes;
  int get notes => _notes ?? 0;
  bool hasNotes() => _notes != null;

  // "taken" field.
  bool? _taken;
  bool get taken => _taken ?? false;
  bool hasTaken() => _taken != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "dosage" field.
  String? _dosage;
  String get dosage => _dosage ?? '';
  bool hasDosage() => _dosage != null;

  // "drug_name" field.
  String? _drugName;
  String get drugName => _drugName ?? '';
  bool hasDrugName() => _drugName != null;

  // "schedule" field.
  String? _schedule;
  String get schedule => _schedule ?? '';
  bool hasSchedule() => _schedule != null;

  // "notes_text" field.
  String? _notesText;
  String get notesText => _notesText ?? '';
  bool hasNotesText() => _notesText != null;

  // "doc_type" field.
  String? _docType;
  String get docType => _docType ?? '';
  bool hasDocType() => _docType != null;

  // "medications" field.
  String? _medications;
  String get medications => _medications ?? '';
  bool hasMedications() => _medications != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _editedTime = snapshotData['edited_time'] as DateTime?;
    _bio = snapshotData['bio'] as String?;
    _userName = snapshotData['user_name'] as String?;
    _systolicBp = castToType<int>(snapshotData['systolic_bp']);
    _diastolicBp = castToType<int>(snapshotData['diastolic_bp']);
    _heartRate = castToType<int>(snapshotData['heart_rate']);
    _oxygenLevel = castToType<int>(snapshotData['oxygen_level']);
    _temperatureF = castToType<double>(snapshotData['temperature_f']);
    _recordedAt = snapshotData['recorded_at'] as DateTime?;
    _notes = castToType<int>(snapshotData['notes']);
    _taken = snapshotData['taken'] as bool?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _dosage = snapshotData['dosage'] as String?;
    _drugName = snapshotData['drug_name'] as String?;
    _schedule = snapshotData['schedule'] as String?;
    _notesText = snapshotData['notes_text'] as String?;
    _docType = snapshotData['doc_type'] as String?;
    _medications = snapshotData['medications'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Ageempower');

  static Stream<AgeempowerRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AgeempowerRecord.fromSnapshot(s));

  static Future<AgeempowerRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AgeempowerRecord.fromSnapshot(s));

  static AgeempowerRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AgeempowerRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AgeempowerRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AgeempowerRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AgeempowerRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AgeempowerRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAgeempowerRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  DateTime? editedTime,
  String? bio,
  String? userName,
  int? systolicBp,
  int? diastolicBp,
  int? heartRate,
  int? oxygenLevel,
  double? temperatureF,
  DateTime? recordedAt,
  int? notes,
  bool? taken,
  DateTime? createdAt,
  String? dosage,
  String? drugName,
  String? schedule,
  String? notesText,
  String? docType,
  String? medications,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'edited_time': editedTime,
      'bio': bio,
      'user_name': userName,
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'heart_rate': heartRate,
      'oxygen_level': oxygenLevel,
      'temperature_f': temperatureF,
      'recorded_at': recordedAt,
      'notes': notes,
      'taken': taken,
      'created_at': createdAt,
      'dosage': dosage,
      'drug_name': drugName,
      'schedule': schedule,
      'notes_text': notesText,
      'doc_type': docType,
      'medications': medications,
    }.withoutNulls,
  );

  return firestoreData;
}

class AgeempowerRecordDocumentEquality implements Equality<AgeempowerRecord> {
  const AgeempowerRecordDocumentEquality();

  @override
  bool equals(AgeempowerRecord? e1, AgeempowerRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.editedTime == e2?.editedTime &&
        e1?.bio == e2?.bio &&
        e1?.userName == e2?.userName &&
        e1?.systolicBp == e2?.systolicBp &&
        e1?.diastolicBp == e2?.diastolicBp &&
        e1?.heartRate == e2?.heartRate &&
        e1?.oxygenLevel == e2?.oxygenLevel &&
        e1?.temperatureF == e2?.temperatureF &&
        e1?.recordedAt == e2?.recordedAt &&
        e1?.notes == e2?.notes &&
        e1?.taken == e2?.taken &&
        e1?.createdAt == e2?.createdAt &&
        e1?.dosage == e2?.dosage &&
        e1?.drugName == e2?.drugName &&
        e1?.schedule == e2?.schedule &&
        e1?.notesText == e2?.notesText &&
        e1?.docType == e2?.docType &&
        e1?.medications == e2?.medications;
  }

  @override
  int hash(AgeempowerRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.editedTime,
        e?.bio,
        e?.userName,
        e?.systolicBp,
        e?.diastolicBp,
        e?.heartRate,
        e?.oxygenLevel,
        e?.temperatureF,
        e?.recordedAt,
        e?.notes,
        e?.taken,
        e?.createdAt,
        e?.dosage,
        e?.drugName,
        e?.schedule,
        e?.notesText,
        e?.docType,
        e?.medications
      ]);

  @override
  bool isValidKey(Object? o) => o is AgeempowerRecord;
}
