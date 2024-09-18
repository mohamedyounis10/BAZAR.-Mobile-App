import 'package:bazarapp/BloC/section3/forgetpasswordBLoC/logic.dart';
import 'package:bazarapp/BloC/section3/forgetpasswordBLoC/state.dart';
import 'package:bazarapp/pages/section3/successcreate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordScreen extends StatelessWidget {
  // Data
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  //UI
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => Forgetpasswordlogic(),
        child: BlocConsumer<Forgetpasswordlogic, Forgetpasswordstate>(
            listener: (context, state) {},
            builder: (context, state) {
              Forgetpasswordlogic logic = BlocProvider.of(context);
              return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // texts
                        Text(
                          'New Password',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Create your new password, so you can login to your account.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 30),

                        // new password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              width: 327,
                              height: 56,
                              color: Color(0xFFF5F5F5),
                              child: TextFormField(
                                controller: newPasswordController,
                                obscureText: logic.show1,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                onChanged:  logic.validatePassword,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Your Password',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      logic.togglePasswordVisibility1();
                                    },
                                    icon: Icon(
                                      logic.show1 ? Icons.visibility_off : Icons.visibility,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (logic.hasStartedTyping) ...[
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        logic.isLengthValid ? Icons.check : Icons.close,
                                        color: logic.isLengthValid ? Colors.green : Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Minimum 8 characters",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: logic.isLengthValid ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        logic.isNumberValid ? Icons.check : Icons.close,
                                        color: logic.isNumberValid ? Colors.green : Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "At least 1 number (0-9)",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: logic.isNumberValid ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        logic.isLetterValid ? Icons.check : Icons.close,
                                        color: logic.isLetterValid ? Colors.green : Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "At least 1 letter (a-z or A-Z)",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: logic.isLetterValid ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 10),

                        // confirm password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              width: 327,
                              height: 56,
                              color: Color(0xFFF5F5F5),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: logic.show2,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Your Password',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      logic.togglePasswordVisibility2();
                                    },
                                    icon: Icon(
                                      logic.show2 ? Icons.visibility_off : Icons.visibility,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),

                        // send
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 140, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48),
                              ),
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              // Check if both passwords match
                              if (newPasswordController.text == confirmPasswordController.text) {
                                logic.updatePassword(newPasswordController.text).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Password updated successfully!"),
                                    ),
                                  );

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (c) {
                                        return Successcreate();
                                      },
                                    ),
                                  );
                                }).catchError((error) {
                                  // Handle errors if any
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Failed to update password: $error"),
                                    ),
                                  );
                                });
                              } else {
                                print("Passwords do not match! Please try again.");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Passwords do not match! Please try again."),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Send',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ),
              );
            }
        )
    );
  }

}
