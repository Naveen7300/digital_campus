import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBackDoubleTap;
  final VoidCallback? onBackSingleTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onBackDoubleTap,
    this.onBackSingleTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff026A75),
      leading: onBackDoubleTap != null && onBackSingleTap != null
          ? GestureDetector(
        onDoubleTap: onBackDoubleTap,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCFE3DD)),
          onPressed: onBackSingleTap,
        ),
      )
          : null,
      title: Text(title),
      actions: onMenuPressed != null
          ? [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFFCFE3DD)),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Corrected line
                if (onMenuPressed != null) {
                  onMenuPressed!();
                }
              },
            );
          },
        )
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}