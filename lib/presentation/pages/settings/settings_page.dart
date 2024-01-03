import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'settings_page_vm.dart';

export 'settings_page_vm.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _buildError(BuildContext context, String error) => Center(
        key: const ValueKey<String>('SettingsPage_error'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(error),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: context.read<SettingsPageVm>().getSettings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsPageVm>(
        builder: (_, SettingsPageVm vm, __) {
          if (vm.isLoading) {
            return _buildLoading();
          } else if (vm.error != null) {
            return _buildError(context, vm.error!);
          }

          final List<String> settings = vm.settings ?? <String>[];

          return ListView.builder(
            itemCount: settings.length,
            itemBuilder: (_, int i) => ListTile(
              key: ValueKey<String>(settings[i]),
              title: Text(settings[i]),
            ),
          );
        },
      ),
    );
  }
}
