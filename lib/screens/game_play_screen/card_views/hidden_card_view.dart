import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:provider/provider.dart';

const kDisplacementConstant = 10.0;

class HiddenCardView extends StatelessWidget {
  Widget _buildCardBack() => Container(
        height: AppDimensions.cardHeight * 0.80,
        width: AppDimensions.cardWidth * 0.80,
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              spreadRadius: 2.0,
              blurRadius: 2.0,
            )
          ],
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              const Color(0xff0d4b74),
              const Color(0xff07263a),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    int noOfCards = Provider.of<ValueNotifier<int>>(
      context,
      listen: false,
    ).value;

    return Stack(
      children: List.generate(
        noOfCards,
        (i) => Transform.rotate(
          angle: i * 0.05,
          child: Transform.translate(
            offset: Offset(
              kDisplacementConstant * i,
              0.0,
            ),
            child: _buildCardBack(),
          ),
        ),
      ),
    );
  }
}
