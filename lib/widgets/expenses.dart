import 'package:expenses_tracker/widgets/chart/chart.dart';
import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/new_expanses.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'course 1',
        amount: 99.99,
        category: Category.work,
        date: DateTime.now()),
    Expense(
        title: 'coures 2',
        amount: 50,
        category: Category.leisure,
        date: DateTime.now()),
    Expense(
        title: 'coures 3',
        amount: 5.9,
        category: Category.food,
        date: DateTime.now()),
  ];

  void _addExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpanse(addNewExpense: _addNewExpense));
  }

  void _addNewExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeNewExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('${expense.title} Expense deleted'),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(onPressed: _addExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: screenWidth < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                    child: _registeredExpenses.isEmpty
                        ? const Center(child: Text('No Expense found'))
                        : ExpansesList(
                            expenses: _registeredExpenses,
                            deleteExpanses: _removeNewExpense,
                          ))
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                    child: _registeredExpenses.isEmpty
                        ? const Center(child: Text('No Expense found'))
                        : ExpansesList(
                            expenses: _registeredExpenses,
                            deleteExpanses: _removeNewExpense,
                          ))
              ],
            ),
    );
  }
}
