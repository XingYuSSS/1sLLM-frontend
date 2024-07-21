import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });
  final void Function()? onPressed;
  final String label;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // alignment: Alignment.centerLeft,
      width: double.infinity,
      child: TextButton.icon(
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground),
          // backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.background),
          // overlayColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.background.withAlpha(200)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
        ),
        onPressed: onPressed,
        label: Container(alignment: Alignment.center, child: Text(label),),
        icon: icon,
      ),
    );
  }
}