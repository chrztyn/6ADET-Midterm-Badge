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

    double heightMeters;

    if (_heightUnit == "cm") {
      // CM input
      double? cm = double.tryParse(_hController.text.trim());
      if (cm == null || cm <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid height in cm.")),
        );
        return;
      }
      heightMeters = cm / 100;
    } else {
      // Feet input
      String raw = _hController.text.trim();
      List<String> parts = raw.split("'");

      if (parts.length != 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid height in feet (e.g., 5'7)")),
        );
        return;
      }

      double? feet = double.tryParse(parts[0].trim());
      double? inches = double.tryParse(parts[1].trim());

      if (feet == null || inches == null || feet <= 0 || inches < 0 || inches >= 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid feet or inches value.")),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                "BMI Calculator",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Know your body mass index instantly",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 24),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _hController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Height",
                            hintText: "170 or 5'7",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _heightUnit,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: "cm", child: Text("cm")),
                            DropdownMenuItem(value: "feet", child: Text("feet")),
                          ],
                          onChanged: (value) => setState(() => _heightUnit = value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _wController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Weight",
                            hintText: "70 or 154",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _weightUnit,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: "kg", child: Text("kg")),
                            DropdownMenuItem(value: "lbs", child: Text("lbs")),
                          ],
                          onChanged: (value) => setState(() => _weightUnit = value!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          FilledButton(onPressed: _calculate, child: const Text("Calculate BMI")),
          const SizedBox(height: 8),
          TextButton(onPressed: _reset, child: const Text("Clear All")),
          const SizedBox(height: 20),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  Text("Your BMI", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text(
                    _computedValue == 0 ? "—" : _computedValue.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _statusText.isEmpty ? "Health Status" : _statusText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Previous Results",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(_records[index]),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}