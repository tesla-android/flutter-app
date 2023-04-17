// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flavor/flavor.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:location/location.dart' as _i4;
import 'package:shared_preferences/shared_preferences.dart' as _i7;
import 'package:tesla_android/common/di/app_module.dart' as _i16;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i8;
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart' as _i15;
import 'package:tesla_android/feature/audio/transport/audio_transport.dart'
    as _i11;
import 'package:tesla_android/feature/audio/utils/pcm_player.dart' as _i5;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i12;
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart' as _i13;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i14;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i6;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i10;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i9;

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
    gh.singleton<_i3.Flavor>(appModule.provideFlavor);
    gh.singleton<_i4.Location>(appModule.location);
    gh.lazySingleton<_i5.PcmAudioPlayer>(() => _i5.PcmAudioPlayer());
    gh.factory<_i6.ReleaseNotesRepository>(() => _i6.ReleaseNotesRepository());
    await gh.singletonAsync<_i7.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i8.TAPageFactory>(() => _i8.TAPageFactory());
    gh.singleton<_i9.TouchScreenTransport>(
        _i9.TouchScreenTransport(gh<_i3.Flavor>()));
    gh.singleton<_i10.TouchscreenCubit>(
        _i10.TouchscreenCubit(gh<_i9.TouchScreenTransport>()));
    gh.singleton<_i11.AudioTransport>(_i11.AudioTransport(gh<_i3.Flavor>()));
    gh.singleton<_i12.ConnectivityCheckCubit>(
        _i12.ConnectivityCheckCubit(gh<_i3.Flavor>()));
    gh.lazySingleton<_i13.GpsCubit>(() => _i13.GpsCubit(
          gh<_i7.SharedPreferences>(),
          gh<_i4.Location>(),
        ));
    gh.factory<_i14.ReleaseNotesCubit>(
        () => _i14.ReleaseNotesCubit(gh<_i6.ReleaseNotesRepository>()));
    gh.singleton<_i15.AudioCubit>(_i15.AudioCubit(
      gh<_i11.AudioTransport>(),
      gh<_i5.PcmAudioPlayer>(),
      gh<_i7.SharedPreferences>(),
    ));
    return this;
  }
}

class _$AppModule extends _i16.AppModule {}
