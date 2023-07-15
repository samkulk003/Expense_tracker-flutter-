import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  final amtController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.leisure;

  void presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      selectedDate = pickedDate;
    });
  }

  void submitExpenseData() {
    final enteredAmount =
        double.tryParse(amtController.text); //tryparse('hello')=>null
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('invalid input'),
          content: const Text(
              "please enter valid title , amount ,date and category was entered"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('okay')),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(Expense(
        title: titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        category: selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: titleController,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(labelText: 'title'),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: amtController,
                            //maxLength: 50,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$ ', label: Text('Amount')),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: titleController,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'title'),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map((Category) => DropdownMenuItem(
                                  value: Category,
                                  child: Text(Category.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(selectedDate == null
                                ? 'no date selected'
                                : formatter.format(selectedDate!)),
                            IconButton(
                                onPressed: presentDatePicker,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        )),
                      ],
                    )
                  else
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: amtController,
                          //maxLength: 50,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$ ', label: Text('Amount')),
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
                          Text(selectedDate == null
                              ? 'no date selected'
                              : formatter.format(selectedDate!)),
                          IconButton(
                              onPressed: presentDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ))
                    ]),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('cancel')),
                        ElevatedButton(
                            onPressed: submitExpenseData,
                            child: const Text('save expense'))
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map((Category) => DropdownMenuItem(
                                  value: Category,
                                  child: Text(Category.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('cancel')),
                        ElevatedButton(
                            onPressed: submitExpenseData,
                            child: const Text('save expense'))
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
