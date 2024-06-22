import 'package:flutter/material.dart';
import 'package:calorie_calc/controllers/food_controller.dart';
import 'package:calorie_calc/models/food_model.dart';
import 'package:calorie_calc/data/food_data.dart';
import 'package:provider/provider.dart';

class FoodSelectionView extends StatefulWidget {
  @override
  _FoodSelectionViewState createState() => _FoodSelectionViewState();
}

class _FoodSelectionViewState extends State<FoodSelectionView> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FoodController>(context);
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Select Foods', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white,),
            onPressed: () {
              controller.clearAll();
            },
          ),
          IconButton(
            icon: Icon(Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              _showSelectedFoodsDialog(context, controller);
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: FoodData.foods.length,
        itemBuilder: (context, index) {
          final food = FoodData.foods[index];
          return GestureDetector(
            onTap: () {
              _showFoodDialog(context, controller, food);
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      food.imagePath,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.name, style: TextStyle(fontSize: 16)),
                        Text('${food.caloriesPerUnit * 100} cal/100g',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Total Calories: ${controller.totalCalories().toStringAsFixed(2)} ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showFoodDialog(
      BuildContext context, FoodController controller, Food food) {
    final TextEditingController _quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(food.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(food.imagePath, height: 100, width: 100),
              SizedBox(height: 10),
              Text('${food.caloriesPerUnit * 100} cal/100g'),
              SizedBox(height: 10),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter weight in grams',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final quantity = double.tryParse(_quantityController.text) ?? 0;
                controller.setQuantity(food, quantity);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showSelectedFoodsDialog(
      BuildContext context, FoodController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selected Foods'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: controller.selectedFoods.entries.map((entry) {
                final food = entry.key;
                final quantity = entry.value;
                final calories = food.caloriesPerUnit * quantity;
                return ListTile(
                  title: Text('${food.name} (${quantity.toStringAsFixed(2)}g)'),
                  subtitle: Text('${calories.toStringAsFixed(2)} calories'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
