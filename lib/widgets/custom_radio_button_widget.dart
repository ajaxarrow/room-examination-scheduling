import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  const CustomRadioButtonWidget(
      {required this.onValueChanged, required this.initialValue, super.key});

  final Function(int) onValueChanged;
  final int initialValue;

  @override
  State<CustomRadioButtonWidget> createState() =>
      _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  Widget customRadioButton(String text, IconData iconData, int index,
      BorderRadius borderRadius, BoxBorder border) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(borderRadius: borderRadius, border: border),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _value = index;
              widget.onValueChanged(_value);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                (_value == index) ? const Color(0xff1660a5) : Colors.white,
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.all(Radius.circular(0)),
              borderRadius: borderRadius,
            ),
            // side: const BorderSide(
            //   color: Colors.grey
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text,
                    style: TextStyle(
                        color:
                            (_value == index) ? Colors.white : Colors.black54)),
                Icon(
                  iconData,
                  color: (_value == index)
                      ? Colors.white
                      : const Color(0xff1660a5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          customRadioButton(
              "Faculty",
              Icons.person_2,
              1,
              const BorderRadius.only(
                  topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              const Border(
                top: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              )),
          customRadioButton(
              "Registrar",
              Icons.person_2,
              2,
              const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              const Border(
                top: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              )),
        ],
      ),
    );
  }
}
