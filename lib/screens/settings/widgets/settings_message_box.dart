import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MessageType {
  info,
  warning,
  error;

  Color color(BuildContext context) {
    switch (this) {
      case info:
        return Theme.of(context).colorScheme.surface;
      case warning:
        return Theme.of(context).colorScheme.primaryContainer;
      case error:
        return Theme.of(context).colorScheme.errorContainer;
    }
  }
}

class SettingsMessageBox extends ConsumerWidget {
  final String message;
  final MessageType messageType;
  const SettingsMessageBox(this.message, {this.messageType = MessageType.info, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).add(
          EdgeInsets.symmetric(
            horizontal: MediaQuery.paddingOf(context).horizontal,
          ),
        ),
        child: Card(
          elevation: 2,
          color: messageType.color(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
        ),
      ),
    );
  }
}
