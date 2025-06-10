import 'package:flutter/material.dart';

class TABottomSheet extends StatelessWidget {
  final String title;
  final Widget body;

  const TABottomSheet({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: Scaffold(
        body: Column(
          children: [
            _dismissHandle(),
            _title(context),
            Expanded(child: _content()),
          ],
        ),
      ),
    );
  }

  Widget _dismissHandle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
          child: Container(
        width: 100,
        height: 4,
        color: Colors.grey.shade500,
      )),
    );
  }

  Widget _title(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )),
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 1,
                color: Colors.grey.shade500,
              ))
        ],
      ),
    );
  }

  Widget _content() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: body,
    );
  }
}
