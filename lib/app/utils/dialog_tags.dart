/// Stable identifiers for every app dialog.
///
/// Always pass one of these tags to [DialogHelper.show] and close the same
/// dialog with [DialogHelper.dismiss] using the matching tag.
class DialogTags {
  DialogTags._();

  static const loading = 'dialog.loading';

  static const noConnectivity = 'dialog.no_connectivity';

  static const serviceTimeValidation = 'dialog.service_time_validation';

  static const coachmark = 'dialog.coachmark';

  static const appVersionNewest = 'dialog.app_version_newest';
  static const appVersionUpdate = 'dialog.app_version_update';
  static const appSoftUpdate = 'dialog.app_soft_update';
  static const appForceUpdate = 'dialog.app_force_update';

  static const locationPermission = 'dialog.location_permission';

  static const cancelOrder = 'dialog.cancel_order';
  static const advancedBookingCancel = 'dialog.advanced_booking_cancel';

  static const deleteBankAccount = 'dialog.delete_bank_account';
  static const depositBalanceCancel = 'dialog.deposit_balance_cancel';

  static const accountDeletedSuccess = 'dialog.account_deleted_success';

  static const guaranteeIncomeAreaIn = 'dialog.guarantee_income_area_in';
  static const guaranteeIncomeAreaOut = 'dialog.guarantee_income_area_out';

  static String advanceBookingConfirmation(String orderId) =>
      'dialog.advance_booking_confirmation.$orderId';

  static String orderConfirmation(String orderId) =>
      'dialog.order_confirmation.$orderId';

  static String advanceBookingReconfirmation(String orderId) =>
      'dialog.advance_booking_reconfirmation.$orderId';
}
