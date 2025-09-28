import 'package:dpip/app/settings/notify/_widgets/eew_notify_section.dart';
import 'package:dpip/app/settings/notify/_widgets/sound_list_tile.dart';
import 'package:dpip/app/settings/notify/page.dart';
import 'package:dpip/core/i18n.dart';
import 'package:dpip/models/settings/notify.dart';
import 'package:dpip/widgets/list/list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class SettingsHyperFocusPage extends StatelessWidget {
  const SettingsHyperFocusPage({super.key});

  static const name = 'hyperfocus';
  static const route = '/settings/${SettingsNotifyPage.name}/$name';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Selector<SettingsNotificationModel, EewNotifyType>(
          selector: (context, model) => model.eew,
          builder: (context, value, child) {
            return EewNotifySection(
              value: value,
              onChanged: (value) => context.read<SettingsNotificationModel>().setEew(value),
            );
          },
        ),
        ListSection(
          title: '焦點通知測試',
          children: [
            ListTile(
              title: const Text("地震警報測試"),
              subtitle: const Text("地震警報測試"),
              onTap: () {
                hyperCommunicateBridge.showEEW("");
              },
            ),
          ],
        ),
        SettingsListTextSection(
          icon: Symbols.info_rounded,
          content: '通知測試為在裝置上執行的本地通知，僅用於確認裝置在接收通知時是否能正常播放音效。此測試不會向伺服器發送任何請求'.i18n,
        ),
      ],
    );
  }
}

// ignore: avoid_classes_with_only_static_members
class hyperCommunicateBridge {
  static const MethodChannel _channel = MethodChannel('hypercommunicate');

  static Future<void> showEEW(String input) async {
    await _channel.invokeMethod('eew', {'input': input});
  }
}
