import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
   SignInScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passController = TextEditingController();
   var firstNameController = TextEditingController();
   var lastNameController = TextEditingController();

   var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#6823D0"),
        title:const Text( 'purplebook'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign Up',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MsMadi',
                        color: HexColor("#6823D0")
                    ),),
                  const SizedBox(height: 30,),
                  TextFormField(
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    validator: validateFirstName,
                    decoration: InputDecoration(
                      // icon: Icons(Icons.alternate_email),
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        hintText: 'First Name',
                        hintStyle:Theme.of(context).textTheme.subtitle2,
                        border:const OutlineInputBorder() ,
                        enabledBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder:   OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#6823D0")),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.all(10)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    validator: validateLastName,
                    decoration: InputDecoration(
                      // icon: Icons(Icons.alternate_email),
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        hintText: 'Last Name',
                        hintStyle:Theme.of(context).textTheme.subtitle2,
                        border:const OutlineInputBorder() ,
                        enabledBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#6823D0")),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.all(10)),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    decoration: InputDecoration(
                      // icon: Icons(Icons.alternate_email),
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                        ),
                        hintText: 'Email',
                        hintStyle:Theme.of(context).textTheme.subtitle2,
                        border:const OutlineInputBorder() ,
                        enabledBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder:   OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#6823D0")),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.all(10)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      // icon: Icons(Icons.alternate_email),
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        hintText: 'Password',
                        hintStyle:Theme.of(context).textTheme.subtitle2,
                        border:const OutlineInputBorder() ,
                        enabledBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#6823D0")),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.all(10)),
                  ),
                  const SizedBox(height: 25,),
                  ConditionalBuilder(
                    condition: 10>5,
                    builder:(context)=>Container(
                      width: double.infinity,
                      color: HexColor("#6823D0"),
                      child: TextButton(
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            print('Ok');
                          }
                        },
                        child: const Text('SIGNUP',style: TextStyle(fontSize: 25,color: Colors.white),),
                      ),
                    ) ,
                    fallback: (context)=>Center(
                      child: CircularProgressIndicator(
                        color: HexColor("#6823D0"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  String? validateEmail(String? value) {
    if (value != null) {
      if (value.length > 5 && value.contains('@') && value.endsWith('.com')) {
        return null;
      }
      return 'Enter a Valid Email Address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value != null) {
      if (value.length >= 6) {
        return null;
      }
      return 'Password must be more than six characters';
    }
    return null;
  }

   String? validateFirstName(String? value) {
     if (value != null) {
       return null;
       }
       return 'Password must be more than six characters';
   }
   String? validateLastName(String? value) {
     if (value != null) {
         return null;
       }
       return 'Password must be more than six characters';
   }

}
