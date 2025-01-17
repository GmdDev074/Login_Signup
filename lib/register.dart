import 'package:flutter/material.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
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

        // using scaffold removes the container to fix the the issue we use this
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
                    decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                      height: 30
                  ),

                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Number',
                        fillColor: Colors.green.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                      height: 30
                  ),

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
