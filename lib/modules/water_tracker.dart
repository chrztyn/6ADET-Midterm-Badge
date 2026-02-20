import 'package:flutter/material.dart';
import 'tool_module.dart';

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
