// ignore_for_file: unnecessary_null_comparison

class SearchProductParam {
  String? word;
  String? branchId;
  String? newProduct;
  String? price;
  String? mainCategory;
  int page = 1;

  SearchProductParam(
      {this.word,
      this.branchId,
      this.newProduct,
      this.price,
      this.mainCategory,
      this.page = 1});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // Always include company_id
    data['company_id'] = "PALM-0006";

    // Add other parameters only if they have meaningful values
    if (word != null && word!.isNotEmpty && word != "null") {
      data['word'] = word;
    }

    if (branchId != null && branchId!.isNotEmpty) {
      data['branch_id'] = branchId;
    } else {
      data['branch_id'] = "PALM-00060001";
    }

    if (newProduct != null && newProduct!.isNotEmpty && newProduct != "null") {
      data['new_product'] = newProduct;
    }

    if (price != null && price!.isNotEmpty && price != "null") {
      data['price'] = price;
    }

    if (mainCategory != null &&
        mainCategory!.isNotEmpty &&
        mainCategory != "null" &&
        mainCategory != "-1") {
      data['main_category'] = mainCategory;
    }

    // Always include page number
    data['page'] = page.toString();

    return data;
  }

  SearchProductParam.fromMap(Map<String, dynamic> map) {
    word = map['word'];
    branchId = map['branch_id'];
    newProduct = map['new_product'];
    price = map['price'];
    mainCategory = map['main_category'];
    page = map['page'];
  }
}
