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
import 'package:flutter/material.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i10;
import 'package:tesla_android/common/di/app_module.dart' as _i28;
import 'package:tesla_android/common/di/network_module.dart' as _i29;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i11;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i13;
import 'package:tesla_android/common/network/device_info_service.dart' as _i15;
import 'package:tesla_android/common/network/display_service.dart' as _i16;
import 'package:tesla_android/common/network/github_service.dart' as _i6;
import 'package:tesla_android/common/network/health_service.dart' as _i8;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i14;
import 'package:tesla_android/feature/display/cubit/display_cubit.dart' as _i27;
import 'package:tesla_android/feature/display/repository/display_repository.dart'
    as _i23;
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart' as _i18;
import 'package:tesla_android/feature/home/repository/github_release_repository.dart'
    as _i17;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i19;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i9;
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart'
    as _i21;
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart'
    as _i25;
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart'
    as _i26;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i24;
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart'
    as _i22;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i20;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i12;

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
    gh.factory<_i6.GitHubService>(() => _i6.GitHubService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.lazySingleton<_i7.GlobalKey<_i7.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.factory<_i8.HealthService>(() => _i8.HealthService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i9.ReleaseNotesRepository>(() => _i9.ReleaseNotesRepository());
    await gh.singletonAsync<_i10.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i11.TAPageFactory>(() => _i11.TAPageFactory());
    gh.factory<_i12.TouchscreenCubit>(() => _i12.TouchscreenCubit());
    gh.factory<_i13.ConfigurationService>(() => _i13.ConfigurationService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i14.ConnectivityCheckCubit>(
        () => _i14.ConnectivityCheckCubit(gh<_i8.HealthService>()));
    gh.factory<_i15.DeviceInfoService>(() => _i15.DeviceInfoService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i16.DisplayService>(() => _i16.DisplayService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.factory<_i17.GitHubReleaseRepository>(() => _i17.GitHubReleaseRepository(
          gh<_i6.GitHubService>(),
          gh<_i15.DeviceInfoService>(),
        ));
    gh.factory<_i18.OTAUpdateCubit>(() => _i18.OTAUpdateCubit(
          gh<_i17.GitHubReleaseRepository>(),
          gh<_i10.SharedPreferences>(),
        ));
    gh.factory<_i19.ReleaseNotesCubit>(
        () => _i19.ReleaseNotesCubit(gh<_i9.ReleaseNotesRepository>()));
    gh.factory<_i20.SystemConfigurationRepository>(() =>
        _i20.SystemConfigurationRepository(gh<_i13.ConfigurationService>()));
    gh.factory<_i21.AudioConfigurationCubit>(() =>
        _i21.AudioConfigurationCubit(gh<_i20.SystemConfigurationRepository>()));
    gh.factory<_i22.DeviceInfoRepository>(
        () => _i22.DeviceInfoRepository(gh<_i15.DeviceInfoService>()));
    gh.factory<_i23.DisplayRepository>(
        () => _i23.DisplayRepository(gh<_i16.DisplayService>()));
    gh.factory<_i24.SystemConfigurationCubit>(
        () => _i24.SystemConfigurationCubit(
              gh<_i20.SystemConfigurationRepository>(),
              gh<_i7.GlobalKey<_i7.NavigatorState>>(),
            ));
    gh.factory<_i25.DeviceInfoCubit>(
        () => _i25.DeviceInfoCubit(gh<_i22.DeviceInfoRepository>()));
    gh.factory<_i26.DisplayConfigurationCubit>(
        () => _i26.DisplayConfigurationCubit(gh<_i23.DisplayRepository>()));
    gh.factory<_i27.DisplayCubit>(() => _i27.DisplayCubit(
          gh<_i23.DisplayRepository>(),
          gh<_i5.Flavor>(),
        ));
    return this;
  }
}

class _$AppModule extends _i28.AppModule {}

class _$NetworkModule extends _i29.NetworkModule {}
