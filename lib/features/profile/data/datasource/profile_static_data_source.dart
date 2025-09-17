// lib/features/profile/data/datasource/profile_static_data_source.dart
import 'dart:math';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/profile/data/model/order_history_entry.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
 
abstract class IProfileStaticDataSource {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateSettings({
    AppLanguage? language,
    bool? notificationsEnabled,
    int? defaultFloor,
    int? defaultOffice,
  });

  /// جميع السجلّات، سنطبّق الفلاتر في الـRepository/UseCase
  Future<List<OrderHistoryEntry>> getOrderHistory();
}

class ProfileStaticDataSource implements IProfileStaticDataSource {
  static UserProfile _profile = const UserProfile(
    id: 'u_1',
    name: 'مستخدم إنجاز',
    avatarUrl: null,
    language: AppLanguage.ar,
    notificationsEnabled: true,
    defaultFloor: 2,
    defaultOffice: 4,
    favorites: ['Latte', 'Cappuccino', 'Espresso'],
  );

  static final List<OrderModel> _seedOrders = [
    OrderModel(
      id: 'p1',
      itemName: 'Latte',
      size: 'M',
       floor: 2,
     ),
    OrderModel(
      id: 'p2',
      itemName: 'Cappuccino',
      size: 'L',
       floor: 2,
     ),
    OrderModel(
      id: 'p3',
      itemName: 'Americano',
      size: 'S',
       floor: 3,
     ),
    OrderModel(
      id: 'p4',
      itemName: 'Latte',
      size: 'M',
       floor: 1,
     ),
    OrderModel(
      id: 'p5',
      itemName: 'Mocha',
      size: 'M',
       floor: 5,
     ),
    OrderModel(
      id: 'p6',
      itemName: 'Espresso',
      size: 'S',
       floor: 2,
     ),
  ];

  static List<OrderHistoryEntry>? _cache;

  // Future<double> _priceFor(String item, String size) async {
  //   final menu = await MenuStaticDataSource().getMenu();
  //   final m = menu.items.firstWhere(
  //     (e) => e.name.toLowerCase() == item.toLowerCase(),
  //     orElse: () => menu.items.first,
  //   );
  //   return m.priceFor(size);
  // }

  @override
  Future<UserProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  @override
  Future<UserProfile> updateSettings({
    AppLanguage? language,
    bool? notificationsEnabled,
    int? defaultFloor,
    int? defaultOffice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = _profile.copyWith(
      language: language ?? _profile.language,
      notificationsEnabled:
          notificationsEnabled ?? _profile.notificationsEnabled,
      defaultFloor: defaultFloor ?? _profile.defaultFloor,
      defaultOffice: defaultOffice ?? _profile.defaultOffice,
    );
    return _profile;
  }

  @override
  Future<List<OrderHistoryEntry>> getOrderHistory() async {
    if (_cache != null) return _cache!;
    // انثر تواريخ على آخر 6 أشهر
    final now = DateTime.now();
    final rnd = Random(42);
    final List<OrderHistoryEntry> out = [];
    for (final o in _seedOrders) {
      final monthsBack = rnd.nextInt(6); // 0..5
      final day = 1 + rnd.nextInt(26);
      final dt = DateTime(
        now.year,
        now.month - monthsBack,
        day,
        10 + rnd.nextInt(8),
      );
      final qty = 1 + rnd.nextInt(2); // 1..2
       final extras = [0, 0.5, 1.0, 1.5][rnd.nextInt(4)];
      out.add(
        OrderHistoryEntry(
          order: o,
          createdAt: dt,
          quantity: qty,
          ),
      );
    }
    // كرّر شوية لزيادة البيانات
    for (int i = 0; i < 10; i++) {
      final base = _seedOrders[rnd.nextInt(_seedOrders.length)];
      final monthsBack = rnd.nextInt(6);
      final day = 1 + rnd.nextInt(26);
      final dt = DateTime(
        now.year,
        now.month - monthsBack,
        day,
        9 + rnd.nextInt(10),
      );
      final qty = 1 + rnd.nextInt(3);
       final extras = [0, 0.5, 1.0, 1.5, 2.0][rnd.nextInt(5)];
      out.add(
        OrderHistoryEntry(
          order: base,
          createdAt: dt,
          quantity: qty,
        
        ),
      );
    }
    out.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _cache = out;
    return out;
  }
}
