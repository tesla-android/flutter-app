// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flavor/flavor.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../../feature/androidViewer/display/cubit/display_cubit.dart' as _i13;
import '../../feature/androidViewer/display/transport/display_transport.dart'
    as _i10;
import '../../feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart'
    as _i8;
import '../../feature/androidViewer/touchscreen/transport/touchscreen_transport.dart'
    as _i7;
import '../../feature/connectivityCheck/cubit/connectivity_check_cubit.dart'
    as _i9;
import '../../feature/releaseNotes/cubit/release_notes_cubit.dart' as _i11;
import '../../feature/releaseNotes/repository/release_notes_repository.dart'
    as _i4;
import '../../feature/releaseNotes/widget/release_notes_loader.dart' as _i12;
import '../navigation/ta_page_factory.dart' as _i6;
import 'app_module.dart' as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  gh.singleton<_i3.Flavor>(appModule.provideFlavor);
  gh.factory<_i4.ReleaseNotesRepository>(() => _i4.ReleaseNotesRepository());
  await gh.singletonAsync<_i5.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.factory<_i6.TAPageFactory>(() => _i6.TAPageFactory());
  gh.factory<_i7.TouchScreenTransport>(
      () => _i7.TouchScreenTransport(get<_i3.Flavor>()));
  gh.factory<_i8.TouchscreenCubit>(
      () => _i8.TouchscreenCubit(get<_i7.TouchScreenTransport>()));
  gh.singleton<_i9.ConnectivityCheckCubit>(
      _i9.ConnectivityCheckCubit(get<_i3.Flavor>()));
  gh.factory<_i10.DisplayTransport>(
      () => _i10.DisplayTransport(get<_i3.Flavor>()));
  gh.factory<_i11.ReleaseNotesCubit>(
      () => _i11.ReleaseNotesCubit(get<_i4.ReleaseNotesRepository>()));
  gh.factory<_i12.ReleaseNotesLoader>(
      () => _i12.ReleaseNotesLoader(get<_i5.SharedPreferences>()));
  gh.singleton<_i13.DisplayCubit>(
      _i13.DisplayCubit(get<_i10.DisplayTransport>()));
  return get;
}

class _$AppModule extends _i14.AppModule {}
