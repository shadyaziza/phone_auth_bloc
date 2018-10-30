import 'package:flutter/widgets.dart';
class ConditionalBuilder extends StatelessWidget {
  final bool condition;
  final Widget trueBuilder;
  final Widget falseBuilder;

  const ConditionalBuilder({Key key,@required this.condition,@required this.trueBuilder, @required this.falseBuilder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return condition?trueBuilder:falseBuilder;
  }
}