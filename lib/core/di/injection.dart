 import 'package:get_it/get_it.dart';

import '../services/documents/cubit/document_cubit.dart';

import '../../features/root/cubit/root_cubit.dart';
import '../../features/floorplan/cubit/directory_cubit.dart';
import '../../features/floorplan/cubit/floorplan_cubit.dart';
import '../../features/floorplan/data/repo/floorplan_repository.dart';
import '../../features/floorplan/data/usecase/assign_user_to_desk.dart';
import '../../features/floorplan/data/usecase/check_in.dart';
import '../../features/floorplan/data/usecase/check_out.dart';
import '../../features/floorplan/data/usecase/department_autocomplete.dart';
import '../../features/floorplan/data/usecase/get_floor_layout.dart';
import '../../features/floorplan/data/usecase/get_floor_presence.dart';
import '../../features/floorplan/data/usecase/get_users_autocomplete.dart';
import '../../features/floorplan/data/usecase/heartbeat.dart';
import '../../features/floorplan/data/usecase/move_desk.dart';
import '../../features/floorplan/data/usecase/search_directory.dart';


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

  // Floorplan (Slice 1)
  getIt.registerLazySingleton(() => FloorplanRepository());
  getIt.registerFactory(() => GetFloorLayoutUsecase(getIt()));
  getIt.registerFactory(() => MoveDeskUsecase(getIt()));
  getIt.registerFactory(() => AssignUserToDeskUsecase(getIt()));
  getIt.registerFactory(() => GetUsersAutocompleteUsecase(getIt()));
  getIt.registerFactory(() => FloorplanCubit());

  // Floorplan (Slice 2: presence, directory, real-time)
  getIt.registerFactory(() => CheckInUsecase(getIt()));
  getIt.registerFactory(() => HeartbeatUsecase(getIt()));
  getIt.registerFactory(() => CheckOutUsecase(getIt()));
  getIt.registerFactory(() => GetFloorPresenceUsecase(getIt()));
  getIt.registerFactory(() => SearchDirectoryUsecase(getIt()));
  getIt.registerFactory(() => DepartmentAutocompleteUsecase(getIt()));
  getIt.registerFactory(() => DirectoryCubit());
  // getIt.registerLazySingleton(() => EnumCubit());
  // getIt.registerLazySingleton(() => VisitCubit());
  // getIt.registerLazySingleton(() => VisitHistoryCubit());
  // getIt.registerLazySingleton(() => AdvertisementCubit());
  // getIt.registerLazySingleton(() => ComplaintCubit());
  // getIt.registerLazySingleton(() => NotificationCubit());
}
