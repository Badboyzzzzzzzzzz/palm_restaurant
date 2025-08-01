//is_buy_now=&is_recheck_out= , {"address_id: "", "payment_method": "", "branch_id":"", "is_pick_up":"","order_note":""}

class CheckoutParams {
  String? isBuyNow;
  String? isRecheckOut;
  String? addressId;
  String? paymentMethod;
  String? branchId;
  String? isPickUp;
  String? orderNote;

  CheckoutParams(
      {this.isBuyNow,
      this.isRecheckOut,
      this.addressId,
      this.paymentMethod,
      this.branchId,
      this.isPickUp,
      this.orderNote});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    isBuyNow == "0" || isBuyNow == null ? null : data['is_buy_now'] = isBuyNow;
    isRecheckOut == "0" || isRecheckOut == null
        ? null
        : data['is_recheck_out'] = isRecheckOut;
    addressId == null ? null : data['address_id'] = addressId;
    paymentMethod == null ? null : data['paymant_method'] = paymentMethod;
    branchId == null ? null : data['branch_id'] = branchId;
    data['is_pick_up'] = isPickUp; // Always include is_pick_up parameter
    orderNote == null ? null : data['order_note'] = orderNote;

    return data;
  }

  @override
  String toString() {
    return 'CheckoutParams{isBuyNow: $isBuyNow, isRecheckOut: $isRecheckOut, addressId: $addressId, paymentMethod: $paymentMethod, branchId: $branchId, isPickUp: $isPickUp, orderNote: $orderNote}';
  }
}
