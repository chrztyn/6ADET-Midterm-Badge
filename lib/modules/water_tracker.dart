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
    if (_current >= _goal) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Congratulations! You've reached your daily water goal.")),
    );
    }
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                "Water Intake",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Track your hydration today",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 24),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Goal",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${_goal.toInt()} ml",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 20),

                  Text(
                    "Today's Intake",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${_current.toInt()} ml",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 16,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${(progress * 100).clamp(0, 100).toInt()}% of daily goal",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _addCup,
            icon: const Icon(Icons.add),
            label: const Text("Add 250 ml"),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: _reset,
              child: const Text("Reset"),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "History",
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.separated(
              itemCount: _history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.local_drink_outlined),
                  title: Text("Cup ${index + 1}"),
                  subtitle: Text("${_history[index].toInt()} ml"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
