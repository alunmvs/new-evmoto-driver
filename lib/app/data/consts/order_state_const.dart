class OrderState {
  static const int WAITING_LIST = 1;
  static const int TO_BE_STARTED = 2;
  static const int SCHEDULED_ARRIVAL_PLACE = 3;
  static const int WAIT_FOR_PASSENGERS_TO_BOARD = 4;
  static const int SERVING = 5;
  static const int COMPLETION_SERVICE = 6;
  static const int TO_BE_PAID = 7;
  static const int TO_BE_EVALUATED = 8;
  static const int COMPLETED = 9;
  static const int CANCELLED = 10;
  static const int BEING_REASSIGNED = 11;
  static const int CANCEL_PENDING_PAYMENT = 12;
}
