// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flavor/flavor.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;
import 'package:tesla_android/common/di/app_module.dart' as _i12;
import 'package:tesla_android/common/navigation/ta_page_factory.dart' as _i6;
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i9;
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart'
    as _i10;
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart'
    as _i4;
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_loader.dart'
    as _i11;
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart'
    as _i8;
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart'
    as _i7;

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
    gh.factory<_i4.ReleaseNotesRepository>(() => _i4.ReleaseNotesRepository());
    await gh.singletonAsync<_i5.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i6.TAPageFactory>(() => _i6.TAPageFactory());
    gh.factory<_i7.TouchScreenTransport>(
        () => _i7.TouchScreenTransport(gh<_i3.Flavor>()));
    gh.factory<_i8.TouchscreenCubit>(
        () => _i8.TouchscreenCubit(gh<_i7.TouchScreenTransport>()));
    gh.singleton<_i9.ConnectivityCheckCubit>(
        _i9.ConnectivityCheckCubit(gh<_i3.Flavor>()));
    gh.factory<_i10.ReleaseNotesCubit>(
        () => _i10.ReleaseNotesCubit(gh<_i4.ReleaseNotesRepository>()));
    gh.factory<_i11.ReleaseNotesLoader>(
        () => _i11.ReleaseNotesLoader(gh<_i5.SharedPreferences>()));
    return this;
  }
}

class _$AppModule extends _i12.AppModule {}
