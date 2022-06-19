
class Category {
  String id;
  String name;
  int iconCode;
  bool show = true;
  
  Category(this.id, this.name, [this.iconCode]);

  Category.fromJson(key, value) {
    id = key;
    name = value["name"];
    iconCode= value["iconCode"];
  }

  void updateVisibility(bool value) {
    show = value;
  }
}
