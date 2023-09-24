// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aptabase_flutter/aptabase_flutter.dart' as _i3;
import 'package:dio/dio.dart' as _i4;
import 'package:flavor/flavor.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i9;
import 'package:tesla_android/common/di/app_module.dart' as _i25;
import 'package:tesla_android/common/di/network_module.dart' as _i26;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i10;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i12;
import 'package:tesla_android/common/network/device_info_service.dart' as _i14;
import 'package:tesla_android/common/network/display_service.dart' as _i15;
import 'package:tesla_android/common/network/health_service.dart' as _i7;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i13;
import 'package:tesla_android/feature/display/cubit/display_cubit.dart' as _i24;
import 'package:tesla_android/feature/display/repository/display_repository.dart'
    as _i20;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i16;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i8;
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart'
    as _i18;
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart'
    as _i22;
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart'
    as _i23;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i21;
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart'
    as _i19;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i17;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i11;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    await gh.singletonAsync<_i3.Aptabase>(
      () => appModule.provideAptabase(),
      preResolve: true,
    );
    gh.singleton<_i4.Dio>(networkModule.dio);
    gh.singleton<_i5.Flavor>(appModule.provideFlavor);
    gh.lazySingleton<_i6.GlobalKey<_i6.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.factory<_i7.HealthService>(() => _i7.HealthService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i8.ReleaseNotesRepository>(() => _i8.ReleaseNotesRepository());
    await gh.singletonAsync<_i9.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i10.TAPageFactory>(() => _i10.TAPageFactory());
    gh.factory<_i11.TouchscreenCubit>(() => _i11.TouchscreenCubit());
    gh.factory<_i12.ConfigurationService>(() => _i12.ConfigurationService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i13.ConnectivityCheckCubit>(
        () => _i13.ConnectivityCheckCubit(gh<_i7.HealthService>()));
    gh.factory<_i14.DeviceInfoService>(() => _i14.DeviceInfoService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i15.DisplayService>(() => _i15.DisplayService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i16.ReleaseNotesCubit>(
        () => _i16.ReleaseNotesCubit(gh<_i8.ReleaseNotesRepository>()));
    gh.factory<_i17.SystemConfigurationRepository>(() =>
        _i17.SystemConfigurationRepository(gh<_i12.ConfigurationService>()));
    gh.factory<_i18.AudioConfigurationCubit>(() =>
        _i18.AudioConfigurationCubit(gh<_i17.SystemConfigurationRepository>()));
    gh.factory<_i19.DeviceInfoRepository>(
        () => _i19.DeviceInfoRepository(gh<_i14.DeviceInfoService>()));
    gh.factory<_i20.DisplayRepository>(
        () => _i20.DisplayRepository(gh<_i15.DisplayService>()));
    gh.factory<_i21.SystemConfigurationCubit>(
        () => _i21.SystemConfigurationCubit(
              gh<_i17.SystemConfigurationRepository>(),
              gh<_i6.GlobalKey<_i6.NavigatorState>>(),
            ));
    gh.factory<_i22.DeviceInfoCubit>(
        () => _i22.DeviceInfoCubit(gh<_i19.DeviceInfoRepository>()));
    gh.factory<_i23.DisplayConfigurationCubit>(
        () => _i23.DisplayConfigurationCubit(gh<_i20.DisplayRepository>()));
    gh.factory<_i24.DisplayCubit>(() => _i24.DisplayCubit(
          gh<_i20.DisplayRepository>(),
          gh<_i5.Flavor>(),
        ));
    return this;
  }
}

class _$AppModule extends _i25.AppModule {}

class _$NetworkModule extends _i26.NetworkModule {}
