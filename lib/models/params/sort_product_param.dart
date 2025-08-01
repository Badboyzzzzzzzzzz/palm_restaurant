class SortProductParam {
  String? mainCategoryId;
  String? branchId;
  String? sort;
  int? page;
  int? price;

  SortProductParam({
    this.mainCategoryId,
    this.branchId,
    this.sort,
    this.page = 1,
    this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (mainCategoryId != null) {
      data['main_category_id'] = mainCategoryId == "-1" || mainCategoryId == "null" || mainCategoryId == "" ? "" : mainCategoryId;
    }
    if (branchId != null) {
      data['branch_id'] = branchId;
    }
    if (sort != null) {
      data['sort'] = sort;
    }
    if (page != null) {
      data['page'] = page;
    }
    if (price != null) {
      data['price'] = price;
    }

    return data;
  }

  // tojson

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (mainCategoryId != null) {
      data['main_category_id'] = mainCategoryId == "-1" || mainCategoryId == "null" || mainCategoryId == "" ? "" : mainCategoryId;
    }
    if (branchId != null) {
      data['branch_id'] = branchId;
    }
    if (sort != null) {
      data['sort'] = sort;
    }
    if (page != null) {
      data['page'] = page;
      // data['page'] = 1;
    }
    if (price != null) {
      data['price'] = price;
    }

    return data;
  }
}