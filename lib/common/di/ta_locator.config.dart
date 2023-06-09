// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:flavor/flavor.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:location/location.dart' as _i9;
import 'package:shared_preferences/shared_preferences.dart' as _i12;
import 'package:tesla_android/common/di/app_module.dart' as _i23;
import 'package:tesla_android/common/di/network_module.dart' as _i24;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i13;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i17;
import 'package:tesla_android/common/network/health_service.dart' as _i8;
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart' as _i16;
import 'package:tesla_android/feature/audio/transport/audio_transport.dart'
    as _i3;
import 'package:tesla_android/feature/audio/utils/pcm_player.dart' as _i10;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i18;
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart' as _i19;
import 'package:tesla_android/feature/gps/transport/gps_transport.dart' as _i7;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i20;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i11;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i22;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i21;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i15;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i14;

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
    gh.factory<_i3.AudioTransport>(() => _i3.AudioTransport());
    gh.singleton<_i4.Dio>(networkModule.dio);
    gh.singleton<_i5.Flavor>(appModule.provideFlavor);
    gh.lazySingleton<_i6.GlobalKey<_i6.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.factory<_i7.GpsTransport>(() => _i7.GpsTransport());
    gh.factory<_i8.HealthService>(() => _i8.HealthService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.singleton<_i9.Location>(appModule.location);
    gh.lazySingleton<_i10.PcmAudioPlayer>(() => _i10.PcmAudioPlayer());
    gh.factory<_i11.ReleaseNotesRepository>(
        () => _i11.ReleaseNotesRepository());
    await gh.singletonAsync<_i12.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i13.TAPageFactory>(() => _i13.TAPageFactory());
    gh.factory<_i14.TouchScreenTransport>(() => _i14.TouchScreenTransport());
    gh.factory<_i15.TouchscreenCubit>(
        () => _i15.TouchscreenCubit(gh<_i14.TouchScreenTransport>()));
    gh.factory<_i16.AudioCubit>(() => _i16.AudioCubit(
          gh<_i3.AudioTransport>(),
          gh<_i10.PcmAudioPlayer>(),
          gh<_i12.SharedPreferences>(),
        ));
    gh.factory<_i17.ConfigurationService>(() => _i17.ConfigurationService(
          gh<_i4.Dio>(),
          gh<_i5.Flavor>(),
        ));
    gh.singleton<_i18.ConnectivityCheckCubit>(
        _i18.ConnectivityCheckCubit(gh<_i8.HealthService>()));
    gh.singleton<_i19.GpsCubit>(_i19.GpsCubit(
      gh<_i12.SharedPreferences>(),
      gh<_i9.Location>(),
      gh<_i7.GpsTransport>(),
    ));
    gh.factory<_i20.ReleaseNotesCubit>(
        () => _i20.ReleaseNotesCubit(gh<_i11.ReleaseNotesRepository>()));
    gh.factory<_i21.SystemConfigurationRepository>(() =>
        _i21.SystemConfigurationRepository(gh<_i17.ConfigurationService>()));
    gh.factory<_i22.SystemConfigurationCubit>(
        () => _i22.SystemConfigurationCubit(
              gh<_i21.SystemConfigurationRepository>(),
              gh<_i6.GlobalKey<_i6.NavigatorState>>(),
            ));
    return this;
  }
}

class _$AppModule extends _i23.AppModule {}

class _$NetworkModule extends _i24.NetworkModule {}
