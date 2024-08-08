import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomTileWidget extends StatelessWidget {
  final IconData lead;
  final String label;
  final IconData end;
  final String route;

  const CustomTileWidget({
    super.key,
    required this.lead,
    required this.label,
    required this.route,
    this.end = Icons.arrow_right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).hoverColor),
      child: ListTile(
        leading: Icon(lead),
        title: Text(label),
        trailing: Icon(end),
        onTap: () => context.push(route),
      ),
    );
  }
}
