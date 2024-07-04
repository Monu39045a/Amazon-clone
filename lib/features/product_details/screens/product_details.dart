import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;

  // Instance of service
  final ProductDetailsService productDetailsService = ProductDetailsService();

  double avgrating = 0.0;
  double myRating = 0;

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; ++i) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgrating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void addToCart() {
    productDetailsService.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      // initialValue: searchQuery,
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          // beacuse we need a splash effect
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: "Search Aamazon.in",
                        hintStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id!),
                  Stars(rating: avgrating),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 300,
                    autoPlayInterval: const Duration(seconds: 3),
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) => setState(
                      () {
                        _currentImageIndex = index;
                      },
                    ),
                  ),
                  items: widget.product.images.map(
                    (i) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Builder(
                          builder: (BuildContext context) {
                            return Image.network(
                              i,
                              fit: BoxFit.contain,
                              height: 250,
                            );
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 0,
                  right: 0,
                  child: Builder(
                    builder: (context) {
                      int itemCount = widget.product.images.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          itemCount,
                          (index) {
                            return Container(
                              width: 8.0, //Dots width
                              height: 8.0, //Dots height
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4), //space between dots
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == index
                                      ? Colors.blue
                                      : Colors.grey),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // To draw a line
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price : ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${widget.product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(widget.product.description),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: 'Buy Now',
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: 'Add to Cart',
                onTap: addToCart,
                color: const Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Rate this Product',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating, //if already rated then that value else 0
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.secondaryColor,
              ),
              onRatingUpdate: (rating) {
                productDetailsService.rateProduct(
                  context: context,
                  product: widget.product,
                  rating: rating,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
