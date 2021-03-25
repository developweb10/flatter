import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProgressBar {
  ProgressDialog progressDialog;

  ProgressBar._();

  static final ProgressBar client = ProgressBar._();

  showProgressBar(BuildContext context) {
    progressDialog = new ProgressDialog(context);
    progressDialog.show();
  }

  dismissProgressBar() {
    progressDialog.hide();
  }
}

