import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';

class NewExpanse extends StatefulWidget {
  const NewExpanse({required this.addNewExpense, super.key});

  final void Function(Expense expense) addNewExpense;
  @override
  State<NewExpanse> createState() => _NewExpanseState();
}

class _NewExpanseState extends State<NewExpanse> {
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  Category _selectedCategory = Category.travel;
  DateTime? _selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid Input'),
                content: const Text('Please enter valid data'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay'))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text('Please enter valid data'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay'))
                ],
              ));
    }
  }

  void _submitExpanseData() {
    final enteredCost = double.tryParse(_costController.text);
    final costIsInvalid = (enteredCost == null) || (enteredCost <= 0);
    if ((_titleController.text.trim().isEmpty) ||
        (costIsInvalid) ||
        (_selectedDate == null)) {
      _showDialog();
      return;
    } else {
      widget.addNewExpense(Expense(
          title: _titleController.text,
          amount: enteredCost,
          category: _selectedCategory,
          date: _selectedDate!));
      Navigator.pop(context);
    }
  }

  Widget _portraitMode() {
    return Column(children: [
      TextField(
        controller: _titleController,
        maxLength: 50,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(label: Text('Title')),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(prefixText: '\$ ', label: Text('Cost')),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_selectedDate == null
                  ? 'No date selected'
                  : formatter.format(_selectedDate!)),
              IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.calendar_month))
            ],
          ))
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: [
          DropdownButton(
              value: _selectedCategory,
              items: Category.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCategory = value;
                });
              }),
          const Spacer(),
          TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the bottom sheet
              },
              child: const Text('Exit')),
          ElevatedButton(
              onPressed: _submitExpanseData, child: const Text('Save Expense'))
        ],
      ),
    ]);
  }

  Widget _landscapeMode() {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              maxLength: 50,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(label: Text('Title')),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(prefixText: '\$ ', label: Text('Cost')),
            ),
          ),
        ],
      ),
      Row(
        children: [
          DropdownButton(
              value: _selectedCategory,
              items: Category.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCategory = value;
                });
              }),
          const Spacer(),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_selectedDate == null
                  ? 'No date selected'
                  : formatter.format(_selectedDate!)),
              IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.calendar_month))
            ],
          ))
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: [
          const Spacer(),
          TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the bottom sheet
              },
              child: const Text('Exit')),
          ElevatedButton(
              onPressed: _submitExpanseData, child: const Text('Save Expense'))
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: SingleChildScrollView(
            child: width >= 600 ? _landscapeMode() : _portraitMode(),
          ),
        ),
      );
    });
  }
}
