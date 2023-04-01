// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flavor/flavor.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;
import 'package:tesla_android/common/di/app_module.dart' as _i15;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i7;
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart' as _i14;
import 'package:tesla_android/feature/audio/transport/audio_transport.dart'
    as _i10;
import 'package:tesla_android/feature/audio/utils/pcm_player.dart' as _i4;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i11;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i12;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i5;
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_loader.dart'
    as _i13;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i9;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i8;

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
    gh.factory<_i4.PcmAudioPlayer>(() => _i4.PcmAudioPlayer());
    gh.factory<_i5.ReleaseNotesRepository>(() => _i5.ReleaseNotesRepository());
    await gh.singletonAsync<_i6.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i7.TAPageFactory>(() => _i7.TAPageFactory());
    gh.factory<_i8.TouchScreenTransport>(
        () => _i8.TouchScreenTransport(gh<_i3.Flavor>()));
    gh.factory<_i9.TouchscreenCubit>(
        () => _i9.TouchscreenCubit(gh<_i8.TouchScreenTransport>()));
    gh.factory<_i10.AudioTransport>(
        () => _i10.AudioTransport(gh<_i3.Flavor>()));
    gh.singleton<_i11.ConnectivityCheckCubit>(
        _i11.ConnectivityCheckCubit(gh<_i3.Flavor>()));
    gh.factory<_i12.ReleaseNotesCubit>(
        () => _i12.ReleaseNotesCubit(gh<_i5.ReleaseNotesRepository>()));
    gh.factory<_i13.ReleaseNotesLoader>(
        () => _i13.ReleaseNotesLoader(gh<_i6.SharedPreferences>()));
    gh.factory<_i14.AudioCubit>(() => _i14.AudioCubit(
          gh<_i10.AudioTransport>(),
          gh<_i4.PcmAudioPlayer>(),
        ));
    return this;
  }
}

class _$AppModule extends _i15.AppModule {}
