import 'package:flutter/material.dart';

class QuickAction {
  final String label;
  final IconData icon;

  const QuickAction({required this.label, required this.icon});
}

class QuickActionsBar extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsBar({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions
          .map(
            (a) => Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(a.icon, size: 18),
                  label: Text(a.label, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
