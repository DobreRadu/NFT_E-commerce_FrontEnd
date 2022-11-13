import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

String nume = '';

final mainPageView =
    StateProvider<Widget>((ref) => const Center(child: Text("LOADING...")));
