import 'package:flutter/material.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class DonationButton extends StatelessWidget {
  const DonationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TADimens.basePaddingHorizontal,
      child: MaterialButton(
        color: Colors.red.shade700,
        onPressed: () => TANavigator.push(
          context: context,
          page: TAPage.donationDialog,
        ),
        child: const SizedBox(
            width: double.infinity,
            child: Text(
              "Support the project",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}