import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/open_city_model.dart';
import 'package:new_evmoto_driver/app/data/models/province_cities_model.dart';
import 'package:new_evmoto_driver/app/modules/register_form/controllers/register_form_controller.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockUploadImageRepository extends Mock implements UploadImageRepository {}

class MockRegisterRepository extends Mock implements RegisterRepository {}

List<ProvinceCities> sampleProvinceCities() => [
  ProvinceCities(
    id: 1,
    name: 'DKI Jakarta',
    child: [Child(id: 10, name: 'Jakarta Selatan')],
  ),
  ProvinceCities(
    id: 2,
    name: 'Jawa Barat',
    child: [Child(id: 20, name: 'Bandung')],
  ),
];

List<OpenCity> sampleOpenCities() => [
  OpenCity(id: 1, name: 'Jakarta', lon: 106.8, lat: -6.2),
];

void stubRegisterRepositoryData(MockRegisterRepository mockRegisterRepository) {
  when(
    () => mockRegisterRepository.getAllProvinceCitiesList(
      language: any(named: 'language'),
    ),
  ).thenAnswer((_) async => sampleProvinceCities());
  when(
    () => mockRegisterRepository.getAllOpenCityList(
      language: any(named: 'language'),
    ),
  ).thenAnswer((_) async => sampleOpenCities());
}

void stubUpdateDriver(MockRegisterRepository mockRegisterRepository) {
  when(
    () => mockRegisterRepository.updateDriver(
      isEcgo: any(named: 'isEcgo'),
      idCardImgUrl1: any(named: 'idCardImgUrl1'),
      idCardImgUrl2: any(named: 'idCardImgUrl2'),
      driveCardImgUrl: any(named: 'driveCardImgUrl'),
      headImgUrl: any(named: 'headImgUrl'),
      idCard: any(named: 'idCard'),
      name: any(named: 'name'),
      sex: any(named: 'sex'),
      password: any(named: 'password'),
      phone: any(named: 'phone'),
      uid: any(named: 'uid'),
      placeOfEmployment: any(named: 'placeOfEmployment'),
      placeOfEmploymentId: any(named: 'placeOfEmploymentId'),
      getDriverLicenseDate: any(named: 'getDriverLicenseDate'),
      language: any(named: 'language'),
      type: any(named: 'type'),
      driverContactAddress: any(named: 'driverContactAddress'),
      driverContactAddress_: any(named: 'driverContactAddress_'),
      usedReferralCode: any(named: 'usedReferralCode'),
      licensePlate: any(named: 'licensePlate'),
      selfieWithIdCardImg: any(named: 'selfieWithIdCardImg'),
      skckImg: any(named: 'skckImg'),
      stnkBackImg: any(named: 'stnkBackImg'),
      stnkFrontImg: any(named: 'stnkFrontImg'),
      networkCarlssueImg: any(named: 'networkCarlssueImg'),
    ),
  ).thenAnswer((_) async {});
}

void fillValidRegisterForm(RegisterFormController controller) {
  controller.provinceCitiesList.value = sampleProvinceCities();
  controller.openCityList.value = sampleOpenCities();
  controller.formGroup.control('full_name').value = 'John Doe';
  controller.formGroup.control('gender_id').value = 1;
  controller.formGroup.control('domicile_province').value = 1;
  controller.formGroup.control('domicile_city').value = 10;
  controller.formGroup.control('identity_number').value = '1234567890123456';
  controller.formGroup.control('driving_experience').value = '2020-01-01';
  controller.formGroup.control('service_type_motorcycle').value = true;
  controller.formGroup.control('is_ecgo_driver').value = false;
  controller.formGroup.control('place_of_employment_id').value = 1;
  controller.formGroup.control('license_plate').value = 'B1234ABC';
  controller.idPhotoUrl.value = 'id-photo-url';
  controller.drivingLicensePhotoUrl.value = 'license-photo-url';
  controller.avatarPhotoUrl.value = 'avatar-photo-url';
  controller.vehicleRegistrationCertificateFrontPhotoUrl.value =
      'stnk-front-url';
  controller.vehicleRegistrationCertificateBackPhotoUrl.value =
      'stnk-back-url';
  controller.driverSelfieKtpPhotoUrl.value = 'selfie-url';
  controller.uid.value = 'test-uid';
  controller.mobilePhone.value = '8123456789';
  controller.isECGODriver.value = false;
  controller.placeOfEmployment.value = 'Jakarta';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterFormController', () {
    late RegisterFormController controller;
    late MockUploadImageRepository mockUploadImageRepository;
    late MockRegisterRepository mockRegisterRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockUploadImageRepository = MockUploadImageRepository();
      mockRegisterRepository = MockRegisterRepository();
      stubRegisterRepositoryData(mockRegisterRepository);
      controller = RegisterFormController(
        uploadImageRepository: mockUploadImageRepository,
        registerRepository: mockRegisterRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with empty photo urls and valid form flag',
      () {
        expect(controller.isFormValid.value, isTrue);
        expect(controller.isFetch.value, isFalse);
        expect(controller.uid.value, '');
        expect(controller.mobilePhone.value, '');
        expect(controller.idPhotoUrl.value, '');
        expect(controller.drivingLicensePhotoUrl.value, '');
        expect(controller.avatarPhotoUrl.value, '');
        expect(controller.formGroup.valid, isFalse);
      },
    );

    test(
      'onInit should read uid and mobile_phone from arguments and load data',
      () async {
        Get.testMode = true;
        Get.routing.args = {
          'uid': 'test-uid',
          'mobile_phone': '8123456789',
        };

        await controller.onInit();

        expect(controller.uid.value, 'test-uid');
        expect(controller.mobilePhone.value, '8123456789');
        expect(controller.isFetch.value, isFalse);
        expect(controller.provinceCitiesList.length, 2);
        expect(controller.openCityList.length, 1);
        verify(
          () => mockRegisterRepository.getAllProvinceCitiesList(language: 2),
        ).called(1);
        verify(
          () => mockRegisterRepository.getAllOpenCityList(language: 2),
        ).called(1);
      },
    );

    test(
      'onInit should default uid and mobile phone to empty when arguments missing',
      () async {
        Get.testMode = true;
        Get.routing.args = <String, dynamic>{};

        await controller.onInit();

        expect(controller.uid.value, '');
        expect(controller.mobilePhone.value, '');
        expect(controller.isFetch.value, isFalse);
      },
    );

    test(
      'getProvinceCitiesList should populate provinceCitiesList from repository',
      () async {
        await controller.getProvinceCitiesList();

        expect(controller.provinceCitiesList.length, 2);
        expect(controller.provinceCitiesList.first.name, 'DKI Jakarta');
      },
    );

    test(
      'getOpenCityList should populate openCityList from repository',
      () async {
        await controller.getOpenCityList();

        expect(controller.openCityList.length, 1);
        expect(controller.openCityList.first.name, 'Jakarta');
      },
    );

    test(
      'refreshCityList should populate cities and reset domicile city',
      () {
        controller.provinceCitiesList.value = sampleProvinceCities();
        controller.formGroup.control('domicile_city').value = 99;

        controller.refreshCityList(provinceId: 1);

        expect(controller.citiesList.length, 1);
        expect(controller.citiesList.first.name, 'Jakarta Selatan');
        expect(controller.formGroup.control('domicile_city').value, isNull);
      },
    );

    test(
      'generateDriverContactAddress should join province and city names',
      () {
        controller.provinceCitiesList.value = sampleProvinceCities();
        controller.formGroup.control('domicile_province').value = 1;
        controller.formGroup.control('domicile_city').value = 10;

        expect(
          controller.generateDriverContactAddress(),
          'DKI JakartaJakarta Selatan',
        );
      },
    );

    test(
      'generateDriverContactAddress_ should join province and city with comma',
      () {
        controller.provinceCitiesList.value = sampleProvinceCities();
        controller.formGroup.control('domicile_province').value = 1;
        controller.formGroup.control('domicile_city').value = 10;

        expect(
          controller.generateDriverContactAddress_(),
          'DKI Jakarta,Jakarta Selatan',
        );
      },
    );

    test(
      'generateType should return motorcycle type when selected',
      () {
        controller.formGroup.control('service_type_motorcycle').value = true;
        controller.formGroup.control('service_type_city_express_delivery')
            .value = false;

        expect(controller.generateType(), '1');
      },
    );

    test(
      'generateType should return city express type when selected',
      () {
        controller.formGroup.control('service_type_motorcycle').value = false;
        controller.formGroup.control('service_type_city_express_delivery')
            .value = true;

        expect(controller.generateType(), '4');
      },
    );

    test(
      'generateType should return both types when both are selected',
      () {
        controller.formGroup.control('service_type_motorcycle').value = true;
        controller.formGroup.control('service_type_city_express_delivery')
            .value = true;

        expect(controller.generateType(), '1,4');
      },
    );

    test(
      'generateType should return empty string when no service type selected',
      () {
        controller.formGroup.control('service_type_motorcycle').value = false;
        controller.formGroup.control('service_type_city_express_delivery')
            .value = false;

        expect(controller.generateType(), '');
      },
    );

    test(
      'onTapSubmit should mark form invalid when required data is missing',
      () async {
        await controller.onTapSubmit();

        expect(controller.isFormValid.value, isFalse);
        verifyNever(
          () => mockRegisterRepository.updateDriver(
            isEcgo: any(named: 'isEcgo'),
            idCardImgUrl1: any(named: 'idCardImgUrl1'),
            idCardImgUrl2: any(named: 'idCardImgUrl2'),
            driveCardImgUrl: any(named: 'driveCardImgUrl'),
            headImgUrl: any(named: 'headImgUrl'),
            idCard: any(named: 'idCard'),
            name: any(named: 'name'),
            sex: any(named: 'sex'),
            password: any(named: 'password'),
            phone: any(named: 'phone'),
            uid: any(named: 'uid'),
            placeOfEmployment: any(named: 'placeOfEmployment'),
            placeOfEmploymentId: any(named: 'placeOfEmploymentId'),
            getDriverLicenseDate: any(named: 'getDriverLicenseDate'),
            language: any(named: 'language'),
            type: any(named: 'type'),
            driverContactAddress: any(named: 'driverContactAddress'),
            driverContactAddress_: any(named: 'driverContactAddress_'),
            usedReferralCode: any(named: 'usedReferralCode'),
            licensePlate: any(named: 'licensePlate'),
            selfieWithIdCardImg: any(named: 'selfieWithIdCardImg'),
            skckImg: any(named: 'skckImg'),
            stnkBackImg: any(named: 'stnkBackImg'),
            stnkFrontImg: any(named: 'stnkFrontImg'),
            networkCarlssueImg: any(named: 'networkCarlssueImg'),
          ),
        );
      },
    );

    testWidgets(
      'onTapSubmit should update driver and navigate to completed screen',
      (WidgetTester tester) async {
        stubUpdateDriver(mockRegisterRepository);
        fillValidRegisterForm(controller);

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SizedBox()),
              GetPage(
                name: Routes.REGISTER_FORM_COMPLETED,
                page: () => const Scaffold(body: Text('Completed')),
              ),
            ],
          ),
        );

        await controller.onTapSubmit();
        await tester.pumpAndSettle();

        expect(Get.currentRoute, Routes.REGISTER_FORM_COMPLETED);
        verify(
          () => mockRegisterRepository.updateDriver(
            isEcgo: 0,
            idCardImgUrl1: 'id-photo-url',
            idCardImgUrl2: '',
            driveCardImgUrl: 'license-photo-url',
            headImgUrl: 'avatar-photo-url',
            idCard: '1234567890123456',
            name: 'John Doe',
            sex: 1,
            password: any(named: 'password'),
            phone: '628123456789',
            uid: 'test-uid',
            placeOfEmployment: 'Jakarta',
            placeOfEmploymentId: 1,
            getDriverLicenseDate: '2020-01-01',
            language: 2,
            type: '1',
            driverContactAddress: 'DKI JakartaJakarta Selatan',
            driverContactAddress_: 'DKI Jakarta,Jakarta Selatan',
            usedReferralCode: any(named: 'usedReferralCode'),
            licensePlate: 'B1234ABC',
            selfieWithIdCardImg: 'selfie-url',
            skckImg: any(named: 'skckImg'),
            stnkBackImg: 'stnk-back-url',
            stnkFrontImg: 'stnk-front-url',
            networkCarlssueImg: any(named: 'networkCarlssueImg'),
          ),
        ).called(1);
      },
    );

    test(
      'onTapSubmit should not throw when repository fails',
      () async {
        when(
          () => mockRegisterRepository.updateDriver(
            isEcgo: any(named: 'isEcgo'),
            idCardImgUrl1: any(named: 'idCardImgUrl1'),
            idCardImgUrl2: any(named: 'idCardImgUrl2'),
            driveCardImgUrl: any(named: 'driveCardImgUrl'),
            headImgUrl: any(named: 'headImgUrl'),
            idCard: any(named: 'idCard'),
            name: any(named: 'name'),
            sex: any(named: 'sex'),
            password: any(named: 'password'),
            phone: any(named: 'phone'),
            uid: any(named: 'uid'),
            placeOfEmployment: any(named: 'placeOfEmployment'),
            placeOfEmploymentId: any(named: 'placeOfEmploymentId'),
            getDriverLicenseDate: any(named: 'getDriverLicenseDate'),
            language: any(named: 'language'),
            type: any(named: 'type'),
            driverContactAddress: any(named: 'driverContactAddress'),
            driverContactAddress_: any(named: 'driverContactAddress_'),
            usedReferralCode: any(named: 'usedReferralCode'),
            licensePlate: any(named: 'licensePlate'),
            selfieWithIdCardImg: any(named: 'selfieWithIdCardImg'),
            skckImg: any(named: 'skckImg'),
            stnkBackImg: any(named: 'stnkBackImg'),
            stnkFrontImg: any(named: 'stnkFrontImg'),
            networkCarlssueImg: any(named: 'networkCarlssueImg'),
          ),
        ).thenThrow(Exception('Update failed'));
        fillValidRegisterForm(controller);

        await expectLater(controller.onTapSubmit(), completes);
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );
  });
}
