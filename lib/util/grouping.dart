import 'package:fladder/models/item_base_model.dart';

Map<String, List<ItemBaseModel>> groupByName(List<ItemBaseModel> items) {
  Map<String, List<ItemBaseModel>> groupedItems = {};
  for (int i = 0; i < items.length; i++) {
    String firstLetter = items[i].name.replaceAll('The ', '')[0].toUpperCase();
    if (!groupedItems.containsKey(firstLetter)) {
      groupedItems[firstLetter] = [items[i]];
    } else {
      groupedItems[firstLetter]?.add(items[i]);
    }
  }
  return groupedItems;
}
