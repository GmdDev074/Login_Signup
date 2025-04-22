import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyForgotPassword extends StatefulWidget {
  const MyForgotPassword({super.key});

  @override
  State<MyForgotPassword> createState() => _MyForgotPasswordState();
}

class _MyForgotPasswordState extends State<MyForgotPassword> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.cover)),
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        // using scaffold removes the container to fix the the issue we use this
        backgroundColor: Colors.transparent,

        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                'Forgot\npassword',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.28,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false, // Disables auto-correction
                    enableSuggestions: false,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25), // Max length of 25
                      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces in email
                    ],
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.green.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    // Optional: Check email format in onChanged or onSubmitted
                    onChanged: (value) {
                      // You can add further email format validation here if needed
                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                        // Show error or handle invalid email format
                      }
                    },
                  ),
                  SizedBox(
                      height: 20
                  ),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    autocorrect: false, // Disables auto-correction
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      labelText: "Password",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),

                  SizedBox(
                      height: 30
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Forgot Password',
                        style: TextStyle(fontSize: 27,
                            color: Color(0xff4c505b),
                            fontWeight: FontWeight.w700),
                      ),

                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xff4c505b),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: (){},
                          icon: Icon(Icons.arrow_forward),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                      height: 30
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pushReplacementNamed(context, 'register');
                      },
                        child: Text('Sign Up', style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color(0xff4c505b),
                        ),),
                      ),

                      TextButton(onPressed: (){
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                        child: Text('Sign In', style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color(0xff4c505b),
                        ),),
                      )

                    ],
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
