// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flavor/flavor.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

import '../../view/androidViewer/changelog_loader.dart' as _i8;
import '../../view/androidViewer/virtualTouchscreen/cubit/virtual_touchscreen_cubit.dart'
    as _i7;
import '../../view/androidViewer/virtualTouchscreen/transport/virtual_touchscreen_transport.dart'
    as _i6;
import '../navigation/ta_page_factory.dart' as _i5;
import 'app_module.dart' as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  gh.singleton<_i3.Flavor>(appModule.provideFlavor);
  await gh.singletonAsync<_i4.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.factory<_i5.TAPageFactory>(() => _i5.TAPageFactory());
  gh.factory<_i6.VirtualTouchScreenTransport>(
      () => _i6.VirtualTouchScreenTransport(get<_i3.Flavor>()));
  gh.factory<_i7.VirtualTouchscreenCubit>(() =>
      _i7.VirtualTouchscreenCubit(get<_i6.VirtualTouchScreenTransport>()));
  gh.factory<_i8.ChangelogLoader>(
      () => _i8.ChangelogLoader(get<_i4.SharedPreferences>()));
  return get;
}

class _$AppModule extends _i9.AppModule {}
