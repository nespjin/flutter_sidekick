import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fvm/fvm.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/helpers.dart';

import '../../../components/atoms/copy_button.dart';
import '../../../components/atoms/typography.dart';
import '../../common/utils/open_link.dart';

Future<void> showGlobalInfoDialog(BuildContext context) async {
  final configured = await FVMClient.checkIfGlobalConfigured();

  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Heading(
            context.i18n('modules:fvm.dialogs.globalConfiguration'),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(context.i18n('modules:fvm.dialogs.ok')),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Subheading(
                context.i18n('modules:fvm.dialogs.flutterPathIsPointingOn'),
              ),
              // Caption('${configured.currentPath}.\n\n'),
              Flexible(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: configured.currentPath,
                        style: Theme.of(context).textTheme.caption),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: IconButton(
                          icon: const Icon(Icons.copy, size: 14),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: configured.currentPath));
                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(SnackBar(
                            //   content: Text('${configured.currentPath}'),
                            // ));
                          }),
                    )
                  ]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),

              !configured.isSetup
                  ? Column(
                      children: [
                        Subheading(
                          context.i18n('modules:fvm.dialogs.changeThePathTo') +
                              context.i18n(
                                  'modules:fvm.dialogs.ifYouWantToFlutterSdkThroughFvm'),
                        ),
                        Row(
                          children: [
                            Caption(configured.correctPath),
                            CopyButton(configured.correctPath)
                          ],
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  final os = Platform.operatingSystem;
                  openLink(
                    'https://flutter.dev/docs/get-started/install/$os#update-your-path',
                  );
                },
                icon: const Icon(MdiIcons.informationOutline),
                label: Text(
                  context.i18n('modules:fvm.dialogs.howToUpdateYourPath'),
                ),
              )
            ],
          ),
        );
      });
}
