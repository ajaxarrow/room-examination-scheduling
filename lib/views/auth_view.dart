import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';
import 'package:roomexaminationschedulingsystem/themes/colors.dart';
import '../widgets/custom_radio_button_widget.dart';


class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isRegister = true;
  final _form = GlobalKey<FormState>();
  bool showPassword = true;
  int selectedValue = 1;
  String get userRole {
    return (selectedValue == 1) ? 'faculty' : 'registrar';
  }
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void resetForm(){
    _form.currentState!.reset();
    emailController.text = '';
    nameController.text = '';
    passwordController.text = '';
  }

  void submit() async{
    final isValid = _form.currentState!.validate();


    if(!isValid){
      return;
    }
    _form.currentState!.save();
    if(isRegister){
      await AppUser(
        name: nameController.text,
        password: passwordController.text,
        email: emailController.text,
        role: userRole,
        context: context,
        isActive: true
      ).register();
    } else {
      await AppUser(
          name: nameController.text,
          password: passwordController.text,
          email: emailController.text,
          role: userRole,
          context: context
      ).login();
    }
  }

  void onRadioValueChanged(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isNotAuthenticated(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLarge = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Container(
        color: bgColor,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: isLarge ? Container(
            width: 850,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: outlineColor,
                width: 1
              ),
              borderRadius: BorderRadius.circular(25), // Set border radius for the second SizedBox
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 424,
                        height: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Form(
                                key: _form,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      isRegister ? 'Create Account!' : 'Welcome Back!',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800
                                      ),
                                    ),
                                    Text(
                                      isRegister ? 'Please register here to continue' : 'Please login here to continue',
                                      style: const TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    isRegister ? const Padding(
                                      padding: EdgeInsets.only(left: 3.0, bottom: 5),
                                      child: Text(
                                        'Register As: ',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                      ),
                                    ) : const SizedBox.shrink(),
                                    isRegister? CustomRadioButtonWidget(
                                        onValueChanged: onRadioValueChanged,
                                        initialValue: selectedValue) : const SizedBox.shrink(),
                                    isRegister ? const SizedBox(
                                      height: 20,
                                    ) : const SizedBox.shrink(),
                                    isRegister ? TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: 'Complete Name',
                                      ),
                                      validator: (value){
                                        if (value!.trim().isEmpty || value == null || value!.trim().length < 4  ){
                                          return 'Name must atleast have 5 characters';
                                        }
                                        return null;
                                      },
                                    ) : const SizedBox.shrink(),
                                    isRegister ? const SizedBox(
                                      height: 15,
                                    ) : const SizedBox.shrink(),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: 'Email',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization: TextCapitalization.none,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: showPassword,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock),
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                                showPassword ? Icons.visibility : Icons.visibility_off
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                          )
                                      ),
                                      validator: (value){
                                        if (value!.trim().isEmpty || value == null || value!.trim().length < 8  ){
                                          return 'Password must atleast have 8 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 18)
                                        ),
                                        onPressed: submit,
                                        child: Text(
                                          isRegister ? 'Register' : 'Login',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(isRegister ? 'Already have an account?' : 'New to platform?'),
                                        TextButton(
                                            onPressed: (){
                                              resetForm();
                                              setState(() {
                                                isRegister = !isRegister;
                                              });
                                            },
                                            child: Text(isRegister ? 'Login here' : 'Register Here')
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff274c77),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25))
                        ),
                        width: 424,
                        height: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Room Exam Scheduler',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  color: highlightColor
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Image.asset('lib/assets/images/auth-image.png'),
                              ),
                              const Text(
                                'Schedule your examination with Room Exam Scheduler',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: highlightColor
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ) :
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: outlineColor,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(25), // Set border radius for the second SizedBox
            ),
            width: 350,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'roomexamscheduler.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            isRegister ? 'Create Account!' : 'Welcome Back!',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          Text(
                            isRegister ? 'Please register here to continue' : 'Please login here to continue',
                            style: const TextStyle(
                                fontSize: 16
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isRegister ? const Padding(
                            padding: EdgeInsets.only(left: 3.0, bottom: 5),
                            child: Text(
                              'Register As: ',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          ) : const SizedBox.shrink(),
                          isRegister? CustomRadioButtonWidget(
                              onValueChanged: onRadioValueChanged,
                              initialValue: selectedValue) : const SizedBox.shrink(),
                          isRegister ? const SizedBox(
                            height: 20,
                          ) : const SizedBox.shrink(),
                          isRegister ? TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Complete Name',
                            ),
                            validator: (value){
                              if (value!.trim().isEmpty || value == null || value!.trim().length < 4  ){
                                return 'Name must atleast have 5 characters';
                              }
                              return null;
                            },
                          ) : const SizedBox.shrink(),
                          isRegister ? const SizedBox(
                            height: 15,
                          ) : const SizedBox.shrink(),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: showPassword,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      showPassword ? Icons.visibility : Icons.visibility_off
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                )
                            ),
                            validator: (value){
                              if (value!.trim().isEmpty || value == null || value!.trim().length < 8  ){
                                return 'Password must atleast have 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18)
                              ),
                              onPressed: submit,
                              child: Text(
                                isRegister ? 'Register' : 'Login',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isRegister ? 'Already have an account?' : 'New to platform?'),
                              TextButton(
                                  onPressed: (){
                                    resetForm();
                                    setState(() {
                                      isRegister = !isRegister;
                                    });
                                  },
                                  child: Text(isRegister ? 'Login here' : 'Register Here')
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
    );

  }
}
