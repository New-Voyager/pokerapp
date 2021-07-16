class IapAppCoinProduct {
  String productId;
  int coins;

  IapAppCoinProduct({
    this.productId,
    this.coins,
  });

  static IapAppCoinProduct fromJson(dynamic data) {
    IapAppCoinProduct coin = new IapAppCoinProduct();
    coin.productId = data['productId'];
    coin.coins = int.parse(data['coins'].toString());
    return coin;
  }
}
