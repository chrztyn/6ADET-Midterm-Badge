import 'package:flutter/material.dart';
import '../modules/tool_module.dart';
import '../modules/water_tracker.dart';
import '../modules/bmi_checker.dart';
import '../modules/grade_calculator.dart';

// Main Screen
class HomeScreen extends StatefulWidget {
  final Color themeColor;
  final String displayName;
  final Function(Color) onThemeChange;

  const HomeScreen({super.key, required this.themeColor, required this.displayName, required this.onThemeChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late String _displayName;
  late Color _themeColor;

  // === POLYMORPHISM ===
  final List<ToolModule> _modules = [
    const WaterIntakeTrackerModule(),
    const BmiCheckerModule(),
    const GradeCalculatorModule(),
  ];

  @override
  void initState() {
    super.initState();
    _displayName = widget.displayName;
    _themeColor = widget.themeColor;
  }

  void _openSettings() {
    final TextEditingController controller = TextEditingController(text: _displayName);
    Color selectedColor = _themeColor;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Personalize App"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: "Your Name"),
              ),
              const SizedBox(height: 20),
              const Text("Choose Theme Color"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _colorOption(Colors.indigo, selectedColor, (color) => setStateDialog(() => selectedColor = color)),
                  _colorOption(Colors.pink, selectedColor, (color) => setStateDialog(() => selectedColor = color)),
                  _colorOption(Colors.orange, selectedColor, (color) => setStateDialog(() => selectedColor = color)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _displayName = controller.text.isEmpty ? "User" : controller.text;
                  _themeColor = selectedColor;
                  widget.onThemeChange(_themeColor);
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color, Color selectedColor, Function(Color) onSelect) {
    return GestureDetector(
      onTap: () => setState(() => onSelect(color)),
      child: CircleAvatar(
        backgroundColor: color,
        child: selectedColor == color ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, $_displayName"),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _openSettings)],
      ),
      body: _modules[_currentIndex].buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _themeColor,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _modules.map((module) => BottomNavigationBarItem(icon: Icon(module.icon), label: module.title)).toList(),
      ),
    );
  }
}
