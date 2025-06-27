//ignore 'deprecated_member_use' for this file
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class MonthlySummary extends StatelessWidget {
  final double monthlyTotal;
  final Map<String, double> categoryTotals;

  // ignore: use_super_parameters
  const MonthlySummary({
    Key? key,
    required this.monthlyTotal,
    required this.categoryTotals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(now);
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    monthName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Monthly total
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // ignore: deprecated_member_use
                      AppTheme.primaryGreen.withOpacity(0.1),
                      // ignore: deprecated_member_use
                      AppTheme.accentTeal.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Monthly Expenses',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PKR ${monthlyTotal.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.getAmountColor(monthlyTotal),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (categoryTotals.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Category Breakdown',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Category totals
                ...categoryTotals.entries.map((entry) {
                  final percentage = monthlyTotal > 0 
                      ? (entry.value / monthlyTotal * 100)
                      : 0.0;
                  final categoryColor = AppTheme.getCategoryColor(entry.key);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PKR ${entry.value.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                // ignore: unnecessary_to_list_in_spreads
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}