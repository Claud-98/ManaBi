import 'package:flutter/material.dart';
import 'package:manabi/repositories/kanji_repository.dart';
import 'package:manabi/services/SharedPreferencesManager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _romaji = false;

  @override
  void initState() {
    super.initState();
    _loadRomajiState();
  }

  _loadRomajiState() async {
   bool _romaji = await KanjiRepository().getRomajiState();
    setState(() {
      this._romaji = _romaji ;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translatedStrings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(translatedStrings.settingsUpperCase),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CheckboxListTile(
                value: _romaji,
                title: Text(translatedStrings.romaji),
                subtitle: Text(translatedStrings.romajiFunctionDescription),
                onChanged: (value){
                  setState(() {
                    _romaji = value;
                    SharedPreferencesManager.saveKV(
                        SharedPreferencesManager.romajiKey, value);
                  });
                }
            ),
            Divider(),
            CheckboxListTile(
                title: Text(translatedStrings.disableNotifications),
                value: false,
                onChanged: null),
            Divider(),
            ListTile(
              title: Text(translatedStrings.about),
              onTap: (){},
            ),
            Divider(),
          ],

        ),
      ),
    );
  }
}
