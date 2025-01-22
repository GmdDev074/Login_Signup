import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.cover)
      ),
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        // using scaffold it removes the container background to fix the the issue we use this
        backgroundColor: Colors.transparent,

        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                'Register\nnow',
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
                    keyboardType: TextInputType.name,
                    autocorrect: false, // Disables auto-correction
                    enableSuggestions: false,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20), // Max length of 20
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')), // Only alphabets and spaces
                    ],
                    decoration: InputDecoration(
                      hintText: 'Name',
                      fillColor: Colors.green.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Name', // Makes the label float above when typing
                      floatingLabelBehavior: FloatingLabelBehavior.auto, // Float label when typing
                    ),
                  ),


                  SizedBox(
                      height: 30
                  ),

                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number, // Specifies the input type for numbers
                    decoration: InputDecoration(
                        hintText: 'Number',
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      labelText: "Number",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allows only numeric input
                      LengthLimitingTextInputFormatter(12), // Max length
                    ],
                    onChanged: (value) {
                      if (value.length < 3) {
                        print("Minimum 11 characters required!");
                      }
                      else if(value.length>3){
                        print("Maximum 12 characters allowed!");
                      }
                    },

                  ),
                  SizedBox(
                      height: 30
                  ),

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
                      height: 30
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    autocorrect: false, // Disables auto-correction
                    enableSuggestions: false,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),

                  SizedBox(
                      height: 40
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sign Up',
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
                      height: 40
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                        child: Text('Sign In', style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color(0xff4c505b),
                        ),),
                      ),

                      /*TextButton(onPressed: (){},
                        child: Text('Forgot Password', style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color(0xff4c505b),
                        ),),
                      )
*/
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
