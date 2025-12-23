class Language {
  String? loginTitle;
  String? loginSubtitle;
  String? mobilePhone;
  String? loginButton;
  String? loginContactCs1;
  String? loginContactCs2;
  String? loginContactCs3;
  String? termAndCondition;
  String? privacyPolicy;
  String? tncPrivacyConfirmation1;
  String? tncPrivacyConfirmation2;
  String? tncPrivacyConfirmation3;
  String? registerAsNewDriver;
  String? registerTitle;
  String? registerSubtitle;
  String? validateOtpTitle;
  String? validateOtpSubtitle;
  String? resendVerificationCode;
  String? buttonNext;
  String? registerFormTitle;
  String? registerFormDescription;
  String? formTitleIdCardPhoto;
  String? formTitleFullName;
  String? formHintFullName;
  String? formTitleGender;
  String? formHintGender;
  String? formTitleDomicile;
  String? formHintDomicileProvince;
  String? formHintDomicileCity;
  String? formTitleIdCardNumber;
  String? formHintIdCardNumber;
  String? formTitleDrivingStartAt;
  String? formHintDrivingStartAt;
  String? formTitleDriverLicensePhoto;
  String? formTitleService;
  String? motorcycle;
  String? intraCityExpressDelivery;
  String? formTitleLocationService;
  String? formHintLocationService;
  String? formValidationRequired;
  String? formValidationFirst8;
  String? formValidationLengthMin8;
  String? formTitleAvatarPhoto;
  String? registerCompleteTitle;
  String? registerCompleteDescription;
  String? registerCompleteTitle1;
  String? registerCompleteDescription1;
  String? confirmation;
  String? homeOrderToday;
  String? homeOrderThisMonth;
  String? homeMyRating;
  String? homeSeeMyActivity;
  String? homeYourBalance;

  Language({
    this.loginTitle,
    this.loginSubtitle,
    this.mobilePhone,
    this.loginButton,
    this.loginContactCs1,
    this.loginContactCs2,
    this.loginContactCs3,
    this.termAndCondition,
    this.privacyPolicy,
    this.tncPrivacyConfirmation1,
    this.tncPrivacyConfirmation2,
    this.tncPrivacyConfirmation3,
    this.registerAsNewDriver,
    this.registerTitle,
    this.registerSubtitle,
    this.validateOtpTitle,
    this.validateOtpSubtitle,
    this.resendVerificationCode,
    this.buttonNext,
    this.registerFormTitle,
    this.registerFormDescription,
    this.formTitleIdCardPhoto,
    this.formTitleFullName,
    this.formHintFullName,
    this.formTitleGender,
    this.formHintGender,
    this.formTitleDomicile,
    this.formHintDomicileProvince,
    this.formHintDomicileCity,
    this.formTitleIdCardNumber,
    this.formHintIdCardNumber,
    this.formTitleDrivingStartAt,
    this.formHintDrivingStartAt,
    this.formTitleDriverLicensePhoto,
    this.formTitleService,
    this.motorcycle,
    this.intraCityExpressDelivery,
    this.formTitleLocationService,
    this.formHintLocationService,
    this.formValidationRequired,
    this.formValidationFirst8,
    this.formValidationLengthMin8,
    this.formTitleAvatarPhoto,
    this.registerCompleteTitle,
    this.registerCompleteDescription,
    this.registerCompleteTitle1,
    this.registerCompleteDescription1,
    this.confirmation,
    this.homeOrderToday,
    this.homeOrderThisMonth,
    this.homeMyRating,
    this.homeSeeMyActivity,
    this.homeYourBalance,
  });

  Language.fromJson(Map<String, dynamic> json) {
    loginTitle = json['login_title'];
    loginSubtitle = json['login_subtitle'];
    mobilePhone = json['mobile_phone'];
    loginButton = json['login_button'];
    loginContactCs1 = json['login_contact_cs_1'];
    loginContactCs2 = json['login_contact_cs_2'];
    loginContactCs3 = json['login_contact_cs_3'];
    termAndCondition = json['term_and_condition'];
    privacyPolicy = json['privacy_policy'];
    tncPrivacyConfirmation1 = json['tnc_privacy_confirmation_1'];
    tncPrivacyConfirmation2 = json['tnc_privacy_confirmation_2'];
    tncPrivacyConfirmation3 = json['tnc_privacy_confirmation_3'];
    registerAsNewDriver = json['register_as_new_driver'];
    registerTitle = json['register_title'];
    registerSubtitle = json['register_subtitle'];
    validateOtpTitle = json['validate_otp_title'];
    validateOtpSubtitle = json['validate_otp_subtitle'];
    resendVerificationCode = json['resend_verification_code'];
    buttonNext = json['button_next'];
    registerFormTitle = json['register_form_title'];
    registerFormDescription = json['register_form_description'];
    formTitleIdCardPhoto = json['form_title_id_card_photo'];
    formTitleFullName = json['form_title_full_name'];
    formHintFullName = json['form_hint_full_name'];
    formTitleGender = json['form_title_gender'];
    formHintGender = json['form_hint_gender'];
    formTitleDomicile = json['form_title_domicile'];
    formHintDomicileProvince = json['form_hint_domicile_province'];
    formHintDomicileCity = json['form_hint_domicile_city'];
    formTitleIdCardNumber = json['form_title_id_card_number'];
    formHintIdCardNumber = json['form_hint_id_card_number'];
    formTitleDrivingStartAt = json['form_title_driving_start_at'];
    formHintDrivingStartAt = json['form_hint_driving_start_at'];
    formTitleDriverLicensePhoto = json['form_title_driver_license_photo'];
    formTitleService = json['form_title_service'];
    motorcycle = json['motorcycle'];
    intraCityExpressDelivery = json['intra_city_express_delivery'];
    formTitleLocationService = json['form_title_location_service'];
    formHintLocationService = json['form_hint_location_service'];
    formValidationRequired = json['form_validation_required'];
    formValidationFirst8 = json['form_validation_first_8'];
    formValidationLengthMin8 = json['form_validation_length_min_8'];
    formTitleAvatarPhoto = json['form_title_avatar_photo'];
    registerCompleteTitle = json['register_complete_title'];
    registerCompleteDescription = json['register_complete_description'];
    registerCompleteTitle1 = json['register_complete_title_1'];
    registerCompleteDescription1 = json['register_complete_description_1'];
    confirmation = json['confirmation'];
    homeOrderToday = json['home_order_today'];
    homeOrderThisMonth = json['home_order_this_month'];
    homeMyRating = json['home_my_rating'];
    homeSeeMyActivity = json['home_see_my_activity'];
    homeYourBalance = json['home_your_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_title'] = this.loginTitle;
    data['login_subtitle'] = this.loginSubtitle;
    data['mobile_phone'] = this.mobilePhone;
    data['login_button'] = this.loginButton;
    data['login_contact_cs_1'] = this.loginContactCs1;
    data['login_contact_cs_2'] = this.loginContactCs2;
    data['login_contact_cs_3'] = this.loginContactCs3;
    data['term_and_condition'] = this.termAndCondition;
    data['privacy_policy'] = this.privacyPolicy;
    data['tnc_privacy_confirmation_1'] = this.tncPrivacyConfirmation1;
    data['tnc_privacy_confirmation_2'] = this.tncPrivacyConfirmation2;
    data['tnc_privacy_confirmation_3'] = this.tncPrivacyConfirmation3;
    data['register_as_new_driver'] = this.registerAsNewDriver;
    data['register_title'] = this.registerTitle;
    data['register_subtitle'] = this.registerSubtitle;
    data['validate_otp_title'] = this.validateOtpTitle;
    data['validate_otp_subtitle'] = this.validateOtpSubtitle;
    data['resend_verification_code'] = this.resendVerificationCode;
    data['button_next'] = this.buttonNext;
    data['register_form_title'] = this.registerFormTitle;
    data['register_form_description'] = this.registerFormDescription;
    data['form_title_id_card_photo'] = this.formTitleIdCardPhoto;
    data['form_title_full_name'] = this.formTitleFullName;
    data['form_hint_full_name'] = this.formHintFullName;
    data['form_title_gender'] = this.formTitleGender;
    data['form_hint_gender'] = this.formHintGender;
    data['form_title_domicile'] = this.formTitleDomicile;
    data['form_hint_domicile_province'] = this.formHintDomicileProvince;
    data['form_hint_domicile_city'] = this.formHintDomicileCity;
    data['form_title_id_card_number'] = this.formTitleIdCardNumber;
    data['form_hint_id_card_number'] = this.formHintIdCardNumber;
    data['form_title_driving_start_at'] = this.formTitleDrivingStartAt;
    data['form_hint_driving_start_at'] = this.formHintDrivingStartAt;
    data['form_title_driver_license_photo'] = this.formTitleDriverLicensePhoto;
    data['form_title_service'] = this.formTitleService;
    data['motorcycle'] = this.motorcycle;
    data['intra_city_express_delivery'] = this.intraCityExpressDelivery;
    data['form_title_location_service'] = this.formTitleLocationService;
    data['form_hint_location_service'] = this.formHintLocationService;
    data['form_validation_required'] = this.formValidationRequired;
    data['form_validation_first_8'] = this.formValidationFirst8;
    data['form_validation_length_min_8'] = this.formValidationLengthMin8;
    data['form_title_avatar_photo'] = this.formTitleAvatarPhoto;
    data['register_complete_title'] = this.registerCompleteTitle;
    data['register_complete_description'] = this.registerCompleteDescription;
    data['register_complete_title_1'] = this.registerCompleteTitle1;
    data['register_complete_description_1'] = this.registerCompleteDescription1;
    data['confirmation'] = this.confirmation;
    data['home_order_today'] = this.homeOrderToday;
    data['home_order_this_month'] = this.homeOrderThisMonth;
    data['home_my_rating'] = this.homeMyRating;
    data['home_see_my_activity'] = this.homeSeeMyActivity;
    data['home_your_balance'] = this.homeYourBalance;
    return data;
  }
}
