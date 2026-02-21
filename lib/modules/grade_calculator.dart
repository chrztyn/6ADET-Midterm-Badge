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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                "Grade Calculator",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Compute your weighted final grade easily",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
                child: ListView.builder(
                  itemCount: _nameControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: _nameControllers[index],
                              decoration: InputDecoration(
                                labelText: "Component ${index + 1}",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _weightControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Weight %",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _scoreControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Score",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: FilledButton(
                    onPressed: _addComponent,
                    child: const Text("Add Component"),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: FilledButton(
                    onPressed: _calculate,
                    child: const Text("Calculate"),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: TextButton(
                    onPressed: _reset,
                    child: const Text("Reset"),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Column(
                children: [
                  Text(
                    "Final Grade",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _finalGrade == null
                        ? "—"
                        : "${_finalGrade!.toStringAsFixed(2)}%",
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
