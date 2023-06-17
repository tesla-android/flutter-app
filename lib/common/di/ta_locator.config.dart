// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aptabase_flutter/aptabase_flutter.dart' as _i3;
import 'package:dio/dio.dart' as _i5;
import 'package:flavor/flavor.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:location/location.dart' as _i10;
import 'package:shared_preferences/shared_preferences.dart' as _i13;
import 'package:tesla_android/common/di/app_module.dart' as _i27;
import 'package:tesla_android/common/di/network_module.dart' as _i28;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i14;
import 'package:tesla_android/common/network/configuration_service.dart'
    as _i18;
import 'package:tesla_android/common/network/display_service.dart' as _i20;
import 'package:tesla_android/common/network/health_service.dart' as _i9;
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart' as _i17;
import 'package:tesla_android/feature/audio/transport/audio_transport.dart'
    as _i4;
import 'package:tesla_android/feature/audio/utils/pcm_player.dart' as _i11;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i19;
import 'package:tesla_android/feature/display/cubit/display_cubit.dart' as _i26;
import 'package:tesla_android/feature/display/repository/display_repository.dart'
    as _i24;
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart' as _i21;
import 'package:tesla_android/feature/gps/transport/gps_transport.dart' as _i8;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i22;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i12;
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart'
    as _i25;
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart'
    as _i23;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i16;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i15;

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
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    gh.singletonAsync<_i3.Aptabase>(() => appModule.provideAptabase());
    gh.factory<_i4.AudioTransport>(() => _i4.AudioTransport());
    gh.singleton<_i5.Dio>(networkModule.dio);
    gh.singleton<_i6.Flavor>(appModule.provideFlavor);
    gh.lazySingleton<_i7.GlobalKey<_i7.NavigatorState>>(
        () => appModule.navigatorKey);
    gh.factory<_i8.GpsTransport>(() => _i8.GpsTransport());
    gh.factory<_i9.HealthService>(() => _i9.HealthService(
          gh<_i5.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.singleton<_i10.Location>(appModule.location);
    gh.lazySingleton<_i11.PcmAudioPlayer>(() => _i11.PcmAudioPlayer());
    gh.factory<_i12.ReleaseNotesRepository>(
        () => _i12.ReleaseNotesRepository());
    await gh.singletonAsync<_i13.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i14.TAPageFactory>(() => _i14.TAPageFactory());
    gh.factory<_i15.TouchScreenTransport>(() => _i15.TouchScreenTransport());
    gh.factory<_i16.TouchscreenCubit>(
        () => _i16.TouchscreenCubit(gh<_i15.TouchScreenTransport>()));
    gh.factory<_i17.AudioCubit>(() => _i17.AudioCubit(
          gh<_i4.AudioTransport>(),
          gh<_i11.PcmAudioPlayer>(),
          gh<_i13.SharedPreferences>(),
        ));
    gh.factory<_i18.ConfigurationService>(() => _i18.ConfigurationService(
          gh<_i5.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.singleton<_i19.ConnectivityCheckCubit>(
        _i19.ConnectivityCheckCubit(gh<_i9.HealthService>()));
    gh.factory<_i20.DisplayService>(() => _i20.DisplayService(
          gh<_i5.Dio>(),
          gh<_i6.Flavor>(),
        ));
    gh.singleton<_i21.GpsCubit>(_i21.GpsCubit(
      gh<_i13.SharedPreferences>(),
      gh<_i10.Location>(),
      gh<_i8.GpsTransport>(),
    ));
    gh.factory<_i22.ReleaseNotesCubit>(
        () => _i22.ReleaseNotesCubit(gh<_i12.ReleaseNotesRepository>()));
    gh.factory<_i23.SystemConfigurationRepository>(() =>
        _i23.SystemConfigurationRepository(gh<_i18.ConfigurationService>()));
    gh.factory<_i24.DisplayRepository>(
        () => _i24.DisplayRepository(gh<_i20.DisplayService>()));
    gh.factory<_i25.SystemConfigurationCubit>(
        () => _i25.SystemConfigurationCubit(
              gh<_i23.SystemConfigurationRepository>(),
              gh<_i7.GlobalKey<_i7.NavigatorState>>(),
            ));
    gh.factory<_i26.DisplayCubit>(
        () => _i26.DisplayCubit(gh<_i24.DisplayRepository>()));
    return this;
  }
}

class _$AppModule extends _i27.AppModule {}

class _$NetworkModule extends _i28.NetworkModule {}
