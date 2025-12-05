import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medications_model.dart';
export 'medications_model.dart';

/// Create a page Medications
class MedicationsWidget extends StatefulWidget {
  const MedicationsWidget({
    super.key,
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  static String routeName = 'Medications';
  static String routePath = '/medications';

  @override
  State<MedicationsWidget> createState() => _MedicationsWidgetState();
}

class _MedicationsWidgetState extends State<MedicationsWidget> {
  late MedicationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MedicationsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (loggedIn == false) {
        GoRouter.of(context).prepareAuthEvent();
        final user = await authManager.signInAnonymously(context);
        if (user == null) {
          return;
        }
      } else {
        return;
      }

      context.goNamedAuth(MainshellWidget.routeName, context.mounted);
    });

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
            'Medications',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          toolbarHeight: 56.0,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              custom_widgets.MedicationsCW(
                width: 400.0,
                height: 700.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
