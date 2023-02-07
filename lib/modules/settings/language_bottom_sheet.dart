import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/modules/settings/settings_provider/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_own/shared/styles/colors.dart';

class LangaugeBottomSheet extends StatelessWidget {
  const LangaugeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              provider.changeLanguage('en');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.english,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: provider.langCode == 'en'
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
            child: Divider(
              color: colorLightBlue,
              thickness: 3,
            ),
          ),
          InkWell(
            onTap: () {
              provider.changeLanguage('ar');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.arabic,
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: provider.langCode == 'ar'
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
