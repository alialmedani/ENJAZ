import 'dart:async';
import 'package:bloc/bloc.dart';
 import 'package:enjaz/features/staff/data/model/staff_order.dart';

class StaffOrdersState {
  final List<StaffOrder> all;
  final bool loading;
  final String? error;
  const StaffOrdersState({
    required this.all,
    required this.loading,
    this.error,
  });

  StaffOrdersState copyWith({
    List<StaffOrder>? all,
    bool? loading,
    String? error,
  }) => StaffOrdersState(
    all: all ?? this.all,
    loading: loading ?? this.loading,
    error: error,
  );

  List<Object?> get props => [all, loading, error];
}

class StaffOrdersCubit extends Cubit<StaffOrdersState> {
  StaffOrdersCubit() : super(const StaffOrdersState(all: [], loading: true)) {
    refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(loading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final data = <StaffOrder>[
      StaffOrder(
        id: 'ORD-1001',
        itemName: 'Cappuccino',
        size: 'M',
        quantity: 1,
        sugar: 1,
        milkPct: 50,
        addons: const ['Vanilla'],
        customerNote: 'Extra hot please',
        floor: 2,
        office: 5,
        status: StaffOrderStatus.pending,
        scheduleType: ScheduleType.none,
        createdAt: now.subtract(const Duration(minutes: 3)),
        scheduledAt: null,
        slaMinutes: 12,
      ),
      StaffOrder(
        id: 'ORD-1002',
        itemName: 'Latte',
        size: 'L',
        quantity: 2,
        sugar: 0,
        milkPct: 40,
        addons: const [],
        floor: 3,
        office: 1,
        status: StaffOrderStatus.inProgress,
        scheduleType: ScheduleType.none,
        createdAt: now.subtract(const Duration(minutes: 8)),
        scheduledAt: null,
        slaMinutes: 15,
        assignee: 'Me',
        notes: [
          OrderNote(
            author: 'Me',
            text: 'Started',
            time: now.subtract(const Duration(minutes: 7)),
          ),
        ],
      ),
      StaffOrder(
        id: 'ORD-1003',
        itemName: 'Americano',
        size: 'S',
        quantity: 1,
        sugar: 0,
        milkPct: 0,
        addons: const ['Cinnamon'],
        customerNote: 'No milk',
        floor: 1,
        office: 2,
        status: StaffOrderStatus.ready,
        scheduleType: ScheduleType.none,
        createdAt: now.subtract(const Duration(minutes: 18)),
        scheduledAt: null,
        slaMinutes: 15,
        assignee: 'Me',
      ),
      StaffOrder(
        id: 'ORD-2001',
        itemName: 'Mocha',
        size: 'M',
        quantity: 1,
        sugar: 1,
        milkPct: 60,
        addons: const [],
        floor: 4,
        office: 3,
        status: StaffOrderStatus.pending,
        scheduleType: ScheduleType.scheduled,
        createdAt: now,
        scheduledAt: now.add(const Duration(minutes: 25)),
        slaMinutes: 10,
      ),
    ];
    emit(StaffOrdersState(all: data, loading: false));
  }
}
