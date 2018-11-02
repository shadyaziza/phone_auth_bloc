import 'package:flutter/material.dart';

class PickerCard extends StatelessWidget {
  final EdgeInsets margin, padding;
  final Color borderColor;
  final String smallText, bigText;
  final VoidCallback onTap;
  final Color cardColor;

  const PickerCard({
    Key key,
    this.cardColor,
    @required this.margin,
    @required this.padding,
    @required this.borderColor,
    @required this.smallText,
    @required this.bigText,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 4,
          minWidth: MediaQuery.of(context).size.width / 4,
          minHeight: MediaQuery.of(context).size.width / 4,
          maxHeight: MediaQuery.of(context).size.width / 4,
        ),
        child: GestureDetector(
          // splashColor: Theme.of(context).buttonColor,
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: borderColor, width: 2.0)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(smallText, textScaleFactor: 0.6),
                    Text(
                      bigText,
                      textScaleFactor: 1.7,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
