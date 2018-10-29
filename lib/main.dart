import 'package:flutter/material.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './user_model.dart';
void main() => runApp(
  StatefulProvider<GlobalBloc>(
    valueBuilder: (BuildContext context, GlobalBloc oldBloc){
      return oldBloc?? GlobalBloc();
    },
  )
);

