import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_notification_model.dart';
import '../services/notifications_service.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) => NotificationsService());

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotificationModel>>(NotificationsNotifier.new);

class NotificationsNotifier extends AsyncNotifier<List<AppNotificationModel>> {
  @override
  Future<List<AppNotificationModel>> build() async {
    return ref.read(notificationsServiceProvider).list();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> toggleRead(AppNotificationModel n) async {
    await ref.read(notificationsServiceProvider).markRead(n.id, !n.isRead);
    await refresh();
  }

  Future<void> clear() async {
    await ref.read(notificationsServiceProvider).clearAll();
    await refresh();
  }
}

