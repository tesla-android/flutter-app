// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:flavor/flavor.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../../feature/androidViewer/display/cubit/display_cubit.dart' as _i12;
import '../../feature/androidViewer/display/repository/display_viewer_repository.dart'
    as _i10;
import '../../feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart'
    as _i8;
import '../../feature/androidViewer/touchscreen/transport/touchscreen_transport.dart'
    as _i7;
import '../../feature/releaseNotes/widget/release_notes_loader.dart' as _i11;
import '../navigation/ta_page_factory.dart' as _i6;
import '../network/ustreamer_status_service.dart' as _i9;
import 'app_module.dart' as _i14;
import 'network_module.dart' as _i13; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final networkModule = _$NetworkModule();
  final appModule = _$AppModule();
  gh.singleton<_i3.Dio>(networkModule.provideDio);
  gh.singleton<_i4.Flavor>(appModule.provideFlavor);
  await gh.singletonAsync<_i5.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.factory<_i6.TAPageFactory>(() => _i6.TAPageFactory());
  gh.factory<_i7.TouchScreenTransport>(
      () => _i7.TouchScreenTransport(get<_i4.Flavor>()));
  gh.factory<_i8.TouchscreenCubit>(
      () => _i8.TouchscreenCubit(get<_i7.TouchScreenTransport>()));
  gh.factory<_i9.UstreamerStatusService>(
      () => _i9.UstreamerStatusService(get<_i3.Dio>(), get<_i4.Flavor>()));
  gh.factory<_i10.DisplayViewerRepository>(
      () => _i10.DisplayViewerRepository(get<_i9.UstreamerStatusService>()));
  gh.factory<_i11.ReleaseNotesLoader>(
      () => _i11.ReleaseNotesLoader(get<_i5.SharedPreferences>()));
  gh.factory<_i12.DisplayCubit>(
      () => _i12.DisplayCubit(get<_i10.DisplayViewerRepository>()));
  return get;
}

class _$NetworkModule extends _i13.NetworkModule {}

class _$AppModule extends _i14.AppModule {}
