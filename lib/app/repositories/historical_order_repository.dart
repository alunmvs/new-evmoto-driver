import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/bank_model.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/main.dart';

class HistoricalOrderRepository {
  final apiServices = Get.find<ApiServices>();

  Future<List<Bank>> getBankList({int? language}) async {
    try {
      var url = "$baseUrl/driver/base/withdrawal/getBankList";

      var formData = FormData.fromMap({"language": language});

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
      var bankList = <Bank>[];

      for (var bank in response.data['data']) {
        bankList.add(Bank.fromJson(bank));
      }

      return bankList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<BankAccount>> getBankAccountList({
    int? language,
    int? size,
    int? pageNum,
  }) async {
    try {
      var url = "$baseUrl/driver/api/bankCard/queryBankCard";

      var formData = FormData.fromMap({
        "language": language,
        "size": size,
        "pageNum": pageNum,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
      var bankAccountList = <BankAccount>[];

      for (var bankAccount in response.data['data']) {
        bankAccountList.add(BankAccount.fromJson(bankAccount));
      }

      return bankAccountList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> insertBankAccount({
    String? bankCode,
    String? bank,
    String? code,
    String? name,
    int? language,
  }) async {
    try {
      var url = "$baseUrl/driver/api/bankCard/saveBankCard";

      var formData = FormData.fromMap({
        "language": language,
        "bankCode": bankCode,
        "bank": bank,
        "code": code,
        "name": name,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBankAccountById({int? id, int? language}) async {
    try {
      var url = "$baseUrl/driver/api/bankCard/updateBankCard";

      var formData = FormData.fromMap({"language": language, "id": id});

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
