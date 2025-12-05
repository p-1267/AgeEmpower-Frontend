import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medication_form_model.dart';
export 'medication_form_model.dart';

/// Create page MedicationForm (AppBar “Medication”) with params: mode
/// (“add”|“edit”), itemIndex (int), itemJSON (Map).
///
/// UI: TextField nameTF (“Medication name”), TextField doseTF (“Dose”),
/// TimePicker timePK, Multiline notesTF, Button Save. On Page Load: if
/// mode=="edit" & itemJSON exists, prefill fields from keys
/// name,dose,time,notes. Save onTap: if nameTF.text.trim().isEmpty → snackbar
/// “Name required”, stop. else if mode=="edit" → call
/// updateMedicationAtIndexFn(index:itemIndex,name:nameTF.text.trim(),dose:doseTF.text.trim(),time:timePK.value,notes:notesTF.text);
/// else →
/// addMedicationFn(name:nameTF.text.trim(),dose:doseTF.text.trim(),time:timePK.value,notes:notesTF.text).
/// On success → snackbar “Saved”, Navigate Back to Medications and refresh.
/// From Medications: FAB “+” → navigate with mode:"add"; item edit → navigate
/// with mode:"edit", itemIndex, itemJSON.
class MedicationFormWidget extends StatefulWidget {
  const MedicationFormWidget({super.key});

  static String routeName = 'MedicationForm';
  static String routePath = '/medicationForm';

  @override
  State<MedicationFormWidget> createState() => _MedicationFormWidgetState();
}

class _MedicationFormWidgetState extends State<MedicationFormWidget> {
  late MedicationFormModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MedicationFormModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          title: Text(
            'Medication',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: custom_widgets.MedicationFormCW(
            width: 100.0,
            height: 100.0,
          ),
        ),
      ),
    );
  }
}
