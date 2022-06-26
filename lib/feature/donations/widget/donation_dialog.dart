import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class DonationDialog extends StatelessWidget {
  const DonationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        TAPage.donationDialog.title,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.black,
          ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Consider donating in order to fund further development of the project",
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: TADimens.baseContentMargin,
          ),
          SizedBox(
            width: TADimens.donationDialogQRSize,
            height: TADimens.donationDialogQRSize,
            child: QrImage(
              data: "https://tesla-android.gapinski.eu/donations",
              version: QrVersions.auto,
            ),
          ),
        ],
      ),
    );
  }
}
