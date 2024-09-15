import 'package:ficonsax/ficonsax.dart';
import 'package:fladder/providers/playlist_provider.dart';
import 'package:fladder/screens/shared/adaptive_dialog.dart';
import 'package:fladder/screens/shared/fladder_snackbar.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/widgets/shared/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/screens/shared/outlined_text_field.dart';

Future<void> addItemToPlaylist(BuildContext context, List<ItemBaseModel> item) {
  return showDialogAdaptive(context: context, builder: (context) => AddToPlaylist(items: item));
}

class AddToPlaylist extends ConsumerStatefulWidget {
  final List<ItemBaseModel> items;
  const AddToPlaylist({required this.items, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends ConsumerState<AddToPlaylist> {
  final TextEditingController controller = TextEditingController();
  late final provider = playlistProvider;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(provider.notifier).setItems(widget.items));
  }

  @override
  Widget build(BuildContext context) {
    final collectonOptions = ref.watch(provider);
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top),
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.items.length == 1)
                        Text(
                          'Add to collection',
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      else
                        Text(
                          'Add ${widget.items.length} item(s) to collection',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      IconButton(
                        onPressed: () => ref.read(provider.notifier).setItems(widget.items),
                        icon: const Icon(IconsaxOutline.refresh),
                      )
                    ],
                  ),
                ),
                if (widget.items.length == 1) ItemBottomSheetPreview(item: widget.items.first),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Flexible(
                  child: OutlinedTextField(
                    label: 'New Playlist',
                    controller: controller,
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 32),
                IconButton(
                    onPressed: controller.text.isNotEmpty
                        ? () async {
                            final response = await ref.read(provider.notifier).addToNewPlaylist(
                                  name: controller.text,
                                );
                            if (context.mounted) {
                              fladderSnackbar(context,
                                  title: response.isSuccessful
                                      ? "Added to new ${controller.text} playlist"
                                      : 'Unable to create new playlist - (${response.statusCode}) - ${response.base.reasonPhrase}');
                            }
                            setState(() => controller.text = '');
                          }
                        : null,
                    icon: const Icon(Icons.add_rounded)),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...collectonOptions.collections.entries.map(
                  (e) {
                    return ListTile(
                      title: Text(e.key.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            onPressed: () async {
                              final response = await ref.read(provider.notifier).addToPlaylist(playlist: e.key);
                              if (context.mounted) {
                                fladderSnackbar(context,
                                    title: response.isSuccessful
                                        ? "Added to ${e.key.name} playlist"
                                        : 'Unable to add to playlist - (${response.statusCode}) - ${response.base.reasonPhrase}');
                              }
                            },
                            icon: Icon(Icons.add_rounded, color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.localized.close),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
