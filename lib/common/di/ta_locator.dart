import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'ta_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future configureTADependencies() => $initGetIt(getIt);
