// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:flavor/flavor.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:location/location.dart' as _i7;
import 'package:shared_preferences/shared_preferences.dart' as _i10;
import 'package:tesla_android/common/di/app_module.dart' as _i22;
import 'package:tesla_android/common/di/network_module.dart' as _i23;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i11;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i15;
import 'package:tesla_android/common/network/health_service.dart' as _i6;
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart' as _i20;
import 'package:tesla_android/feature/audio/transport/audio_transport.dart'
    as _i14;
import 'package:tesla_android/feature/audio/utils/pcm_player.dart' as _i8;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i16;
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart' as _i17;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i18;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i9;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i21;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i19;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i13;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i12;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final appModule = _$AppModule();
    gh.singleton<_i3.Dio>(networkModule.dio);
    gh.singleton<_i4.Flavor>(appModule.provideFlavor);
    gh.lazySingleton<_i5.GlobalKey<_i5.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.factory<_i6.HealthService>(() => _i6.HealthService(
          gh<_i3.Dio>(),
          gh<_i4.Flavor>(),
        ));
    gh.singleton<_i7.Location>(appModule.location);
    gh.lazySingleton<_i8.PcmAudioPlayer>(() => _i8.PcmAudioPlayer());
    gh.factory<_i9.ReleaseNotesRepository>(() => _i9.ReleaseNotesRepository());
    await gh.singletonAsync<_i10.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i11.TAPageFactory>(() => _i11.TAPageFactory());
    gh.singleton<_i12.TouchScreenTransport>(
        _i12.TouchScreenTransport(gh<_i4.Flavor>()));
    gh.singleton<_i13.TouchscreenCubit>(
        _i13.TouchscreenCubit(gh<_i12.TouchScreenTransport>()));
    gh.singleton<_i14.AudioTransport>(_i14.AudioTransport(gh<_i4.Flavor>()));
    gh.factory<_i15.ConfigurationService>(() => _i15.ConfigurationService(
          gh<_i3.Dio>(),
          gh<_i4.Flavor>(),
        ));
    gh.singleton<_i16.ConnectivityCheckCubit>(
        _i16.ConnectivityCheckCubit(gh<_i6.HealthService>()));
    gh.lazySingleton<_i17.GpsCubit>(() => _i17.GpsCubit(
          gh<_i10.SharedPreferences>(),
          gh<_i7.Location>(),
        ));
    gh.factory<_i18.ReleaseNotesCubit>(
        () => _i18.ReleaseNotesCubit(gh<_i9.ReleaseNotesRepository>()));
    gh.factory<_i19.SystemConfigurationRepository>(() =>
        _i19.SystemConfigurationRepository(gh<_i15.ConfigurationService>()));
    gh.singleton<_i20.AudioCubit>(_i20.AudioCubit(
      gh<_i14.AudioTransport>(),
      gh<_i8.PcmAudioPlayer>(),
      gh<_i10.SharedPreferences>(),
    ));
    gh.factory<_i21.SystemConfigurationCubit>(
        () => _i21.SystemConfigurationCubit(
              gh<_i19.SystemConfigurationRepository>(),
              gh<_i5.GlobalKey<_i5.NavigatorState>>(),
            ));
    return this;
  }
}

class _$AppModule extends _i22.AppModule {}

class _$NetworkModule extends _i23.NetworkModule {}
