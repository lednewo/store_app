import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:verify_local_purchase/verify_local_purchase.dart';

class InAppPurchaseService {
  static final InAppPurchase _iap = InAppPurchase.instance;

  // IDs dos produtos (consumíveis)
  static const String miniPackId = 'mini';
  static const String basicPackId = 'basic_1';
  static const String proPackId = 'pro_1';
  static const String ultraPackId = 'ultra';

  // IDs das assinaturas (não-consumíveis)
  static const String basicWeeklySubscriptionId = 'basic_semanal';

  static const Set<String> _productIds = {
    miniPackId,
    basicPackId,
    proPackId,
    ultraPackId,
  };

  static const Set<String> _subscriptionIds = {
    basicWeeklySubscriptionId,
  };

  /// Verifica se compras in-app estão disponíveis no dispositivo
  Future<bool> isAvailable() async {
    return _iap.isAvailable();
  }

  /// Carrega produtos consumíveis disponíveis na loja
  Future<List<ProductDetails>> loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds);
    if (response.error != null) {
      throw Exception('Erro ao carregar produtos: ${response.error}');
    }
    return response.productDetails;
  }

  /// Carrega assinaturas disponíveis na loja
  Future<List<ProductDetails>> loadSubscriptions() async {
    final response = await _iap.queryProductDetails(_subscriptionIds);
    if (response.error != null) {
      throw Exception('Erro ao carregar assinaturas: ${response.error}');
    }
    return response.productDetails;
  }

  /// Inicia compra de produto consumível (pacote de tokens, créditos, etc.)
  Future<bool> buyProduct(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    return _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  /// Inicia compra de assinatura ou produto não-consumível
  Future<bool> buyProductSubscription(ProductDetails productDetails) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Verifica compra consumível localmente via verify_local_purchase
  /// Chama completePurchase após validação (obrigatório no Android)
  Future<bool> verifyPurchase(PurchaseDetails purchase) async {
    final token = getOneTimePurchaseToken(purchase);
    final isValid = await VerifyLocalPurchase().verifyPurchase(token);
    if (isValid) {
      await _iap.completePurchase(purchase);
    }
    return isValid;
  }

  /// Verifica assinatura localmente via verify_local_purchase
  /// NÃO chama completePurchase para assinaturas
  Future<bool> verifySubscription(PurchaseDetails purchase) async {
    final token = getSubscriptionToken(purchase);
    final isValid = await VerifyLocalPurchase().verifySubscription(token);
    if (isValid) {
      await _iap.completePurchase(purchase);
    }
    return isValid;
  }

  /// Restaura compras anteriores (assinaturas e não-consumíveis)
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Stream de atualizações de compras.
  /// Deve ser escutado durante toda a sessão.
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  /// Retorna true se o productId pertence ao conjunto de assinaturas
  bool isSubscriptionProduct(String productId) {
    return _subscriptionIds.contains(productId);
  }

  /// Extrai a quantidade de tokens da descrição do produto
  int getTokensFromDescription(String description) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(description);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }
}
