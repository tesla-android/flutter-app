import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/di/ta_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future configureTADependencies() => getIt.init();
