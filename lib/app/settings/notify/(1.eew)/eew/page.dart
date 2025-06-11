import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:provider/provider.dart';

import 'package:dpip/widgets/list/list_section.dart';
import 'package:dpip/app/settings/notify/_widgets/eew_notify_section.dart';
import 'package:dpip/app/settings/notify/_widgets/sound_list_tile.dart';
import 'package:dpip/app/settings/notify/page.dart';
import 'package:dpip/models/settings/notify.dart';
import 'package:dpip/utils/extensions/build_context.dart';

class SettingsNotifyEewPage extends StatelessWidget {
  const SettingsNotifyEewPage({super.key});

  static const name = 'eew';
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
        const ListSection(
          title: '音效測試',
          children: [
            SoundListTile(
              title: '緊急地震速報(重大)',
              subtitle: Text('最大震度 5 弱以上 且\n所在地(鄉鎮)預估震度 4 以上'),
              type: 'eew_alert-important',
            ),
            SoundListTile(
              title: '緊急地震速報(一般)',
              subtitle: Text( '最大震度 5 弱以上 且\n所在地(鄉鎮)預估震度 2 以上'),
              type: 'eew_alert-general',
            ),
            SoundListTile(
              title: '緊急地震速報(無聲)',
              subtitle: Text('最大震度 5 弱以上 且\n所在地(鄉鎮)預估震度 1 以上'),
              type: 'eew_alert-silent',
            ),
            SoundListTile(
              title: '地震速報(重大)',
              subtitle: Text('所在地(鄉鎮)預估震度 4 以上'),
              type: 'eew-important',
            ),
            SoundListTile(
              title: '地震速報(一般)',
              subtitle: Text('所在地(鄉鎮)預估震度 2 以上'),
              type: 'eew-general',
            ),
            SoundListTile(
              title: '地震速報(無聲)',
              subtitle: Text('所在地(鄉鎮)預估震度 1 以上'),
              type: 'eew-silence',
            ),
          ],
        ),
        const SettingsListTextSection(
          icon: Symbols.info_rounded,
          content: '音效測試為在裝置上執行的本地通知，僅用於確認裝置在接收通知時是否能正常播放音效。此測試不會向伺服器發送任何請求',
        ),
      ],
    );
  }
}
