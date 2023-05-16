enum SoftApBandType {
  band2_4GHz(
    name: "2.4 GHz",
    band: 1,
    channel: 6,
    channelWidth: 2,
  ),
  band5GHz(
    name: "5 GHZ",
    band: 2,
    channel: 36,
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
}
