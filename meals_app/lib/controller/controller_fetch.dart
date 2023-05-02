import 'package:fimber/fimber.dart';
import 'package:get/get.dart';
import 'package:meals_app/services/database_helper.dart';
import '../models/category.dart';


class MyController extends GetxController {
  RxList<Category> categories = RxList<Category>();
  final DBHelper db = DBHelper();

  @override
  void onInit() {
    super.onInit();
    fetchCat();
  }

  fetchCat() async {
    List<Category> data = await db.getAllCategories();
    categories.assignAll(data);
  }

}
