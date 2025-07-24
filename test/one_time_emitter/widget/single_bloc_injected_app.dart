import 'package:bloc_mixins/src/widget/bloc_one_time_listener.dart';
import 'package:flutter/material.dart';

import '../bloc/ote_bloc.dart';

class SingleBlocInjectedApp extends StatefulWidget {
  final BlocOneTimeWidgetListener<String> listener;

  const SingleBlocInjectedApp({Key? key, required this.listener})
      : super(key: key);

  @override
  State<SingleBlocInjectedApp> createState() => _SingleBlocInjectedAppState();
}

class _SingleBlocInjectedAppState extends State<SingleBlocInjectedApp> {
  late OTEBloc _oteBloc;

  @override
  void initState() {
    super.initState();
    _oteBloc = OTEBloc();
  }

  @override
  void dispose() {
    _oteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocOneTimeListener<OTEBloc, String>(
          bloc: _oteBloc,
          listener: widget.listener,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _oteBloc.add(OTEOpenDialogEvent());
                },
                child: Text('OTEOpenDialogEvent'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _oteBloc = OTEBloc();
                  });
                },
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _oteBloc = _oteBloc;
                  });
                },
                child: Text('Rebuild'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
