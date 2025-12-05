import '/components/i_c_e_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'emergency_widget.dart' show EmergencyWidget;
import 'package:flutter/material.dart';

class EmergencyModel extends FlutterFlowModel<EmergencyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ICECard component.
  late ICECardModel iCECardModel;

  @override
  void initState(BuildContext context) {
    iCECardModel = createModel(context, () => ICECardModel());
  }

  @override
  void dispose() {
    iCECardModel.dispose();
  }
}
