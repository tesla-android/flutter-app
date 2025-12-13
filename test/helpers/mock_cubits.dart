import 'package:mockito/annotations.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';

import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';

@GenerateMocks([
  SystemConfigurationCubit,
  AudioConfigurationCubit,
  DisplayConfigurationCubit,
  RearDisplayConfigurationCubit,
  GPSConfigurationCubit,
  DeviceInfoCubit,
  ConnectivityCheckCubit,
  DisplayCubit,
  OTAUpdateCubit,
  TouchscreenCubit,
  AudioService,
  ReleaseNotesCubit,
])
void main() {}
