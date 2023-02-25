import 'package:flutter/material.dart';

class LastInferences extends StatelessWidget {
  final double imgSize;
  final Widget Function(BuildContext, int) itemBuilder;

  const LastInferences(
      {required this.imgSize, required this.itemBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Your last Inferences:",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300),
              ),
            )),

        // Last Inferences Scrollable
        SizedBox(
          height: imgSize,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(0),
            itemCount: 10,
            itemBuilder: (_, i) => itemBuilder(context, i),
            separatorBuilder: (_, i) => const SizedBox(width: 10),
          ),
        ),
      ],
    );
  }
}
