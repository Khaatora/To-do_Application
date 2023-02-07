import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/modules/settings/language_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_own/modules/settings/settings_provider/settings_provider.dart';
import 'package:todo_own/shared/styles/colors.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.03,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.language,
              style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showLanguageBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: colorLightBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.langCode == "en" ? "English" : "عربي",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: colorLightGreen,
        context: context,
        builder: (context) {
          return const LangaugeBottomSheet();
        });
  }
}
