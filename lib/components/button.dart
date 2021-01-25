import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Button extends StatelessWidget {
  Button(
      {@required this.color,
      @required this.label,
      @required this.labelColor,
      this.onPressed,
      @required this.hasIcon});
  final String label;
  final Color color, labelColor;
  final Function onPressed;
  final bool hasIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Material(
        child: MaterialButton(
          padding: EdgeInsets.all(16.0),
          color: color,
          onPressed: onPressed,
          child: (hasIcon)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white38,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(label,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Rajdhani',
                            color: labelColor)),
                  ],
                )
              : Text(label,
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Rajdhani', color: labelColor)),
        ),
      ),
    );
  }
}
