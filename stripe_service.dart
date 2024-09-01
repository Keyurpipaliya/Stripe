
class StripeService {
  static String secretKey = "sk_test_xxxx";
  String publishableKey = "pk_test_xxxx";

  static Future<dynamic> createCheckoutSession(
      List<dynamic> productItems,
      totalAmount,
      ) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

    String lineItems = "";
    int index = 0;

    productItems.forEach(
        (val) {
          var productPrice = (val["productPrice"] * 100).round().toString();
          lineItems
          += "&line_item[$index][price_data][product_data][name]=${val['productName']}&line_items[$index][price_data][unit_amount]=$productPrice";
          lineItems
          += "&line_item[$index][price_data][unit_amount][name]=${val['productName']}&line_items[$index][price_data][unit_amount]=$productPrice";
          lineItems
          += "&line_item[$index][price_data][product_data][name]=${val['productName']}&line_items[$index][price_data][currency]=EUR";
          lineItems += "&line_items[$index][qty]=${val['qty'].toString()}";

          index++;
        },
    );

    final response = await http.post(
        url,
      body: 'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
      headers: {'Authorization': 'Bearer $secretKey',
                'Content-Type': 'appliction/x-www-form-urlencoded'
      },
    );

    return json.decode(response.body)=["id"];
  }
  
  static Future<dynamic> stripePaymentChechout(
      productItems,
      subTotal,
      context,
      mounted, {
        onSuccess,
        onCancel,
        onError,
  }) async {
    final String sessionId = await createCheckoutSession(
        productItems, subTotal
    );

    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publishableKey,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl: "https://checkout.stripe.dev/cancel",
    );

    if(mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfuly',
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }
}