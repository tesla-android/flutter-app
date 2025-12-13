enum SoftApBandType {
  band2_4GHz(name: "2.4 GHz", band: 1, channel: 6, channelWidth: 2),
  band5GHz36(name: "5 GHZ - Channel 36", band: 2, channel: 36, channelWidth: 3),
  band5GHz44(name: "5 GHZ - Channel 44", band: 2, channel: 44, channelWidth: 3),
  band5GHz149(
    name: "5 GHZ - Channel 149",
    band: 2,
    channel: 149,
    channelWidth: 3,
  ),
  band5GHz157(
    name: "5 GHZ - Channel 157",
    band: 2,
    channel: 157,
    channelWidth: 3,
  );

  const SoftApBandType({
    required this.name,
    required this.band,
    required this.channel,
    required this.channelWidth,
  });

  // packages/modules/Wifi/framework/java/android/net/wifi/SoftApConfiguration.java
  final int band;
  final int channel;

  // packages/modules/Wifi/framework/java/android/net/wifi/SoftApInfo.java
  final int channelWidth;
  final String name;

  static SoftApBandType matchBandTypeFromConfig({
    required int band,
    required int channel,
    required int channelWidth,
  }) {
    if (band == 1) {
      return SoftApBandType.band2_4GHz;
    }
    switch (channel) {
      case 36:
        return SoftApBandType.band5GHz36;
      case 44:
        return SoftApBandType.band5GHz44;
      case 149:
        return SoftApBandType.band5GHz149;
      case 157:
        return SoftApBandType.band5GHz157;
      default:
        return SoftApBandType.band5GHz36;
    }
  }
}
