import 'package:flutter/material.dart';
import './global_bloc.dart';
import './state_provider.dart';

import 'root.dart';

void main() => runApp(StatefulProvider<GlobalBloc>(
      valueBuilder: (BuildContext context, GlobalBloc oldBloc) =>
          oldBloc ?? GlobalBloc(),
          onDispose: (BuildContext context,GlobalBloc bloc)=>bloc.dispose(),
      child: Root(),
    ));
