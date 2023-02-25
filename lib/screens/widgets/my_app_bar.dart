import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final bool isDarkMode;
  final Function(void) goToSettings;
  const MyAppBar(
      {required this.goToSettings, required this.isDarkMode, super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
        height: 30,
      ),

      // set same color as background
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      elevation: 0.0,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          color: isDarkMode ? Colors.white : Colors.black,
          onPressed: () {
            goToSettings(context);
          },
        ),
      ],
    );
  }
}
