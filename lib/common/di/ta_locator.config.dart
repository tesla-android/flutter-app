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
import 'package:shared_preferences/shared_preferences.dart' as _i9;
import 'package:tesla_android/common/di/app_module.dart' as _i20;
import 'package:tesla_android/common/di/network_module.dart' as _i21;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i10;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i14;
import 'package:tesla_android/common/network/health_service.dart' as _i6;
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart' as _i18;
import 'package:tesla_android/feature/audio/transport/audio_transport.dart'
    as _i13;
import 'package:tesla_android/feature/audio/utils/pcm_player.dart' as _i7;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i15;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i16;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i8;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i19;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i17;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i12;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i11;

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
    gh.lazySingleton<_i7.PcmAudioPlayer>(() => _i7.PcmAudioPlayer());
    gh.factory<_i8.ReleaseNotesRepository>(() => _i8.ReleaseNotesRepository());
    await gh.singletonAsync<_i9.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i10.TAPageFactory>(() => _i10.TAPageFactory());
    gh.singleton<_i11.TouchScreenTransport>(
        _i11.TouchScreenTransport(gh<_i4.Flavor>()));
    gh.singleton<_i12.TouchscreenCubit>(
        _i12.TouchscreenCubit(gh<_i11.TouchScreenTransport>()));
    gh.singleton<_i13.AudioTransport>(_i13.AudioTransport(gh<_i4.Flavor>()));
    gh.factory<_i14.ConfigurationService>(() => _i14.ConfigurationService(
          gh<_i3.Dio>(),
          gh<_i4.Flavor>(),
        ));
    gh.singleton<_i15.ConnectivityCheckCubit>(
        _i15.ConnectivityCheckCubit(gh<_i6.HealthService>()));
    gh.factory<_i16.ReleaseNotesCubit>(
        () => _i16.ReleaseNotesCubit(gh<_i8.ReleaseNotesRepository>()));
    gh.factory<_i17.SystemConfigurationRepository>(() =>
        _i17.SystemConfigurationRepository(gh<_i14.ConfigurationService>()));
    gh.singleton<_i18.AudioCubit>(_i18.AudioCubit(
      gh<_i13.AudioTransport>(),
      gh<_i7.PcmAudioPlayer>(),
      gh<_i9.SharedPreferences>(),
    ));
    gh.factory<_i19.SystemConfigurationCubit>(
        () => _i19.SystemConfigurationCubit(
              gh<_i17.SystemConfigurationRepository>(),
              gh<_i5.GlobalKey<_i5.NavigatorState>>(),
            ));
    return this;
  }
}

class _$AppModule extends _i20.AppModule {}

class _$NetworkModule extends _i21.NetworkModule {}
