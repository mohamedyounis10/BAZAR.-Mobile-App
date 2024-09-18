import 'package:bazarapp/BloC/section2/verificationBLoC/logic.dart';
import 'package:bazarapp/BloC/section2/verificationBLoC/state.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class VerificationCodeEmail extends StatelessWidget {
  final String userId;
  final EmailOTP myauth;

  VerificationCodeEmail({required this.userId, required this.myauth});

  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerficationLogic(),
      child: BlocConsumer<VerficationLogic, Verficationstate>(
        listener: (context, state) {},
        builder: (context, state) {
          VerficationLogic logic = BlocProvider.of<VerficationLogic>(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        "Verification Email",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Please enter the code we just sent to Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        logic.email,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  OTPTextField(
                    controller: otpController,
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 50,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    otpFieldStyle: OtpFieldStyle(
                      backgroundColor: Color(0xFFF5F5F5),
                      borderColor: Color(0xFF54408C),
                      focusBorderColor: Color(0xFF54408C),
                    ),
                    keyboardType: TextInputType.number,
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      logic.enteredOtp = pin;
                      // Optionally, you can verify OTP immediately when completed
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you didn’t receive a code?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          logic.resendOTP(context);
                        },
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF54408C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 327,
                    height: 56,
                    child: MaterialButton(
                      onPressed: () {
                        logic.verifyOTP(context);
                      }, // Call verifyOTP method
                      color: Color(0xFF54408C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
