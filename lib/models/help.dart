class HelpModel {
  ContactUs? contactUs;
  AboutUs? aboutUs;
  TermCondition? termCondition;
  PolicyPracy? policyPracy;
  ReturnPolicy? returnPolicy;
  ArticalCategories? articalCategories;

  HelpModel(
      {this.contactUs,
        this.aboutUs,
        this.termCondition,
        this.policyPracy,
        this.returnPolicy,
        this.articalCategories});

  HelpModel.fromJson(Map<String, dynamic> json) {
    contactUs = json['contact_us'] != null
          ? ContactUs.fromJson(json['contact_us'])
        : null;
    aboutUs = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;
    termCondition = json['term_condition'] != null
        ? TermCondition.fromJson(json['term_condition'])
        : null;
    policyPracy = json['Policy_Pracy'] != null
        ? PolicyPracy.fromJson(json['Policy_Pracy'])
        : null;
    returnPolicy = json['Return_Policy'] != null
        ? ReturnPolicy.fromJson(json['Return_Policy'])
        : null;
    articalCategories = json['artical_categories'] != null
        ? ArticalCategories.fromJson(json['artical_categories'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contactUs != null) {
      data['contact_us'] = contactUs!.toJson();
    }
    if (aboutUs != null) {
      data['about_us'] = aboutUs!.toJson();
    }
    if (termCondition != null) {
      data['term_condition'] = termCondition!.toJson();
    }
    if (policyPracy != null) {
      data['Policy_Pracy'] = policyPracy!.toJson();
    }
    if (returnPolicy != null) {
      data['Return_Policy'] = returnPolicy!.toJson();
    }
    if (articalCategories != null) {
      data['artical_categories'] = articalCategories!.toJson();
    }
    return data;
  }
}

class ContactUs {
  String? photo;
  String? stayWithus;
  String? address;
  String? phone;
  String? latitude;
  String? longitude;
  String? website;
  String? facebook;
  String? instagram;
  String? youtube;
  String? email;
  String? branchEn;
  String? telegram;

  ContactUs(
      {this.photo,
        this.stayWithus,
        this.address,
        this.phone,
        this.latitude,
        this.longitude,
        this.website,
        this.facebook,
        this.instagram,
        this.youtube,
        this.email,
        this.branchEn,
        this.telegram});

  ContactUs.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    stayWithus = json['stay_withus'];
    address = json['address'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    website = json['website'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    email = json['email'];
    branchEn = json['branch_en'];
    telegram = json['telegram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['stay_withus'] = stayWithus;
    data['address'] = address;
    data['phone'] = phone;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['website'] = website;
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['email'] = email;
    data['branch_en'] = branchEn;
    data['telegram'] = telegram;
    return data;
  }
}

class AboutUs {
  String? photo;
  String? whoWeare;
  String? ourMission;
  String? photoMission;
  String? ourVission;
  String? photoVission;

  AboutUs(
      {this.photo,
        this.whoWeare,
        this.ourMission,
        this.photoMission,
        this.ourVission,
        this.photoVission});

  AboutUs.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    whoWeare = json['who_weare'];
    ourMission = json['our_mission'];
    photoMission = json['photo_mission'];
    ourVission = json['our_vission'];
    photoVission = json['photo_vission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['who_weare'] = whoWeare;
    data['our_mission'] = ourMission;
    data['photo_mission'] = photoMission;
    data['our_vission'] = ourVission;
    data['photo_vission'] = photoVission;
    return data;
  }
}

class TermCondition {
  String? photo;
  String? termCondition;

  TermCondition({this.photo, this.termCondition});

  TermCondition.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    termCondition = json['term_condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['term_condition'] = termCondition;
    return data;
  }
}

class PolicyPracy {
  String? photo;
  String? policyPracy;

  PolicyPracy({this.photo, this.policyPracy});

  PolicyPracy.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    policyPracy = json['Policy_Pracy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['Policy_Pracy'] = policyPracy;
    return data;
  }
}

class ReturnPolicy {
  String? photo;
  String? returnPolicy;

  ReturnPolicy({this.photo, this.returnPolicy});

  ReturnPolicy.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    returnPolicy = json['Return_Policy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['Return_Policy'] = returnPolicy;
    return data;
  }
}

class ArticalCategories {
  String? documentation;
  String? paywithwing;
  String? paybyoffline;
  String? paywithpipay;

  ArticalCategories(
      {this.documentation,
        this.paywithwing,
        this.paybyoffline,
        this.paywithpipay});

  ArticalCategories.fromJson(Map<String, dynamic> json) {
    documentation = json['documentation'];
    paywithwing = json['paywithwing'];
    paybyoffline = json['paybyoffline'];
    paywithpipay = json['paywithpipay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentation'] = documentation;
    data['paywithwing'] = paywithwing;
    data['paybyoffline'] = paybyoffline;
    data['paywithpipay'] = paywithpipay;
    return data;
  }
}
