import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/open_city_model.dart';
import 'package:new_evmoto_driver/app/data/models/province_cities_model.dart';
import 'package:new_evmoto_driver/app/modules/register_form/controllers/register_form_controller.dart';
import 'package:new_evmoto_driver/app/modules/register_form/views/register_form_view.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockUploadImageRepository extends Mock implements UploadImageRepository {}

class MockRegisterRepository extends Mock implements RegisterRepository {}

Language registerFormTestLanguage() => Language(
  registerFormTitle: 'Register Form',
  registerFormDescription: 'Complete your driver profile',
  formTitleIdCardPhoto: 'ID Card Photo',
  formTitleFullName: 'Full Name',
  formTitleGender: 'Gender',
  formTitleDomicile: 'Domicile',
  formTitleIdCardNumber: 'ID Card Number',
  formTitleDrivingStartAt: 'Driving Experience',
  formTitleDriverLicensePhoto: 'Driver License Photo',
  formTitleService: 'Service Type',
  formTitleLocationService: 'Service Location',
  formTitleAvatarPhoto: 'Avatar Photo',
  formValidationRequired: 'Required',
  buttonNext: 'Next',
);

List<ProvinceCities> sampleProvinceCities() => [
  ProvinceCities(
    id: 1,
    name: 'DKI Jakarta',
    child: [Child(id: 10, name: 'Jakarta Selatan')],
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterFormView', () {
    late RegisterFormController controller;
    late MockUploadImageRepository mockUploadImageRepository;
    late MockRegisterRepository mockRegisterRepository;

    Future<void> waitForRegisterFormFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const RegisterFormView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: registerFormTestLanguage(),
      );
      mockUploadImageRepository = MockUploadImageRepository();
      mockRegisterRepository = MockRegisterRepository();
      stubRegisterRepositoryData(mockRegisterRepository);
      Get.testMode = true;
      Get.routing.args = {
        'uid': 'test-uid',
        'mobile_phone': '8123456789',
      };
      controller = RegisterFormController(
        uploadImageRepository: mockUploadImageRepository,
        registerRepository: mockRegisterRepository,
      );
      Get.put<RegisterFormController>(controller);
      await controller.onInit();
      await waitForRegisterFormFetch();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders register form screen content', (tester) async {
      await pumpView(tester);

      expect(find.text('Register Form'), findsOneWidget);
      expect(find.text('Complete your driver profile'), findsOneWidget);
      expect(find.text('ID Card Photo'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(ReactiveForm), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching data', (tester) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Register Form'), findsNothing);
    });

    testWidgets(
      'shows required validation messages when form is invalid',
      (tester) async {
        controller.isFormValid.value = false;

        await pumpView(tester);

        expect(find.text('Required'), findsWidgets);
      },
    );

    testWidgets('enables next button on submit action', (tester) async {
      await pumpView(tester);

      final nextButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Next'),
      );
      expect(nextButton.onPressed, isNotNull);
    });
  });
}
