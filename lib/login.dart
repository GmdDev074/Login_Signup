import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        // using scaffold removes the container to fix the the issue we use this
        backgroundColor: Colors.transparent,

        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, top: 100),
              child: Text(
                'Welcome\nback',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Email',
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                      height: 30
                  ),
                  TextField(
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
                      Text('Sign In',
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
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'register');
                        },
                      child: Text('Sign Up', style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                          color: Color(0xff4c505b),
                      ),),
                      ),

                      TextButton(onPressed: (){
                        Navigator.pushReplacementNamed(context, 'forgot_password');
                      },
                        child: Text('Forgot Password', style: TextStyle(
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
