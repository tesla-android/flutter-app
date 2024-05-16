// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i8;
import 'package:flavor/flavor.dart' as _i6;
import 'package:flutter/material.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;
import 'package:tesla_android/common/di/app_module.dart' as _i27;
import 'package:tesla_android/common/di/network_module.dart' as _i28;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i3;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i10;
import 'package:tesla_android/common/network/device_info_service.dart' as _i12;
import 'package:tesla_android/common/network/display_service.dart' as _i14;
import 'package:tesla_android/common/network/github_service.dart' as _i13;
import 'package:tesla_android/common/network/health_service.dart' as _i11;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i23;
import 'package:tesla_android/feature/display/cubit/display_cubit.dart' as _i21;
import 'package:tesla_android/feature/display/repository/display_repository.dart'
    as _i18;
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart' as _i25;
import 'package:tesla_android/feature/home/repository/github_release_repository.dart'
    as _i17;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i22;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i5;
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart'
    as _i19;
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart'
    as _i26;
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart'
    as _i24;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i16;
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart'
    as _i20;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i15;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i4;

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
    gh.factory<_i3.TAPageFactory>(() => _i3.TAPageFactory());
    gh.factory<_i4.TouchscreenCubit>(() => _i4.TouchscreenCubit());
    gh.factory<_i5.ReleaseNotesRepository>(() => _i5.ReleaseNotesRepository());
    gh.singleton<_i6.Flavor>(() => appModule.provideFlavor);
    await gh.singletonAsync<_i7.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i8.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i9.GlobalKey<_i9.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.factory<_i10.ConfigurationService>(() => _i10.ConfigurationService(
          gh<_i8.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.factory<_i11.HealthService>(() => _i11.HealthService(
          gh<_i8.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.factory<_i12.DeviceInfoService>(() => _i12.DeviceInfoService(
          gh<_i8.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.factory<_i13.GitHubService>(() => _i13.GitHubService(
          gh<_i8.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.factory<_i14.DisplayService>(() => _i14.DisplayService(
          gh<_i8.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.factory<_i15.SystemConfigurationRepository>(() =>
        _i15.SystemConfigurationRepository(gh<_i10.ConfigurationService>()));
    gh.factory<_i16.SystemConfigurationCubit>(
        () => _i16.SystemConfigurationCubit(
              gh<_i15.SystemConfigurationRepository>(),
              gh<_i9.GlobalKey<_i9.NavigatorState>>(),
            ));
    gh.factory<_i17.GitHubReleaseRepository>(() => _i17.GitHubReleaseRepository(
          gh<_i13.GitHubService>(),
          gh<_i12.DeviceInfoService>(),
        ));
    gh.factory<_i18.DisplayRepository>(
        () => _i18.DisplayRepository(gh<_i14.DisplayService>()));
    gh.factory<_i19.AudioConfigurationCubit>(() =>
        _i19.AudioConfigurationCubit(gh<_i15.SystemConfigurationRepository>()));
    gh.factory<_i20.DeviceInfoRepository>(
        () => _i20.DeviceInfoRepository(gh<_i12.DeviceInfoService>()));
    gh.factory<_i21.DisplayCubit>(() => _i21.DisplayCubit(
          gh<_i18.DisplayRepository>(),
          gh<_i6.Flavor>(),
        ));
    gh.factory<_i22.ReleaseNotesCubit>(
        () => _i22.ReleaseNotesCubit(gh<_i5.ReleaseNotesRepository>()));
    gh.factory<_i23.ConnectivityCheckCubit>(
        () => _i23.ConnectivityCheckCubit(gh<_i11.HealthService>()));
    gh.factory<_i24.DisplayConfigurationCubit>(
        () => _i24.DisplayConfigurationCubit(gh<_i18.DisplayRepository>()));
    gh.factory<_i25.OTAUpdateCubit>(() => _i25.OTAUpdateCubit(
          gh<_i17.GitHubReleaseRepository>(),
          gh<_i7.SharedPreferences>(),
        ));
    gh.factory<_i26.DeviceInfoCubit>(
        () => _i26.DeviceInfoCubit(gh<_i20.DeviceInfoRepository>()));
    return this;
  }
}

class _$AppModule extends _i27.AppModule {}

class _$NetworkModule extends _i28.NetworkModule {}
