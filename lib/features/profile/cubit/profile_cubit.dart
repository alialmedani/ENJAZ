// lib/features/profile/profile_glue.dart


// ===============================
// 2) ProfileCubit: يستخدم UseCase وبنفس Result عندك + يـ emit الحالة
// ===============================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';
import 'package:enjaz/features/profile/data/usecase/get_user_usecase.dart';
import 'package:enjaz/features/profile/data/repo/user_repo.dart';

/// نُبقي الحالة بسيطة: UserModel? مثل ما عندك
class ProfileCubit extends Cubit<UserModel?> {
  ProfileCubit() : super(null);

  /// يجلب المستخدم الحالي من الـ API:
  /// - يرجع Result<UserModel> كما هو (لتعاطي الـ UI مع النجاح/الفشل)
  /// - وعند النجاح يقوم emit(user) لكي تُعرَض البيانات في الشاشة
  Future<Result<UserModel>> fetchCurrentCustomer() async {
    final usecase = GetCurrentUserUsecase(UserRepository());
    final result = await usecase.call(params: GetCurrentUserParams());

    if (result.hasDataOnly && result.data != null) {
      emit(result.data);
    }
    // في حالة الخطأ، نحافظ على الحالة السابقة ولا نغيّرها، ويمكن للواجهة قراءة result.error
    return result;
  }
}

/*
============ طريقة الاستخدام في الواجهة (اختياري كمرجع سريع) ============

final profileCubit = context.watch<ProfileCubit>();
final user = profileCubit.state;

Text(user?.displayName ?? '---');
Text(user?.email ?? '---');
Text(user?.phoneNumber ?? '---');
Text(user?.displayFloor ?? '---'); // يعرض floorName وإن لم توجد يعرض floorId
Text(user?.displayOffice ?? '---'); // يعرض officeName وإن لم توجد يعرض officeId
Text((user?.roles ?? const []).join(', '));

وعند فتح الشاشة (مثلاً في initState أو عبر BlocListener):
context.read<ProfileCubit>().fetchCurrentCustomer();

======================================================================
*/
