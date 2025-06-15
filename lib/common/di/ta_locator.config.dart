// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flavor/flavor.dart' as _i544;
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:tesla_android/common/di/app_module.dart' as _i200;
import 'package:tesla_android/common/di/network_module.dart' as _i666;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i557;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i302;
import 'package:tesla_android/common/network/device_info_service.dart' as _i723;
import 'package:tesla_android/common/network/display_service.dart' as _i856;
import 'package:tesla_android/common/network/github_service.dart' as _i10;
import 'package:tesla_android/common/network/health_service.dart' as _i483;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i747;
import 'package:tesla_android/feature/display/cubit/display_cubit.dart' as _i14;
import 'package:tesla_android/feature/display/repository/display_repository.dart'
    as _i271;
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart' as _i68;
import 'package:tesla_android/feature/home/repository/github_release_repository.dart'
    as _i865;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i399;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i841;
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart'
    as _i825;
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart'
    as _i1064;
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart'
    as _i685;
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart'
    as _i713;
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart'
    as _i588;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i365;
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart'
    as _i708;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i608;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i680;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i557.TAPageFactory>(() => _i557.TAPageFactory());
    gh.factory<_i680.TouchscreenCubit>(() => _i680.TouchscreenCubit());
    gh.factory<_i841.ReleaseNotesRepository>(
      () => _i841.ReleaseNotesRepository(),
    );
    gh.singleton<_i544.Flavor>(() => appModule.provideFlavor);
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i409.GlobalKey<_i409.NavigatorState>>(
      () => appModule.navigatorKey,
    );
    gh.factory<_i302.ConfigurationService>(
      () => _i302.ConfigurationService(gh<_i361.Dio>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i483.HealthService>(
      () => _i483.HealthService(gh<_i361.Dio>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i723.DeviceInfoService>(
      () => _i723.DeviceInfoService(gh<_i361.Dio>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i10.GitHubService>(
      () => _i10.GitHubService(gh<_i361.Dio>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i856.DisplayService>(
      () => _i856.DisplayService(gh<_i361.Dio>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i608.SystemConfigurationRepository>(
      () =>
          _i608.SystemConfigurationRepository(gh<_i302.ConfigurationService>()),
    );
    gh.factory<_i365.SystemConfigurationCubit>(
      () => _i365.SystemConfigurationCubit(
        gh<_i608.SystemConfigurationRepository>(),
        gh<_i409.GlobalKey<_i409.NavigatorState>>(),
      ),
    );
    gh.factory<_i865.GitHubReleaseRepository>(
      () => _i865.GitHubReleaseRepository(
        gh<_i10.GitHubService>(),
        gh<_i723.DeviceInfoService>(),
      ),
    );
    gh.factory<_i271.DisplayRepository>(
      () => _i271.DisplayRepository(gh<_i856.DisplayService>()),
    );
    gh.factory<_i68.OTAUpdateCubit>(
      () => _i68.OTAUpdateCubit(
        gh<_i865.GitHubReleaseRepository>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i713.GPSConfigurationCubit>(
      () => _i713.GPSConfigurationCubit(
        gh<_i608.SystemConfigurationRepository>(),
      ),
    );
    gh.factory<_i825.AudioConfigurationCubit>(
      () => _i825.AudioConfigurationCubit(
        gh<_i608.SystemConfigurationRepository>(),
      ),
    );
    gh.factory<_i708.DeviceInfoRepository>(
      () => _i708.DeviceInfoRepository(gh<_i723.DeviceInfoService>()),
    );
    gh.factory<_i271.DisplayRepository>(
      () => _i271.DisplayRepository(
        gh<_i856.DisplayService>(),
        gh<_i460.SharedPreferences>(),
      ),
    gh.factory<_i14.DisplayCubit>(
      () =>
          _i14.DisplayCubit(gh<_i271.DisplayRepository>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i399.ReleaseNotesCubit>(
      () => _i399.ReleaseNotesCubit(gh<_i841.ReleaseNotesRepository>()),
    );
    gh.factory<_i747.ConnectivityCheckCubit>(
      () => _i747.ConnectivityCheckCubit(gh<_i483.HealthService>()),
    );
    gh.factory<_i685.DisplayConfigurationCubit>(
      () => _i685.DisplayConfigurationCubit(gh<_i271.DisplayRepository>()),
    );
    gh.factory<_i588.RearDisplayConfigurationCubit>(
      () => _i588.RearDisplayConfigurationCubit(gh<_i271.DisplayRepository>()),
    );
    gh.factory<_i1064.DeviceInfoCubit>(
      () => _i1064.DeviceInfoCubit(gh<_i708.DeviceInfoRepository>()),
    );
    gh.factory<_i14.DisplayCubit>(
      () =>
          _i14.DisplayCubit(gh<_i271.DisplayRepository>(), gh<_i544.Flavor>()),
    );
    gh.factory<_i1064.DeviceInfoCubit>(
      () => _i1064.DeviceInfoCubit(gh<_i708.DeviceInfoRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i200.AppModule {}

class _$NetworkModule extends _i666.NetworkModule {}
