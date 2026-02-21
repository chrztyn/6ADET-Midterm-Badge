# midterm_badge

## Group Number: 1

**Members and Role:**
1. ***Domingo, Jasmeen Clarisse***

	- Role:   QA Tester - Edge case testing, debugging, refinements

2.  ***Lapuz, Mary Micah G.***

	- Role:  UI Developer - Layout structure, spacing, widget styling 

3. ***Payawal, Kyle Eishley G.***

	- Role:  System Architect – Designed app architecture and integrated modules

4. ***Quiambao, Maxene P.***

	- Role: Module Developer – Implemented modules, handled logic and encapsulation

5. ***Yunun, Christine Mae D.***

	- Role:  Module Developer / Project Lead – Implemented modules, managed encapsulation and overall project coordination

## Modules
**1. Water Intake Tracker**
***Features Implemented***
- Adjustable daily goal using **Slider**  
- Add 250ml per tap  
- Prevents exceeding goal  
- LinearProgressIndicator for visual progress  
- History list using ListView  
- SnackBar feedback when goal is reached  
- Reset functionality

**2. BMI Checker**
  ***Features Implemented***
- Height input (cm or feet format like 5'7)  
- Weight input (kg or lbs)  
- Dropdown for unit selection  
- BMI computation  
- Category classification:  
	- Underweight  
	- Normal  
	- Overweight  
	- Obese  
- Result history using ListView  
- SnackBar for invalid input  
- Clear/reset function

**3. Grade Calculator**
  ***Features Implemented***
- Dynamic component list (Add Component button)  
- Input fields for:  
	- Component name  
	- Weight %  
	- Score  
- Validates total weight = 100%  
- Calculates weighted final grade  
- Displays final percentage  
- SnackBar if total weight ≠ 100%  
- Reset functionality

## Features Checklist - What We Implemented
**Core App Features**
-  BottomNavigationBar for switching between 3 tools  
-  Abstract `ToolModule` contract (abstraction)  
-  Polymorphic module list for dynamic rendering  
-  Encapsulated private state in each module  
-  User personalization (display name + theme color)  
-  Greeting message displayed on app  
-  Clean UI layout with proper spacing  
-  Input validation using SnackBar feedback
  
---  
  
**Water Intake Tracker Features**
- Tracks daily water consumption progress.  
- Lets user set a daily water goal  
- Adds 250ml per tap  
- Shows progress visually  
- Prevents exceeding goal  
- Displays intake history
  
---  
  
**BMI Checker Features**
- Calculates Body Mass Index and category.  
- Accepts height and weight (with unit selection)  
- Computes BMI using formula  
- Displays BMI value and category  
- Stores previous results  
- Validates invalid or empty inputs
  
---  
  
**Grade Calculator Features**
- Computes final weighted grade.  
- Allows multiple grade components  
- Accepts weight and score per component  
- Ensures total weight equals 100%  
- Calculates final grade percentage  
- Displays result and allows reset

## How to Run the App

1. Make sure Flutter is installed:

```bash
flutter doctor  
```
**Note:** If it shows the Flutter version and environment info, Flutter is installed correctly.  If not, follow the official Flutter installation guide: https://flutter.dev/docs/get-started/install

2. Navigate to the project folder:
```bash
cd mini_jira_board
```
3. Install dependencies:
```bash
flutter pub get
```
4. Run the app:
```bash
flutter run
```