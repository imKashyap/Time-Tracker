import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/cmn_widgets/platform_alert_dialog.dart';
import 'package:timetracker/cmn_widgets/submit_button.dart';
import 'package:timetracker/pages/signin_page/phone_sign_in/phone_sign_in_model.dart';
import 'package:timetracker/sevices/auth.dart';

class PhoneSignInForm extends StatefulWidget {
  PhoneSignInForm({@required this.model});
  final PhoneSignInModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<PhoneSignInModel>(
      create: (_) => PhoneSignInModel(auth: auth),
      child: Consumer<PhoneSignInModel>(
        builder: (context, model, _) => PhoneSignInForm(
          model: model,
        ),
      ),
    );
  }

  @override
  _PhoneSignInFormState createState() => _PhoneSignInFormState();
}

class _PhoneSignInFormState extends State<PhoneSignInForm> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  PhoneSignInModel get model => widget.model;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  
  Future<void> _submit() async {
    try {
      await model.verifyOtp();
     // Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: e.message,
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  TextField _buildPhoneField(StateSetter state) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _phoneNumberController,
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        errorText: model.phoneErrorText,
        labelText: "10 digit mobile number",
        prefix: Container(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "+91",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
      onChanged: model.updatePhone,
      autocorrect: false,
      maxLengthEnforced: true,
    );
  }

  Widget _buildOTPField(StateSetter state) {
    return model.codeSent
        ? TextField(
            keyboardType: TextInputType.number,
            controller: _otpController,
            decoration: InputDecoration(
              enabled: model.isLoading == false,
              labelText: "6 digit OTP",
              prefixIcon: Icon(Icons.lock),
            ),
            textInputAction: TextInputAction.done,
            onChanged: model.updateSmsCode,
            autocorrect: false,
            maxLengthEnforced: true,
          )
        : Container();
  }

   List<Widget> _buildChildren(StateSetter state) {
    return [
      _buildPhoneField(state),
      SizedBox(height: 8.0),
      _buildOTPField(state),
      SizedBox(height: 8.0),
      SubmitButton(
        text: model.codeSent ? "VERIFY" : "Send OTP",
        onPressed: model.canSubmit ?(model.codeSent? _submit:model.submit  ):null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Container(
        padding: EdgeInsets.all(16),
        //height: MediaQuery.of(context).size.height * 0.7,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(state),
        ),
      );
    });
  }
}
