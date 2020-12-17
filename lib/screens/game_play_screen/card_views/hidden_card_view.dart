import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

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
    return Stack(
      children: [
        _buildCardBack(),
        Transform.rotate(
          angle: 0.05,
          child: Transform.translate(
            offset: Offset(10.0, 0.0),
            child: _buildCardBack(),
          ),
        ),
      ],
    );
  }
}
