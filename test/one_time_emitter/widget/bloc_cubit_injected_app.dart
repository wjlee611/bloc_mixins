import 'package:bloc_mixins/src/widget/bloc_one_time_listener.dart';
import 'package:bloc_mixins/src/widget/multi_bloc_one_time_listener.dart';
import 'package:flutter/material.dart';

import '../bloc/ote_bloc.dart';
import '../bloc/ote_cubit.dart';

class BlocCubitInjectedApp extends StatefulWidget {
  final BlocOneTimeWidgetListener<String> blocListener;
  final BlocOneTimeWidgetListener<String> cubitListener;

  const BlocCubitInjectedApp({
    Key? key,
    required this.blocListener,
    required this.cubitListener,
  }) : super(key: key);

  @override
  State<BlocCubitInjectedApp> createState() => _BlocCubitInjectedAppState();
}

class _BlocCubitInjectedAppState extends State<BlocCubitInjectedApp> {
  late OTEBloc _oteBloc;
  late OTECubit _oteCubit;

  @override
  void initState() {
    super.initState();
    _oteBloc = OTEBloc();
    _oteCubit = OTECubit();
  }

  @override
  void dispose() {
    _oteBloc.close();
    _oteCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocOneTimeListener(
          listeners: [
            BlocOneTimeListener<OTEBloc, String>(
              bloc: _oteBloc,
              listener: widget.blocListener,
            ),
            BlocOneTimeListener<OTECubit, String>(
              bloc: _oteCubit,
              listener: widget.cubitListener,
            ),
          ],
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _oteBloc.add(OTEOpenDialogEvent());
                  _oteCubit.openDialog();
                },
                child: Text('OTEOpenDialogEvent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
