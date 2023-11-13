import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });
  final bool loading;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.deepPurple),
          child: Center(
            child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) : Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
