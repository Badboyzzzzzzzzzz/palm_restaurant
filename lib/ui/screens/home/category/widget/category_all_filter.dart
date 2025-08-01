// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/models/category/sub_category.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllCategoryFilter extends StatelessWidget {
  final List<SubCategoryModel> subCategories;
  final int selectedCategoryIndex;
  final Function(int) onCategoryIndexSelected;
  final Function(String) onCategoryIdSelected;

  const AllCategoryFilter({
    super.key,
    required this.subCategories,
    required this.selectedCategoryIndex,
    required this.onCategoryIndexSelected,
    required this.onCategoryIdSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subCategories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          final isSelected = selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () {
              onCategoryIndexSelected(index);
              if (subCategory.subId != null && subCategory.subId!.isNotEmpty) {
                onCategoryIdSelected(subCategory.subId!);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated container for the category icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFF5D248),
                                const Color(0xFFFFAA00),
                              ],
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? const Color(0xFFF5D248).withOpacity(0.4)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          spreadRadius: isSelected ? 1 : 0,
                        ),
                      ],
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Container(
                          width: 55,
                          height: 55,
                          padding: EdgeInsets.all(isSelected ? 2 : 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: subCategory.photo != null &&
                                    subCategory.photo!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: subCategory.photo!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: isSelected
                                              ? const Color(0xFFF5D248)
                                              : const Color(0xFFE0E0E0),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFFF5D248)
                                                .withOpacity(0.1)
                                            : const Color(0xFFF5F5F5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.category_outlined,
                                        color: isSelected
                                            ? const Color(0xFFF5D248)
                                            : Colors.grey[400],
                                        size: 24,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFF5D248)
                                              .withOpacity(0.1)
                                          : const Color(0xFFF5F5F5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.category_outlined,
                                      color: isSelected
                                          ? const Color(0xFFF5D248)
                                          : Colors.grey[400],
                                      size: 24,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Category name with indicator
                  Flexible(
                    child: Text(
                      subCategory.subCategoryName ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF391713)
                            : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Animated indicator dot
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 3,
                    width: isSelected ? 25 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5D248),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
