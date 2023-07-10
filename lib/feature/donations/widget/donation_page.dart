import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/components/ta_app_bar.dart';
import 'package:tesla_android/common/ui/components/ta_bottom_navigation_bar.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaAppBar(
        title: TAPage.donations.title,
      ),
      bottomNavigationBar: const TaBottomNavigationBar(currentIndex: 3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: TADimens.donationTextWidth,
              child: Text(
                "Thank you for considering a donation to support the ongoing development of Tesla Android. As a community-founded project, your contribution can truly make a difference!",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: TADimens.baseContentMargin,
            ),
            SizedBox(
              width: TADimens.donationQRSize,
              height: TADimens.donationQRSize,
              child: QrImageView(
                data: "https://teslaandroid.com/donations",
                version: QrVersions.auto,
              )
            ),
          ],
        ),
      ),
    );
  }
}
