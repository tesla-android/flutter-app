import 'package:flavor/flavor.dart';
import 'flavor_factory_stub.dart'
    if (dart.library.js_interop) 'flavor_factory_web.dart';

class FlavorFactory {
  static Flavor create() => createFlavor();
}
