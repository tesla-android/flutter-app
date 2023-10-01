import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';

class UpdateButton extends StatelessWidget with Logger {
  const UpdateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OTAUpdateCubit, OTAUpdateState>(
        builder: (context, state) {
      if (state is OTAUpdateStateAvailable) {
        return IconButton(
          color: Colors.amber,
          onPressed: () {
            dispatchAnalyticsEvent(
              eventName: "update_button_tapped",
              props: {},
            );
            BlocProvider.of<OTAUpdateCubit>(context).launchUpdater();
          },
          icon: const Icon(
            Icons.download_rounded,
            size: TADimens.statusBarIconSize,
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
