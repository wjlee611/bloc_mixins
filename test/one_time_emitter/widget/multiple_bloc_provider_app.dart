import 'package:bloc_mixins/src/widget/bloc_one_time_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ote_bloc.dart';

class MultipleBlocProviderApp extends StatefulWidget {
  final BlocOneTimeWidgetListener<String> listener;

  const MultipleBlocProviderApp({Key? key, required this.listener})
      : super(key: key);

  @override
  State<MultipleBlocProviderApp> createState() =>
      _MultipleBlocProviderAppState();
}

class _MultipleBlocProviderAppState extends State<MultipleBlocProviderApp> {
  int _currentIndex = 0;
  final List<OTEBloc> _blocs = [];

  @override
  void initState() {
    super.initState();
    _blocs.addAll([OTEBloc(), OTEBloc(), OTEBloc()]);
  }

  @override
  void dispose() {
    for (final bloc in _blocs) {
      bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            BlocProvider.value(
              value: _blocs[_currentIndex],
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      BlocOneTimeListener<OTEBloc, String>(
                        listener: widget.listener,
                        child: const SizedBox(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<OTEBloc>().add(OTEOpenDialogEvent());
                        },
                        child: const Text('Trigger Current Bloc Event'),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: const Text('Use Bloc 1'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: const Text('Use Bloc 2'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: const Text('Use Bloc 3'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
