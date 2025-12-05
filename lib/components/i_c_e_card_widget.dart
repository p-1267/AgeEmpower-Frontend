import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'i_c_e_card_model.dart';
export 'i_c_e_card_model.dart';

class ICECardWidget extends StatefulWidget {
  const ICECardWidget({super.key});

  @override
  State<ICECardWidget> createState() => _ICECardWidgetState();
}

class _ICECardWidgetState extends State<ICECardWidget> {
  late ICECardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ICECardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          if (isiOS) {
            await launchUrl(Uri.parse(
                "sms:${'+15551234567'}&body=${Uri.encodeComponent('I need help. Please call me ASAP.')}"));
          } else {
            await launchUrl(Uri(
              scheme: 'sms',
              path: '+15551234567',
              queryParameters: <String, String>{
                'body': 'I need help. Please call me ASAP.',
              },
            ));
          }
        },
        onLongPress: () async {
          await launchUrl(Uri(
            scheme: 'tel',
            path: '+15551234567',
          ));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Color(0x40000000),
                offset: Offset(
                  0.0,
                  -2.0,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contacts',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                    ),
                    Text(
                      'Tap to call your emergency contacts',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
                Icon(
                  Icons.contacts,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
