import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/data/programs.dart';
import 'package:roomexaminationschedulingsystem/model/program.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';

enum Mode{update, create}

class SectionDialogForm extends StatefulWidget {
  const SectionDialogForm({
    super.key,
    required this.onRefresh,
    required this.mode,
    this.section
  });

  final void Function() onRefresh;
  final Mode mode;
  final Section? section;


  @override
  State<SectionDialogForm> createState() => _SectionDialogFormState();
}

class _SectionDialogFormState extends State<SectionDialogForm> {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String selectedCollege = 'College of Agriculture';
  String selectedProgram = '';
  List<DropdownMenuItem> selectedPrograms = [];
  List<DropdownMenuItem> colleges = const [
    DropdownMenuItem(
      value: 'College of Agriculture',
      child: Text('College of Agriculture'),
    ),
    DropdownMenuItem(
      value: 'College of Arts and Sciences',
      child: Text('College of Arts and Sciences'),
    ),
    DropdownMenuItem(
      value: 'College of Business and Management',
      child: Text('College of Business and Management'),
    ),
    DropdownMenuItem(
      value: 'College of Education',
      child: Text('College of Education'),
    ),
    DropdownMenuItem(
      value: 'College of Engineering',
      child: Text('College of Engineering'),
    ),
    DropdownMenuItem(
      value: 'College of Forestry & Environmental Science',
      child: Text('College of Forestry & Environmental Science'),
    ),
    DropdownMenuItem(
      value: 'College of Human Ecology',
      child: Text('College of Human Ecology'),
    ),
    DropdownMenuItem(
      value: 'College of Information Sciences and Computing',
      child: Text('College of Information Sciences and Computing'),
    ),
    DropdownMenuItem(
      value: 'College of Nursing',
      child: Text('College of Nursing'),
    ),
    DropdownMenuItem(
      value: 'College of Veterinary Medicine',
      child: Text('College of Veterinary Medicine'),
    )
  ];
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.mode == Mode.update){
      nameController.text = widget.section!.name!;
      getFirstPrograminCollege(widget.section!.program!);

    } else {
      selectedPrograms.clear();
      setPrograms('College of Agriculture');
    }
  }
  
  void getFirstPrograminCollege(String name){
    final program = Program().fetchProgrambyName(name);
    setPrograms(program.collegeName!);
    setState(() {
      selectedCollege = program.collegeName!;
      selectedProgram = name;
    });

  }

  void setPrograms(String collegeName){
    final prevSelectedProgram = selectedProgram;
    List<DropdownMenuItem<String>> tempList = [];
    final programs = Program().fetchProgramsbyCollege(collegeName);
    for (var program in programs) {
      tempList.add(
          DropdownMenuItem(
              value: program.programName,
              child: Text(program.programName!)
          )
      );
    }
    tempList.add(
        DropdownMenuItem(
            value: selectedProgram,
            child: Text(selectedProgram)
        )
    );
    selectedPrograms.clear();
    setState(() {
      selectedPrograms = tempList;
      selectedProgram = tempList.first.value!;
      selectedPrograms.removeWhere((element) => element.value == prevSelectedProgram);
    });

  }


  void addSection(Section section) async{
    await section.addSection();
    widget.onRefresh();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Section Added!"),
    ));
  }

  void updateSection(Section section) async{
    await section.updateSection();
    widget.onRefresh();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Section Updated!"),
    ));
  }

  void submitSection() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    if(widget.mode == Mode.create){
      addSection(Section(
        name: nameController.text,
        program: selectedProgram,
        college: selectedCollege,
      ));
    } else {
      updateSection(Section(
        college: selectedCollege,
        name: nameController.text,
        program: selectedProgram,
        id: widget.section!.id!
      ));
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child:   Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.mode == Mode.create
                        ? 'Add Section'
                        : 'Update Section',
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
              const SizedBox(height: 25),
              const Text('Section Name:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Section Name start must not be empty';
                  }
                  return null;
                },
                controller: nameController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Section Name'
                ),
              ),
              const SizedBox(height: 25),
              const Text('College:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton(
                  value: selectedCollege,
                  items: colleges,
                  onChanged: (value){
                    setState(() {
                      selectedCollege = value!;
                    });
                    setPrograms(value);
                  }
              ),
              const SizedBox(height: 25),
              const Text('Program:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton(
                  value: selectedProgram,
                  items: selectedPrograms,
                  onChanged: (value){
                    setState(() {
                      selectedProgram = value!;
                    });
                  }
              ),
              const SizedBox(height: 25),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffdae2f3),
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff3b5ba9)
                            )
                        )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: submitSection,
                        child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16
                            )
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

