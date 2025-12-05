import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'health_monitor_model.dart';
export 'health_monitor_model.dart';

/// Generate a JSON recipe for the "Health Monitor" page.
///
/// Include these fields:
/// - systolic_bp: number, label "Systolic BP (mmHg)", required, min 70, max
/// 200
/// - diastolic_bp: number, label "Diastolic BP (mmHg)", required, min 40, max
/// 130
/// - heart_rate: number, label "Heart Rate (bpm)", required, min 30, max 200
/// - oxygen_level: number, label "Oxygen Level (%)", required, min 70, max
/// 100
/// - temperature: number, label "Temperature (°F)", required, min 90, max 110
/// - notes: multiline_text, label "Notes", optional
///
/// ⚠️ Rules:
/// - Reply ONLY with valid JSON.
/// - Do not include prose, explanations, or markdown.
/// - Output must include keys: queries, bindings, forms (even if empty).
class HealthMonitorWidget extends StatefulWidget {
  const HealthMonitorWidget({super.key});

  static String routeName = 'HealthMonitor';
  static String routePath = '/healthMonitor';

  @override
  State<HealthMonitorWidget> createState() => _HealthMonitorWidgetState();
}

class _HealthMonitorWidgetState extends State<HealthMonitorWidget> {
  late HealthMonitorModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HealthMonitorModel());

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
          iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).primary),
          automaticallyImplyLeading: true,
          title: Text(
            'Health Monitor',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 40.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.notifications_none,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
            ),
          ],
          centerTitle: true,
          toolbarHeight: 56.0,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: custom_widgets.HealthMonitorLayoutCW(
            width: 400.0,
            height: 900.0,
          ),
        ),
      ),
    );
  }
}
