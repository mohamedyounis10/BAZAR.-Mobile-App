import 'package:bazarapp/BloC/section2/page2_0BLoC/state.dart';
import 'package:bazarapp/pages/section1/page1_3.dart';
import 'package:bazarapp/pages/section2/page2_1.dart';
import 'package:bazarapp/pages/section3/page3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bazarapp/BloC/section2/page2_0BLoC/logic.dart';

class Page2_0 extends StatelessWidget {
  // Data
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // UI
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>Page2_0Logic(),
        child: BlocConsumer<Page2_0Logic,Page2_0state>(
          listener: (context,state){},
          builder: (context,state){
            Page2_0Logic logic=BlocProvider.of(context);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (c) {
                return Page1_3();
              }),
            );
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
            // Sign in
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Welcome Back👋",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Sign to your account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
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
                    controller: emailController,
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
                      hintText: 'Your Email',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Password
            SizedBox(height: 16),
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
                    controller: passwordController,
                    obscureText: logic.showPassword,
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
                        onPressed: () => logic.togglePasswordVisibility(),
                        icon: Icon(
                          logic.showPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Forget Password
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) {
                        return Page3();
                      }),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF54408C),
                    ),
                  ),
                ),
              ],
            ),

            // Login Button
            SizedBox(height: 16),
            Container(
              width: 327,
              height: 56,
              child: MaterialButton(
                onPressed:(){
                  logic.signin(context,emailController.text,passwordController.text);
                  },
                color: Color(0xFF54408C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16), // Add spacing between elements

            // Have account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont Have an account?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c){
                        return Page2_1(emaill: emailController.text,namee:'' ,);
                      })
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF54408C),
                    ),
                  ),
                ),
              ],
            ),

            // line and or with
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 0.0, right: 20.0),
                    child: Divider(
                      color: Colors.grey,
                      height: 36,
                    )),
              ),
              Text("Or With"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 0.0),
                    child: Divider(
                      color: Colors.grey,
                      height: 36,
                    )),
              ),
            ]),
            SizedBox(height: 16), // Add spacing between elements

            // sign in with google
            Container(
              width: 327,
              height: 56,
              child: MaterialButton(
                onPressed: () {
                  logic.signInWithGoogle(context);
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), // Border radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/img_1.png',height: 24,),
                    SizedBox(width: 10),
                    Text('Sign in with Google',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),

            ],
        ),
      ),
    );
    },
    ),
    );
  }
}