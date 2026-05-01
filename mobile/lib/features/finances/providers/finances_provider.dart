import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/finance_bill_model.dart';
import '../services/finances_service.dart';

final financesServiceProvider = Provider<FinancesService>((ref) => FinancesService());

final financesStatusFilterProvider = NotifierProvider<FinancesStatusFilterNotifier, String?>(
  FinancesStatusFilterNotifier.new,
);

class FinancesStatusFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null; // pending|paid|null

  void set(String? v) => state = v;
}

final financesCategoryFilterProvider = NotifierProvider<FinancesCategoryFilterNotifier, String?>(
  FinancesCategoryFilterNotifier.new,
);

class FinancesCategoryFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? v) => state = v;
}

final financesSummaryProvider = AsyncNotifierProvider<FinancesSummaryNotifier, Map<String, dynamic>>(
  FinancesSummaryNotifier.new,
);

class FinancesSummaryNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    return ref.read(financesServiceProvider).summary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final billsProvider = AsyncNotifierProvider<BillsNotifier, List<FinanceBillModel>>(
  BillsNotifier.new,
);

class BillsNotifier extends AsyncNotifier<List<FinanceBillModel>> {
  @override
  Future<List<FinanceBillModel>> build() async {
    final status = ref.watch(financesStatusFilterProvider);
    final category = ref.watch(financesCategoryFilterProvider);
    return ref.read(financesServiceProvider).list(status: status, category: category);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> togglePaid(FinanceBillModel bill) async {
    final next = bill.status == 'paid' ? 'pending' : 'paid';
    await ref.read(financesServiceProvider).setStatus(bill.id, next);
    await refresh();
    await ref.read(financesSummaryProvider.notifier).refresh();
  }

  Future<void> delete(FinanceBillModel bill) async {
    await ref.read(financesServiceProvider).remove(bill.id);
    await refresh();
    await ref.read(financesSummaryProvider.notifier).refresh();
  }
}

