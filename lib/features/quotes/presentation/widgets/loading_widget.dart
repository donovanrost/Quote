import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      color: Colors.white,
      size: 110.0,
    );
  }
}
