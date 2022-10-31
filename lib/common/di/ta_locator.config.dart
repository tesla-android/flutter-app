// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:flavor/flavor.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import '../../feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart'
    as _i9;
import '../../feature/androidViewer/touchscreen/transport/touchscreen_transport.dart'
    as _i8;
import '../../feature/releaseNotes/cubit/release_notes_cubit.dart' as _i10;
import '../../feature/releaseNotes/repository/release_notes_repository.dart'
    as _i5;
import '../../feature/releaseNotes/widget/release_notes_loader.dart' as _i11;
import '../navigation/ta_page_factory.dart' as _i7;
import 'app_module.dart' as _i13;
import 'network_module.dart' as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final networkModule = _$NetworkModule();
  final appModule = _$AppModule();
  gh.singleton<_i3.Dio>(networkModule.provideDio);
  gh.singleton<_i4.Flavor>(appModule.provideFlavor);
  gh.factory<_i5.ReleaseNotesRepository>(() => _i5.ReleaseNotesRepository());
  await gh.singletonAsync<_i6.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.factory<_i7.TAPageFactory>(() => _i7.TAPageFactory());
  gh.factory<_i8.TouchScreenTransport>(
      () => _i8.TouchScreenTransport(get<_i4.Flavor>()));
  gh.factory<_i9.TouchscreenCubit>(
      () => _i9.TouchscreenCubit(get<_i8.TouchScreenTransport>()));
  gh.factory<_i10.ReleaseNotesCubit>(
      () => _i10.ReleaseNotesCubit(get<_i5.ReleaseNotesRepository>()));
  gh.factory<_i11.ReleaseNotesLoader>(
      () => _i11.ReleaseNotesLoader(get<_i6.SharedPreferences>()));
  return get;
}

class _$NetworkModule extends _i12.NetworkModule {}

class _$AppModule extends _i13.AppModule {}
