import 'package:flutter/material.dart';

/// A reusable widget that displays a centered loading spinner.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator());
}
