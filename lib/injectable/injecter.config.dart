// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/utils/register_modules.dart' as _i1044;
import '../features/authentication/data/data%20sources/auth_local_ds.dart'
    as _i401;
import '../features/authentication/data/data%20sources/auth_remote_ds.dart'
    as _i197;
import '../features/authentication/data/repositories/auth_repository_impl.dart'
    as _i781;
import '../features/authentication/domain/repositories/auth_repository.dart'
    as _i716;
import '../features/authentication/presentation/cubit/auth_cubit.dart' as _i395;
import '../features/home/presentation/cubit/home_cubit.dart' as _i1017;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.factory<_i1017.HomeCubit>(() => _i1017.HomeCubit());
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i401.IAuthLocalDS>(
      () => _i401.AuthLocalDSImpl(gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i197.IAuthRemoteDS>(
      () => _i197.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.lazySingleton<_i716.IAuthRepository>(() => _i781.AuthRepoImpl(
        gh<_i197.IAuthRemoteDS>(),
        gh<_i401.IAuthLocalDS>(),
      ));
  gh.factory<bool>(() => registerModule.isTokenExpired(gh<String>()));
  gh.factory<_i395.AuthCubit>(
      () => _i395.AuthCubit(gh<_i716.IAuthRepository>()));
  return getIt;
}

class _$RegisterModule extends _i1044.RegisterModule {}
