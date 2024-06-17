
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/themes/colors.dart';
import 'package:roomexaminationschedulingsystem/widgets/custom_radio_button_widget.dart';

enum Mode{update, create}

class UserDialogForm extends StatefulWidget {
  const UserDialogForm({
    super.key,
    this.onAddUser,
    this.onUpdateUser,
    this.mode,
    this.user
  });

  final void Function()? onAddUser;
  final void Function()? onUpdateUser;
  final Mode? mode;
  final AppUser? user;

  @override
  State<UserDialogForm> createState() => _UserDialogFormState();
}

class _UserDialogFormState extends State<UserDialogForm> {
  final _form = GlobalKey<FormState>();
  bool showPassword = true;
  bool isRegister = true;
  int selectedValue = 1;
  String get userRole {
    return (selectedValue == 1) ? 'faculty' : 'registrar';
  }
  bool isActive = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.user != null){
      nameController.text = widget.user!.name!;
      isActive = widget.user!.isActive!;
      if(widget.user!.role! == 'faculty'){
        setState(() {
          selectedValue = 1;
        });
      } else {
        setState(() {
          selectedValue = 2;
        });
      }
    }
  }

  void resetForm(){
    _form.currentState!.reset();
    emailController.text = '';
    nameController.text = '';
    passwordController.text = '';
  }

  Future<void> addUser(AppUser user) async{
    await user.register();
    widget.onAddUser;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("User Added!"),
    ));
  }

  Future<void> updateUser(AppUser user) async{
    await user.updateUser();
    widget.onUpdateUser;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("User Updated!"),
    ));
  }

  Future<void> submitUser() async {
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();

    if(widget.mode == Mode.create){
      final user = AppUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          isActive: isActive,
          role: userRole,
          context: context
      );
      await addUser(user);
      widget.onAddUser!();
    } else {
      final user = AppUser(
          uid: widget.user!.uid!,
          isActive: isActive,
          role: userRole,
          name: nameController.text,
          context: context
      );
      await updateUser(user);
      widget.onUpdateUser!();
    }
  }

  void onRadioValueChanged(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
                      Row(
                        children: [
                          Text(
                            widget.mode == Mode.create
                                ? 'Add User'
                                : 'Update User',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close_rounded))
                        ],
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
                      isRegister ? CustomRadioButtonWidget(
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
                      widget.mode == Mode.create ? const SizedBox(
                        height: 15,
                      ) : const SizedBox.shrink(),
                      widget.mode == Mode.create ? TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                      ) : const SizedBox.shrink(),
                      widget.mode == Mode.create ? const SizedBox(
                        height: 15,
                      ) : const SizedBox.shrink(),
                      widget.mode == Mode.create ? TextFormField(
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
                      ) : const SizedBox.shrink(),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          Switch(
                              value: isActive,
                              onChanged: (value){
                                setState(() {
                                  isActive = value;
                                });
                              }
                          ),
                          Text(isActive ? 'Active' : 'Inactive'),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18)
                          ),
                          onPressed: submitUser,
                          child: Text(
                            widget.mode == Mode.create ? 'Add' : 'Update',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
