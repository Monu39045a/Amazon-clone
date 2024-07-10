import 'package:amazon_clone/features/cart/services/cart_service.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];

    // final product = Product.fromMap(productCart);
    // The above assignment is wrong as ir consist {Product : {} ,quantity:} we only can convert Product that's why we were getting error

    final product = Product.fromMap(productCart['product']);

    final ProductDetailsService productDetailsService = ProductDetailsService();
    final CartService cartService = CartService();

    void increaseQuantity(Product product) {
      productDetailsService.addToCart(
        context: context,
        product: product,
      );
    }

    void decreaseQuantity(Product product) {
      cartService.removeFromCart(
        context: context,
        product: product,
      );
    }

    // double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    product.images[0],
                    fit: BoxFit.contain,
                    height: 180,
                    width: 150,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Error loading image'));
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      // width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '\$${product.price}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      // width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: const Text(
                        'Eligible for Free Shipping',
                      ),
                    ),
                    Container(
                      // width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: const Text(
                        'In Stock',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Container(
                      // width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.5, //width of border
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black12,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => decreaseQuantity(product),
                                  child: Container(
                                    width: 35,
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.remove,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 35,
                                  height: 32,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${productCart['quantity']}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => increaseQuantity(product),
                                  child: Container(
                                    width: 35,
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.add,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
