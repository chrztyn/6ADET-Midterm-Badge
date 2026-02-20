import 'package:flutter/material.dart';
import 'tool_module.dart';

// Grade Calculator Module
class GradeCalculatorModule extends StatefulWidget implements ToolModule {
  const GradeCalculatorModule({super.key});

  @override
  String get title => "Grade Calculator";

  @override
  IconData get icon => Icons.calculate;

  @override
  State<GradeCalculatorModule> createState() => _GradeCalculatorModuleState();

  @override
  Widget buildBody(BuildContext context) => this;
}

class _GradeCalculatorModuleState extends State<GradeCalculatorModule> {
  final List<TextEditingController> _nameControllers = List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _weightControllers = List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _scoreControllers = List.generate(3, (_) => TextEditingController());

  double? _finalGrade;
  void _addComponent() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _weightControllers.add(TextEditingController());
      _scoreControllers.add(TextEditingController());
    });
  }

  void _calculate() {
    double totalWeight = 0;
    double weightedSum = 0;

    for (int i = 0; i < _nameControllers.length; i++) {
      double weight = double.tryParse(_weightControllers[i].text) ?? 0;
      double score = double.tryParse(_scoreControllers[i].text) ?? 0;

      totalWeight += weight;
      weightedSum += (score * weight / 100);
    }

    if (totalWeight != 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Total weight must equal 100%")));
      return;
    }

    setState(() {
      _finalGrade = weightedSum;
    });
  }

  void _reset() {
    setState(() {
      for (var controller in _nameControllers) {
        controller.clear();
      }
      for (var controller in _weightControllers) {
        controller.clear();
      }
      for (var controller in _scoreControllers) {
        controller.clear();
      }
      _finalGrade = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Grade Calculator", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _nameControllers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _nameControllers[index],
                            decoration: InputDecoration(
                              labelText: "Component ${index + 1}",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _weightControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Weight %", border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _scoreControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Score", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton(onPressed: _addComponent, child: const Text("Add Component")),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(onPressed: _calculate, child: const Text("Calculate")),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(onPressed: _reset, child: const Text("Reset")),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _finalGrade == null ? "Final Grade: -" : "Final Grade: ${_finalGrade!.toStringAsFixed(2)}%",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
