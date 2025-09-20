enum ScheduleType { none, scheduled }

enum StaffOrderStatus { pending, inProgress, ready, delivered }

class OrderNote {
  final String author;
  final String text;
  final DateTime time;
  const OrderNote({
    required this.author,
    required this.text,
    required this.time,
  });

  List<Object?> get props => [author, text, time];
}

class StaffOrder {
  final String id;
  final String itemName;
  final String size;
  final int quantity;
  final int sugar; // spoons
  final int milkPct; // 0..100
  final List<String> addons;
  final String? customerNote;

  final int floor;
  final int office;

  final StaffOrderStatus status;
  final ScheduleType scheduleType;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final int slaMinutes;

  final String? assignee; // employee name
  final List<OrderNote> notes;

  const StaffOrder({
    required this.id,
    required this.itemName,
    required this.size,
    required this.quantity,
    required this.sugar,
    required this.milkPct,
    required this.addons,
    this.customerNote,
    required this.floor,
    required this.office,
    required this.status,
    required this.scheduleType,
    required this.createdAt,
    required this.scheduledAt,
    required this.slaMinutes,
    this.assignee,
    this.notes = const [],
  });

  bool get mine => (assignee ?? '').isNotEmpty;
  DateTime get dueAt => createdAt.add(Duration(minutes: slaMinutes));

  StaffOrder copyWith({
    StaffOrderStatus? status,
    String? assignee,
    List<OrderNote>? notes,
  }) => StaffOrder(
    id: id,
    itemName: itemName,
    size: size,
    quantity: quantity,
    sugar: sugar,
    milkPct: milkPct,
    addons: addons,
    customerNote: customerNote,
    floor: floor,
    office: office,
    status: status ?? this.status,
    scheduleType: scheduleType,
    createdAt: createdAt,
    scheduledAt: scheduledAt,
    slaMinutes: slaMinutes,
    assignee: assignee ?? this.assignee,
    notes: notes ?? this.notes,
  );

  List<Object?> get props => [
    id,
    itemName,
    size,
    quantity,
    sugar,
    milkPct,
    addons,
    customerNote,
    floor,
    office,
    status,
    scheduleType,
    createdAt,
    scheduledAt,
    slaMinutes,
    assignee,
    notes,
  ];
}
