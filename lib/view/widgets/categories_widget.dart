import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/categories_controller.dart';
import 'package:todo_app/view/dialogs/category_dialog.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Consumer<CategoriesController>(
        builder: (_, controller, __) {
          if (controller.length <= 0) {
            return const Center(
              child: Text('No Record'),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: controller.length,
            itemBuilder: (context, index) {
              final bool isSelected = controller.currentIndex == index;
              return InkWell(
                onLongPress: () => showDialog(
                  context: context,
                  builder: (context) => CategoryDialog.general(
                    context,
                    controller.categoriesList[index].name,
                  ),
                ),
                onTap: () => controller.onChange(index),
                splashColor: Colors.transparent,
                child: Card(
                  color: isSelected ? Colors.deepOrangeAccent : null,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${controller.categoriesList[index].name}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: isSelected ? Colors.white : null),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
