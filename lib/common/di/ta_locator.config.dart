// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:flavor/flavor.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import '../../feature/androidViewer/display/cubit/display_cubit.dart' as _i14;
import '../../feature/androidViewer/display/repository/display_viewer_repository.dart'
    as _i11;
import '../../feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart'
    as _i10;
import '../../feature/androidViewer/touchscreen/transport/touchscreen_transport.dart'
    as _i9;
import '../../feature/releaseNotes/cubit/release_notes_cubit.dart' as _i12;
import '../../feature/releaseNotes/repository/release_notes_repository.dart'
    as _i6;
import '../../feature/releaseNotes/widget/release_notes_loader.dart' as _i13;
import '../navigation/ta_page_factory.dart' as _i8;
import '../network/mjpg_streamer_status_service.dart' as _i5;
import 'app_module.dart' as _i16;
import 'network_module.dart' as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final networkModule = _$NetworkModule();
  final appModule = _$AppModule();
  gh.singleton<_i3.Dio>(networkModule.provideDio);
  gh.singleton<_i4.Flavor>(appModule.provideFlavor);
  gh.factory<_i5.MjpgStreamerStatusService>(
      () => _i5.MjpgStreamerStatusService(get<_i3.Dio>(), get<_i4.Flavor>()));
  gh.factory<_i6.ReleaseNotesRepository>(() => _i6.ReleaseNotesRepository());
  await gh.singletonAsync<_i7.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.factory<_i8.TAPageFactory>(() => _i8.TAPageFactory());
  gh.factory<_i9.TouchScreenTransport>(
      () => _i9.TouchScreenTransport(get<_i4.Flavor>()));
  gh.factory<_i10.TouchscreenCubit>(
      () => _i10.TouchscreenCubit(get<_i9.TouchScreenTransport>()));
  gh.factory<_i11.DisplayViewerRepository>(
      () => _i11.DisplayViewerRepository(get<_i5.MjpgStreamerStatusService>()));
  gh.factory<_i12.ReleaseNotesCubit>(
      () => _i12.ReleaseNotesCubit(get<_i6.ReleaseNotesRepository>()));
  gh.factory<_i13.ReleaseNotesLoader>(
      () => _i13.ReleaseNotesLoader(get<_i7.SharedPreferences>()));
  gh.factory<_i14.DisplayCubit>(
      () => _i14.DisplayCubit(get<_i11.DisplayViewerRepository>()));
  return get;
}

class _$NetworkModule extends _i15.NetworkModule {}

class _$AppModule extends _i16.AppModule {}
