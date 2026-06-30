import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:new_evmoto_driver/app/utils/dialog_tags.dart';
import 'package:new_evmoto_driver/app/widgets/loading_dialog.dart';

/// Centralized dialog API backed by [flutter_smart_dialog].
///
/// Every dialog must use a [tag] from [DialogTags] so it can be closed
/// precisely with [dismiss] without affecting other overlays.
class DialogHelper {
  DialogHelper._();

  static bool _deferDuringInitialLoad = false;
  static final List<Future<void> Function()> _deferredQueue = [];

  /// Queues [show] calls until [endDeferAndShowQueued] runs.
  ///
  /// Used during the home screen initial load so overlays do not block
  /// [HomeController.isFetch]. Dialogs are shown sequentially in the order
  /// they were requested once loading finishes.
  static void beginDeferDuringInitialLoad() {
    _deferDuringInitialLoad = true;
  }

  static Future<void> endDeferAndShowQueued() async {
    _deferDuringInitialLoad = false;
    final queue = List<Future<void> Function()>.from(_deferredQueue);
    _deferredQueue.clear();
    for (final showTask in queue) {
      await showTask();
    }
  }

  static Future<T?> show<T>({
    required String tag,
    required Widget widget,
    bool barrierDismissible = true,
    bool backDismiss = true,
    bool keepSingle = true,
    bool deferDuringInitialLoad = true,
  }) {
    if (_deferDuringInitialLoad && deferDuringInitialLoad) {
      _deferredQueue.add(
        () => _show<T>(
          tag: tag,
          widget: widget,
          barrierDismissible: barrierDismissible,
          backDismiss: backDismiss,
          keepSingle: keepSingle,
        ),
      );
      return Future<T?>.value(null);
    }

    return _show<T>(
      tag: tag,
      widget: widget,
      barrierDismissible: barrierDismissible,
      backDismiss: backDismiss,
      keepSingle: keepSingle,
    );
  }

  static Future<T?> _show<T>({
    required String tag,
    required Widget widget,
    bool barrierDismissible = true,
    bool backDismiss = true,
    bool keepSingle = true,
  }) {
    return SmartDialog.show<T>(
      tag: tag,
      keepSingle: keepSingle,
      builder: (_) => widget,
      clickMaskDismiss: barrierDismissible,
      backType: backDismiss ? SmartBackType.normal : SmartBackType.block,
    );
  }

  static Future<void> showLoading({String tag = DialogTags.loading}) {
    if (exists(tag)) {
      return Future.value();
    }

    return SmartDialog.show(
      tag: tag,
      keepSingle: true,
      builder: (_) => LoadingDialog(),
      clickMaskDismiss: false,
      backType: SmartBackType.block,
    );
  }

  static void dismiss<T>(String tag, {T? result}) {
    SmartDialog.dismiss<T>(tag: tag, result: result);
  }

  static void dismissIfExists<T>(String tag, {T? result}) {
    if (exists(tag)) {
      dismiss<T>(tag, result: result);
    }
  }

  static bool exists(String tag) => SmartDialog.checkExist(tag: tag);

  static void dismissLoading() => dismiss(DialogTags.loading);

  static bool get isLoadingShowing => exists(DialogTags.loading);

  static void dismissOrderDialogs(String orderId) {
    dismissIfExists(DialogTags.advanceBookingConfirmation(orderId));
    dismissIfExists(DialogTags.orderConfirmation(orderId));
    dismissIfExists(DialogTags.advanceBookingReconfirmation(orderId));
  }
}
