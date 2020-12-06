import 'package:flutter/material.dart';
import 'package:go_to_laser_store/widgets/common/custom_radio_widget.dart';

class TestRadioButton extends StatefulWidget {
  @override
  _TestRadioButtonState createState() => _TestRadioButtonState();
}

class _TestRadioButtonState extends State<TestRadioButton> {
  String _radValue;

  @override
  void initState() {
    _radValue = "initial";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(_radValue),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomRadioWidget(
                  value: "0",
                  groupValue: _radValue,
                  onChanged: (String value) {
                    setState(() {
                      _radValue = value;
                    });
                  },
                ),
                CustomRadioWidget(
                  value: "1",
                  groupValue: _radValue,
                  onChanged: (String value) {
                    setState(() {
                      _radValue = value;
                    });
                  },
                ),
                CustomRadioWidget(
                  value: "2",
                  groupValue: _radValue,
                  onChanged: (String value) {
                    setState(() {
                      _radValue = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
