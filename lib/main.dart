import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DailyHelperToolKit());
}

class DailyHelperToolKit extends StatefulWidget {
  const DailyHelperToolKit({super.key});

  @override
  State<DailyHelperToolKit> createState() => _DailyHelperToolKitState();
}

class _DailyHelperToolKitState extends State<DailyHelperToolKit> {
  Color _themeColor = Colors.indigo;
  String _displayName = "";
  bool _hasUserInfo = false;

  void _updateTheme(Color color) {
    setState(() {
      _themeColor = color;
    });
  }

  void _onUserInfoSubmitted(String name, Color color) {
    setState(() {
      _displayName = name;
      _themeColor = color;
      _hasUserInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _themeColor), useMaterial3: true),
      home: _hasUserInfo
          ? HomeScreen(themeColor: _themeColor, displayName: _displayName, onThemeChange: _updateTheme)
          : WelcomeScreen(onSubmit: _onUserInfoSubmitted),
    );
  }
}

// Welcome Screen so the user can input name and choose a theme
class WelcomeScreen extends StatefulWidget {
  final Function(String, Color) onSubmit;

  const WelcomeScreen({super.key, required this.onSubmit});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Daily Helper Toolkit!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Your Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text("Choose Theme Color"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_colorOption(Colors.indigo), _colorOption(Colors.pink), _colorOption(Colors.orange)],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                String name = _nameController.text.isEmpty ? "User" : _nameController.text;
                widget.onSubmit(name, _selectedColor);
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: CircleAvatar(
        backgroundColor: color,
        child: _selectedColor == color ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}
