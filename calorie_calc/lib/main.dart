import 'package:flutter/material.dart';
import 'package:calorie_calc/views/screens/food_selection_view.dart';
import 'package:calorie_calc/controllers/food_controller.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      
      create: (_) => FoodController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calorie Calculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FoodSelectionView(),
      ),
    );
  }
}
