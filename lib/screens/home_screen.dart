//ignore_for_file: const_types_in_flutter_widgets, unused_local_variable, unused_import, unused_field
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/monthly_summary.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/edit_expense_dialog.dart';
import '../widgets/search_filter_bar.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  List<Expense> filteredExpenses = [];
  double monthlyTotal = 0.0;
  Map<String, double> categoryTotals = {};
  String selectedCategory = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final allExpenses = await ExpenseDatabase.instance.getAllExpenses();
      final monthly = await ExpenseDatabase.instance.getMonthlyTotal();
      final categories = await ExpenseDatabase.instance.getCategoryTotals();
      
      setState(() {
        expenses = allExpenses;
        filteredExpenses = allExpenses;
        monthlyTotal = monthly;
        categoryTotals = categories;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage('Error loading data: $e', isError: true);
    }
  }

  void _filterExpenses(String category, DateTimeRange? dateRange) {
    List<Expense> filtered = expenses;
    
    if (category != 'All') {
      filtered = filtered.where((e) => e.category == category).toList();
    }
    
    if (dateRange != null) {
      filtered = filtered.where((e) => 
        e.date.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
        e.date.isBefore(dateRange.end.add(const Duration(days: 1)))
      ).toList();
    }
    
    setState(() {
      filteredExpenses = filtered;
      selectedCategory = category;
    });
  }

  Future<void> _addExpense() async {
    final result = await showDialog<Expense>(
      context: context,
      builder: (context) => const AddExpenseDialog(),
    );
    
    if (result != null) {
      try {
        await ExpenseDatabase.instance.createExpense(result);
        _showMessage('Expense added successfully!');
        _loadData();
      } catch (e) {
        _showMessage('Error adding expense: $e', isError: true);
      }
    }
  }

  Future<void> _editExpense(Expense expense) async {
    final result = await showDialog<Expense>(
      context: context,
      builder: (context) => EditExpenseDialog(expense: expense),
    );
    
    if (result != null) {
      try {
        await ExpenseDatabase.instance.updateExpense(result);
        _showMessage('Expense updated successfully!');
        _loadData();
      } catch (e) {
        _showMessage('Error updating expense: $e', isError: true);
      }
    }
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete "${expense.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expenseRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      try {
        await ExpenseDatabase.instance.deleteExpense(expense.id!);
        _showMessage('Expense deleted successfully!');
        _loadData();
      } catch (e) {
        _showMessage('Error deleting expense: $e', isError: true);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.expenseRed : AppTheme.incomeGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                MonthlySummary(
                  monthlyTotal: monthlyTotal,
                  categoryTotals: categoryTotals,
                ),
                SearchFilterBar(
                  onFilterChanged: _filterExpenses,
                  selectedCategory: selectedCategory,
                ),
                Expanded(
                  child: filteredExpenses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: AppTheme.textLight,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No expenses found',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.textLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to add your first expense',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = filteredExpenses[index];
                            return ExpenseCard(
                              expense: expense,
                              onEdit: () => _editExpense(expense),
                              onDelete: () => _deleteExpense(expense),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExpense,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}