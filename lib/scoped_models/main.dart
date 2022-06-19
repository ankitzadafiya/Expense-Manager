import 'package:expense_manager/scoped_models/combined_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with CombinedModel, UserModel, ExpensesModel, FilterModel {} 

