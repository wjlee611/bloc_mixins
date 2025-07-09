import 'package:bloc_mixins/bloc_mixins.dart';
import 'package:flutter/material.dart';

class RegisteredBlocsCounter extends StatefulWidget {
  const RegisteredBlocsCounter({super.key});

  @override
  State<RegisteredBlocsCounter> createState() => _RegisteredBlocsCounterState();
}

class _RegisteredBlocsCounterState extends State<RegisteredBlocsCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = BlocResetRegistry.registeredBlocCount;
  }

  void _updateCount() {
    setState(() {
      count = BlocResetRegistry.registeredBlocCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _updateCount,
      label: Text('Reset Registered Blocs: $count'),
      icon: const Icon(Icons.refresh),
    );
  }
}
