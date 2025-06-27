// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchFilterBar extends StatefulWidget {
  final Function(String category, DateTimeRange? dateRange) onFilterChanged;
  final String selectedCategory;

  // ignore: use_super_parameters
  const SearchFilterBar({
    Key? key,
    required this.onFilterChanged,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  DateTimeRange? selectedDateRange;
  final List<String> categories = ['All', 'Food', 'Transport', 'Entertainment', 'Other'];

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
      widget.onFilterChanged(widget.selectedCategory, selectedDateRange);
    }
  }

  void _clearDateFilter() {
    setState(() {
      selectedDateRange = null;
    });
    widget.onFilterChanged(widget.selectedCategory, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderGray,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Category filter
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Filter by Category:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final isSelected = category == widget.selectedCategory;
                      final categoryColor = category == 'All' 
                          ? AppTheme.primaryGreen
                          : AppTheme.getCategoryColor(category);
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            widget.onFilterChanged(category, selectedDateRange);
                          },
                          backgroundColor: Colors.transparent,
                            selectedColor: categoryColor.withOpacity(0.15),
                          checkmarkColor: categoryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? categoryColor : AppTheme.textLight,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected ? categoryColor : AppTheme.borderGray,
                            width: isSelected ? 2 : 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Date range filter  
          Row(
            children: [
              Icon(
                Icons.date_range,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Date Range:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectDateRange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderGray),
                            borderRadius: BorderRadius.circular(8),
                            color: selectedDateRange != null 
                                ? AppTheme.primaryGreen.withOpacity(0.05)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedDateRange != null
                                      ? '${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - ${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}'
                                      : 'Select date range',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: selectedDateRange != null 
                                        ? AppTheme.textDark
                                        : AppTheme.textLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: selectedDateRange != null 
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (selectedDateRange != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _clearDateFilter,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.expenseRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.clear,
                            size: 16,
                            color: AppTheme.expenseRed,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}