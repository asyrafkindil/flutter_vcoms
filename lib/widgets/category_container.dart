import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryContainer extends StatelessWidget {
  final List<Category> categoryList;
  final onTapCategory;

  CategoryContainer(this.categoryList, this.onTapCategory);

  Widget _categoryCard(Category category) {
    return InkWell(
      onTap: () => onTapCategory(category.id),
      child: Card(
        key: Key(category.id.toString()),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Text(category.name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: categoryList.length > 0
          ? ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _categoryCard(new Category(id: -1, name: 'All'));
          }
          return _categoryCard(categoryList[index - 1]);
        },
      )
          : Container(),
    );
  }
}