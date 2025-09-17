 import 'package:get_it/get_it.dart';
  
import '../services/documents/cubit/document_cubit.dart';
 
import '../../features/root/cubit/root_cubit.dart';
 

final getIt = GetIt.instance;

Future<void> setUp() async {
  getIt.registerLazySingleton(() => RootCubit());
  // getIt.registerLazySingleton(() => ReceivableCubit());
  // getIt.registerLazySingleton(() => HomeCubit());
  // getIt.registerLazySingleton(() => AuthCubit());
  // getIt.registerLazySingleton(() => ProfileCubit());
  // getIt.registerLazySingleton(() => ServicesCubit());
  // getIt.registerLazySingleton(() => CustomerFormCubit());
  // getIt.registerLazySingleton(() => WeaponCubit());
  // getIt.registerLazySingleton(() => VehicleCubit());
  // getIt.registerLazySingleton(() => FamilyCubit());
  // getIt.registerLazySingleton(() => RealEstateCubit());
  getIt.registerLazySingleton(() => DocumentCubit());
  // getIt.registerLazySingleton(() => EnumCubit());
  // getIt.registerLazySingleton(() => VisitCubit());
  // getIt.registerLazySingleton(() => VisitHistoryCubit());
  // getIt.registerLazySingleton(() => AdvertisementCubit());
  // getIt.registerLazySingleton(() => ComplaintCubit());
  // getIt.registerLazySingleton(() => NotificationCubit());
}
