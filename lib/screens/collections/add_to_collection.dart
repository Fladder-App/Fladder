import 'package:ficonsax/ficonsax.dart';
import 'package:fladder/providers/collections_provider.dart';
import 'package:fladder/screens/shared/adaptive_dialog.dart';
import 'package:fladder/screens/shared/fladder_snackbar.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/widgets/shared/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/screens/shared/outlined_text_field.dart';

Future<void> addItemToCollection(BuildContext context, List<ItemBaseModel> item) {
  return showDialogAdaptive(
    context: context,
    builder: (context) => AddToCollection(
      items: item,
    ),
  );
}

class AddToCollection extends ConsumerStatefulWidget {
  final List<ItemBaseModel> items;
  const AddToCollection({required this.items, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddToCollectionState();
}

class _AddToCollectionState extends ConsumerState<AddToCollection> {
  final TextEditingController controller = TextEditingController();
  late final provider = collectionsProvider;

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
                    label: 'New collection',
                    controller: controller,
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 32),
                IconButton(
                    onPressed: controller.text.isNotEmpty
                        ? () async {
                            await ref.read(provider.notifier).addToNewCollection(
                                  name: controller.text,
                                );
                            setState(() => controller.text = '');
                          }
                        : null,
                    icon: const Icon(Icons.add_rounded)),
                const SizedBox(width: 4),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...collectonOptions.collections.entries.map(
                  (e) {
                    if (e.value != null) {
                      return CheckboxListTile.adaptive(
                        title: Text(e.key.name),
                        value: e.value,
                        onChanged: (value) async {
                          final response = await ref
                              .read(provider.notifier)
                              .toggleCollection(boxSet: e.key, value: value == true, item: widget.items.first);
                          if (context.mounted) {
                            fladderSnackbar(context,
                                title: response.isSuccessful
                                    ? "${value == true ? "Added to" : "Removed from"} ${e.key.name} collection"
                                    : 'Unable to ${value == true ? "add to" : "remove from"} ${e.key.name} collection - (${response.statusCode}) - ${response.base.reasonPhrase}');
                          }
                        },
                      );
                    } else {
                      return ListTile(
                        title: Text(e.key.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final response =
                                    await ref.read(provider.notifier).addToCollection(boxSet: e.key, add: true);
                                if (context.mounted) {
                                  fladderSnackbar(context,
                                      title: response.isSuccessful
                                          ? "Added to ${e.key.name} collection"
                                          : 'Unable to add to ${e.key.name} collection - (${response.statusCode}) - ${response.base.reasonPhrase}');
                                }
                              },
                              child: Icon(Icons.add_rounded, color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
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
