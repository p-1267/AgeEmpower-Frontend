import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _conversationId =
          prefs.getStringList('ff_conversationId') ?? _conversationId;
    });
    _safeInit(() {
      _iceNumber = prefs.getString('ff_iceNumber') ?? _iceNumber;
    });
    _safeInit(() {
      _iceSMS = prefs.getString('ff_iceSMS') ?? _iceSMS;
    });
    _safeInit(() {
      _emergencyCall = prefs.getString('ff_emergencyCall') ?? _emergencyCall;
    });
    _safeInit(() {
      _poisonNumber = prefs.getString('ff_poisonNumber') ?? _poisonNumber;
    });
    _safeInit(() {
      _policeNonEmergency =
          prefs.getString('ff_policeNonEmergency') ?? _policeNonEmergency;
    });
    _safeInit(() {
      _isLoggedIn = prefs.getBool('ff_isLoggedIn') ?? _isLoggedIn;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _aiRecipe = '';
  String get aiRecipe => _aiRecipe;
  set aiRecipe(String value) {
    _aiRecipe = value;
  }

  List<String> _conversationId = [];
  List<String> get conversationId => _conversationId;
  set conversationId(List<String> value) {
    _conversationId = value;
    prefs.setStringList('ff_conversationId', value);
  }

  void addToConversationId(String value) {
    conversationId.add(value);
    prefs.setStringList('ff_conversationId', _conversationId);
  }

  void removeFromConversationId(String value) {
    conversationId.remove(value);
    prefs.setStringList('ff_conversationId', _conversationId);
  }

  void removeAtIndexFromConversationId(int index) {
    conversationId.removeAt(index);
    prefs.setStringList('ff_conversationId', _conversationId);
  }

  void updateConversationIdAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    conversationId[index] = updateFn(_conversationId[index]);
    prefs.setStringList('ff_conversationId', _conversationId);
  }

  void insertAtIndexInConversationId(int index, String value) {
    conversationId.insert(index, value);
    prefs.setStringList('ff_conversationId', _conversationId);
  }

  String _iceNumber = '';
  String get iceNumber => _iceNumber;
  set iceNumber(String value) {
    _iceNumber = value;
    prefs.setString('ff_iceNumber', value);
  }

  String _iceSMS = '';
  String get iceSMS => _iceSMS;
  set iceSMS(String value) {
    _iceSMS = value;
    prefs.setString('ff_iceSMS', value);
  }

  /// 911
  String _emergencyCall = '';
  String get emergencyCall => _emergencyCall;
  set emergencyCall(String value) {
    _emergencyCall = value;
    prefs.setString('ff_emergencyCall', value);
  }

  /// 1-800-222-1222
  String _poisonNumber = '';
  String get poisonNumber => _poisonNumber;
  set poisonNumber(String value) {
    _poisonNumber = value;
    prefs.setString('ff_poisonNumber', value);
  }

  /// 311
  String _policeNonEmergency = '';
  String get policeNonEmergency => _policeNonEmergency;
  set policeNonEmergency(String value) {
    _policeNonEmergency = value;
    prefs.setString('ff_policeNonEmergency', value);
  }

  /// 988
  String _crisisHotline = '';
  String get crisisHotline => _crisisHotline;
  set crisisHotline(String value) {
    _crisisHotline = value;
  }

  List<dynamic> _medications = [
    jsonDecode(
        '{\"id\":\"1\",\"name\":\"Lisinopril 10mg\",\"dose\":\"Take 1 tablet daily with water\",\"notes\":\"Next: Today 8:00 AM\",\"status\":\"Active\"}')
  ];
  List<dynamic> get medications => _medications;
  set medications(List<dynamic> value) {
    _medications = value;
  }

  void addToMedications(dynamic value) {
    medications.add(value);
  }

  void removeFromMedications(dynamic value) {
    medications.remove(value);
  }

  void removeAtIndexFromMedications(int index) {
    medications.removeAt(index);
  }

  void updateMedicationsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    medications[index] = updateFn(_medications[index]);
  }

  void insertAtIndexInMedications(int index, dynamic value) {
    medications.insert(index, value);
  }

  DocumentReference? _editMedRef;
  DocumentReference? get editMedRef => _editMedRef;
  set editMedRef(DocumentReference? value) {
    _editMedRef = value;
  }

  String _medMode = '';
  String get medMode => _medMode;
  set medMode(String value) {
    _medMode = value;
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    prefs.setBool('ff_isLoggedIn', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
