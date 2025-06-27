//ignore_for_file: const_types_in_flutter_widgets, unused_local_variable, unused_import, unused_field
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'models/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ExpenseDatabase.instance.database;
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  // ignore: use_super_parameters
  const ExpenseTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}