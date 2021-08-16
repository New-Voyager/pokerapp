class AnimationObject {
  final String id;
  final String assetSvg;
  final String assetJson;

  const AnimationObject({
    this.id,
    this.assetSvg,
    this.assetJson,
  });
}

class AnimationAssets {
  AnimationAssets._();

  static const String _base = 'assets/animations';

  static const bombPotAnimation = '$_base/bombpot.json';

  static const List<AnimationObject> animationObjects = const [
    const AnimationObject(
      id: 'chicken',
      assetSvg: '$_base/chicken.svg',
      assetJson: '$_base/chicken.json',
    ),
    const AnimationObject(
      id: 'donkey',
      assetSvg: '$_base/donkey.svg',
      assetJson: '$_base/donkey.json',
    ),
    const AnimationObject(
      id: 'fish',
      assetSvg: '$_base/fish.svg',
      assetJson: '$_base/fish.json',
    ),
    const AnimationObject(
      id: 'poop',
      assetSvg: '$_base/poop.svg',
      assetJson: '$_base/poop.json',
    ),
    const AnimationObject(
      id: 'rat',
      assetSvg: '$_base/rat.svg',
      assetJson: '$_base/rat.json',
    ),
    const AnimationObject(
      id: 'gorilla',
      assetSvg: '$_base/gorilla.svg',
      assetJson: '$_base/gorilla.json',
    ),
  ];
}
