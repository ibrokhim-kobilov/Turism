import 'package:flutter/material.dart';
import 'package:mobileapp/core/components/exporting_packages.dart';

class AuthTextWidget extends StatelessWidget {
  late String text;
  AuthTextWidget({
    Key? key,
    this.text = LocaleKeys.sign_in_to_your_account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Text(
      text.tr(),
      style: TextStyle(
        color: AppColors.primary,
        fontSize: getHeight(40),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
