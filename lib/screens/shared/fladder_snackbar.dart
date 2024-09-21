import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

void fladderSnackbar(
  BuildContext context, {
  String title = "",
  bool permanent = false,
  SnackBarAction? action,
  bool showCloseButton = false,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSecondary),
    ),
    clipBehavior: Clip.none,
    showCloseIcon: showCloseButton,
    duration: duration,
    padding: const EdgeInsets.all(18),
    action: action,
  ));
}

void fladderSnackbarResponse(BuildContext context, Response? response, {String? altTitle}) {
  if (response != null) {
    fladderSnackbar(context,
        title: "(${response.base.statusCode}) ${response.base.reasonPhrase ?? "Something went wrong!"}");
    return;
  } else if (altTitle != null) {
    fladderSnackbar(context, title: altTitle);
  }
}

// void _showOverlay(
//   BuildContext context, {
//   required String title,
//   Widget? leading,
//   bool showCloseButton = false,
//   bool permanent = false,
//   Duration duration = const Duration(seconds: 3),
// }) {
//   late OverlayEntry overlayEntry;

//   overlayEntry = OverlayEntry(
//     builder: (context) => _OverlayAnimationWidget(
//       title: title,
//       leading: leading,
//       showCloseButton: showCloseButton,
//       permanent: permanent,
//       duration: duration,
//       overlayEntry: overlayEntry,
//     ),
//   );

//   // Insert the overlay entry into the overlay
//   Overlay.of(context).insert(overlayEntry);
// }

// class _OverlayAnimationWidget extends StatefulWidget {
//   final String title;
//   final Widget? leading;
//   final bool showCloseButton;
//   final bool permanent;
//   final Duration duration;
//   final OverlayEntry overlayEntry;

//   _OverlayAnimationWidget({
//     required this.title,
//     this.leading,
//     this.showCloseButton = false,
//     this.permanent = false,
//     this.duration = const Duration(seconds: 3),
//     required this.overlayEntry,
//   });

//   @override
//   _OverlayAnimationWidgetState createState() => _OverlayAnimationWidgetState();
// }

// class _OverlayAnimationWidgetState extends State<_OverlayAnimationWidget> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;

//   void remove() {
//     // Optionally, you can use a Future.delayed to remove the overlay after a certain duration
//     _controller.reverse();
//     // Remove the overlay entry after the animation completes
//     Future.delayed(Duration(seconds: 1), () {
//       widget.overlayEntry.remove();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 250),
//     );

//     _offsetAnimation = Tween<Offset>(
//       begin: Offset(0.0, 1.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.fastOutSlowIn,
//     ));

//     // Start the animation
//     _controller.forward();

//     Future.delayed(widget.duration, () {
//       if (!widget.permanent) {
//         remove();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: 10 + MediaQuery.of(context).padding.bottom,
//       left: 25,
//       right: 25,
//       child: Dismissible(
//         key: UniqueKey(),
//         direction: DismissDirection.horizontal,
//         confirmDismiss: (direction) async {
//           remove();
//           return true;
//         },
//         child: SlideTransition(
//           position: _offsetAnimation,
//           child: Card(
//             elevation: 5,
//             color: Colors.transparent,
//             surfaceTintColor: Colors.transparent,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.secondaryContainer,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: 45),
//                   child: Row(
//                     children: [
//                       if (widget.leading != null) widget.leading!,
//                       Expanded(
//                         child: Text(
//                           widget.title,
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                               color: Theme.of(context).colorScheme.onSecondaryContainer),
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       if (widget.showCloseButton || widget.permanent)
//                         IconButton(
//                           onPressed: () => remove(),
//                           icon: Icon(
//                             IconsaxOutline.close_square,
//                             size: 28,
//                             color: Theme.of(context).colorScheme.onSecondaryContainer,
//                           ),
//                         )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
