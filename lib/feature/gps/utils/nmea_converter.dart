import 'package:location/location.dart';

class NmeaConverter {
  static String locationToNMEA(LocationData locationData) {
    if (locationData.latitude == null ||
        locationData.longitude == null ||
        locationData.accuracy == null) {
      throw Exception("Invalid locationData");
    }
    // Calculate latitude in NMEA format (ddmm.mmmm)
    double latitude = locationData.latitude!.abs();
    double latDegrees = latitude.floorToDouble();
    double latMinutes = (latitude - latDegrees) * 60;
    String latDirection = locationData.latitude! >= 0 ? 'N' : 'S';
    String latitudeStr =
        '$latDegrees${latMinutes.toStringAsFixed(4)}$latDirection';

    // Calculate longitude in NMEA format (dddmm.mmmm)
    double longitude = locationData.longitude!.abs();
    double lonDegrees = longitude.floorToDouble();
    double lonMinutes = (longitude - lonDegrees) * 60;
    String lonDirection = locationData.longitude! >= 0 ? 'E' : 'W';
    String longitudeStr =
        '$lonDegrees${lonMinutes.toStringAsFixed(4)}$lonDirection';

    // Calculate GPS fix quality
    int fixQuality = 1; // Assuming we have a GPS fix
    if (locationData.accuracy! > 100) {
      fixQuality = 0; // No fix
    }

    // Build the GGA sentence
    String sentence =
        'GPGGA,${locationData.time?.toStringAsFixed(3)},$latitudeStr,$longitudeStr,$fixQuality,${locationData.accuracy!.toStringAsFixed(2)},M,0.0,M,,';
    int checksum = 0;
    for (int i = 0; i < sentence.length; i++) {
      checksum ^= sentence.codeUnitAt(i);
    }
    String hexChecksum =
        checksum.toRadixString(16).toUpperCase().padLeft(2, '0');
    return '\$$sentence*$hexChecksum\r\n';
  }
}
