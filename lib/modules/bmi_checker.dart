import 'package:flutter/material.dart';
import 'tool_module.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields.")));
      return;
    }
    // cm input height
    double heightMeters;
    if (_heightUnit == "cm") {
      double? cm = double.tryParse(_hController.text.trim());
      if (cm == null || cm <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid height in cm.")));
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid height in feet.")));
        return;
      }

      heightMeters = (feet * 0.3048) + (inches * 0.0254);
    }

    double? weightInput = double.tryParse(_wController.text.trim());
    if (weightInput == null || weightInput <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid weight.")));
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

  void _reset() {
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade100),
            child: Column(
              children: [
                const Text("Body Mass Index Calculator", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
          FilledButton(onPressed: _calculate, child: const Text("Calculate")),
          const SizedBox(height: 8),
          TextButton(onPressed: _reset, child: const Text("Clear")),
          const SizedBox(height: 20),
          Text(
            _computedValue == 0 ? "Result: -" : "Result: ${_computedValue.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            _statusText.isEmpty ? "Category: -" : "Category: $_statusText",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text("Previous Results", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(_records[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}
