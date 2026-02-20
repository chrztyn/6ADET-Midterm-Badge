import 'package:flutter/material.dart';

void main() {
  runApp(const DailyHelperToolkit());
}

class DailyHelperToolkit extends StatelessWidget {
  const DailyHelperToolkit({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

// Abstract Class ToolModule
abstract class ToolModule {
  String get title;
  IconData get icon;
  Widget buildBody(BuildContext context);
}

// Water Intake Tracker
class WaterIntakeTrackerModule extends StatefulWidget implements ToolModule {
  const WaterIntakeTrackerModule({super.key});

  @override
  String get title => "Water Tracker";

  @override
  IconData get icon => Icons.water_drop;

  @override
  State<WaterIntakeTrackerModule> createState() => _WaterIntakeTrackerModuleState();

  @override
  Widget buildBody(BuildContext context) => this;
}

// === ENCAPSULATION ===
class _WaterIntakeTrackerModuleState extends State<WaterIntakeTrackerModule> {
  double _goal = 2000.0;
  double _current = 0.0;
  final List<double> _history = [];

  void _addCup() {
    if (_current + 250.0 > _goal) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Goal already reached!")));
      return;
    }

    setState(() {
      _current += 250.0;
      _history.add(250.0);
    });
  }

  void _reset() {
    setState(() {
      _current = 0.0;
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _goal == 0.0 ? 0.0 : (_current / _goal);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Daily Goal: ${_goal.toInt()} ml", style: const TextStyle(fontSize: 16)),
                  Slider(
                    value: _goal,
                    min: 1000.0,
                    max: 5000.0,
                    divisions: 16,
                    label: "${_goal.toInt()} ml",
                    onChanged: (value) {
                      setState(() {
                        _goal = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Current Intake: ${_current.toInt()} ml", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: progress.clamp(0.0, 1.0), minHeight: 20),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: _addCup, icon: const Icon(Icons.add), label: const Text("Add 250 ml")),
          const SizedBox(height: 10),
          TextButton(onPressed: _reset, child: const Text("Reset")),
          const SizedBox(height: 20),
          const Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.local_drink),
                  title: Text("Cup ${index + 1}"),
                  subtitle: Text("${_history[index].toInt()} ml"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Main Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// HERE ADD YUNG 2ND MINI TOOL

// HERE ADD YUNG 3RD MINI TOOL

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  String _displayName = "User";
  Color _themeColor = Colors.indigo;

  // HERE ADD YUNG IBANG MINI TOOL
  // === POLYMORPHISM ===
  final List<ToolModule> _modules = [
    const WaterIntakeTrackerModule(),
    const WaterIntakeTrackerModule(),
  ]; //Just a placeholder ung pangalawa

  void _openSettings() {
    final controller = TextEditingController(text: _displayName);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
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
                  _colorOption(Colors.indigo),
                  _colorOption(Colors.grey.shade800),
                  _colorOption(Colors.orange),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _displayName = controller.text.isEmpty ? "User" : controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _themeColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        child: _themeColor == color ? const Icon(Icons.check, color: Colors.white) : null,
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
