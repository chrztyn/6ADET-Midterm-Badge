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

// BMI Checker Module
class BmiCheckerModule extends StatefulWidget implements ToolModule {
  const BmiCheckerModule({super.key});

  @override
  String get title => "BMI Checker";

  @override
  IconData get icon => Icons.fitness_center;

  @override
  State<BmiCheckerModule> createState() => _BmiCheckerModuleState();

  @override
  Widget buildBody(BuildContext context) => this;
}

// === ENCAPSULATION ===
class _BmiCheckerModuleState extends State<BmiCheckerModule> {
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _wController = TextEditingController();

  String _heightUnit = "cm"; 
  String _weightUnit = "kg"; 

  double _computedValue = 0;
  String _statusText = "";
  final List<String> _records = [];

  void _calculate() {
    if (_hController.text.trim().isEmpty || _wController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }
    // cm input height
    double heightMeters;
    if (_heightUnit == "cm") {
      double? cm = double.tryParse(_hController.text.trim());
      if (cm == null || cm <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid height in cm.")),
        );
        return;
      }
      heightMeters = cm / 100;
    } else {
      // feet input height
      String raw = _hController.text.trim();
      double feet = 0;
      double inches = 0;

      if (raw.contains("'")) {
        List<String> parts = raw.split("'");
        feet = double.tryParse(parts[0].trim()) ?? -1;
        inches = parts.length > 1 ? double.tryParse(parts[1].trim()) ?? 0 : 0;
      } else {
        feet = double.tryParse(raw) ?? -1;
      }

      if (feet <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid height in feet.")),
        );
        return;
      }

      heightMeters = (feet * 0.3048) + (inches * 0.0254);
    }

    double? weightInput = double.tryParse(_wController.text.trim());
    if (weightInput == null || weightInput <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid weight.")),
      );
      return;
    }

    double weightKg = (_weightUnit == "lbs") ? weightInput * 0.453592 : weightInput;


    double bmi = weightKg / (heightMeters * heightMeters);

    String category;
    if (bmi < 18.5) {
      category = "Underweight";
    } else if (bmi < 25) {
      category = "Normal";
    } else if (bmi < 30) {
      category = "Overweight";
    } else {
      category = "Obese";
    }

    setState(() {
      _computedValue = bmi;
      _statusText = category;
      _records.add("${bmi.toStringAsFixed(2)} - $category");
    });
  }

  void _clearAll() {
    setState(() {
      _hController.clear();
      _wController.clear();
      _computedValue = 0;
      _statusText = "";
      _records.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Column(
              children: [
                const Text(
                  "Body Mass Index Calculator",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Height",
                          border: OutlineInputBorder(),
                          hintText: "Ex: 170 or 5'7",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _heightUnit,
                      items: const [
                        DropdownMenuItem(value: "cm", child: Text("cm")),
                        DropdownMenuItem(value: "feet", child: Text("feet")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _heightUnit = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _wController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Weight",
                          border: OutlineInputBorder(),
                          hintText: "Ex: 70 or 154",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _weightUnit,
                      items: const [
                        DropdownMenuItem(value: "kg", child: Text("kg")),
                        DropdownMenuItem(value: "lbs", child: Text("lbs")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _weightUnit = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _calculate,
            child: const Text("Calculate"),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _clearAll,
            child: const Text("Clear"),
          ),
          const SizedBox(height: 20),
          Text(
            _computedValue == 0
                ? "Result: -"
                : "Result: ${_computedValue.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            _statusText.isEmpty ? "Category: -" : "Category: $_statusText",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Previous Results",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(_records[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// HERE ADD YUNG 3RD MINI TOOL

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  String _displayName = "User";
  Color _themeColor = Colors.indigo;

  // HERE ADD YUNG IBANG MINI TOOL
  // === POLYMORPHISM ===
  final List<ToolModule> _modules = [
    const WaterIntakeTrackerModule(),
    const BmiCheckerModule(),
  ]; 

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
