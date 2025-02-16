import 'package:ecommerce/constants.dart';
import 'package:ecommerce/models/minimal_product.dart';
import 'package:ecommerce/providers/UserProvider.dart';
import 'package:ecommerce/providers/order_provider.dart';
import 'package:ecommerce/providers/persistent_tab_provider.dart';
import 'package:ecommerce/providers/product/product_provider.dart';
import 'package:ecommerce/screens/components/rounded_button.dart';
import 'package:ecommerce/screens/details/components/product_description.dart';
import 'package:ecommerce/screens/details/components/product_image_carousel.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final int productId;

  ProductDetail({required this.productId});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProductProvider productProvider = ProductProvider();

  @override
  void initState() {
    productProvider.fetchProduct(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: productProvider,
      child: Consumer<ProductProvider>(
        builder: (context, data, _) {
          if (productProvider.isLoading) {
            return ModalProgressHUD(
              inAsyncCall: true,
              child: Container(
                color: Colors.white,
              ),
            );
          } else {
            // when api fetches the future and if it is not loading, product detail screen will appear
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  data.product!.title,
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                actions: [
                  Provider.of<UserProvider>(context).isLoggedIn
                      ? IconButton(
                          onPressed: () {
                            data.postFavourite();
                          },
                          icon: Icon(
                            CupertinoIcons.heart_fill,
                            color: data.product!.isFavourite
                                ? Colors.red
                                : Colors.black.withOpacity(0.3),
                          ),
                        )
                      : SizedBox(),
                ],
                backgroundColor: Color(0xFFFFF),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(15),
                      vertical: getProportionateScreenWidth(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        data.product!.title,
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(14)),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      ProductImageCarousel(
                        product: data.product!,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(14),
                      ),
                      ProductDescription(
                        price: data.product!.price,
                        discountPrice: data.product!.discountPrice,
                        description: data.product!.description,
                      ),
                      Padding(
                        padding: kButtonDefaultEdgeInsets(),
                        child: RoundedButton(
                          primaryColor: Colors.white,
                          bgColor: Colors.lightBlueAccent,
                          title: 'Add to cart',
                          onPressed: () async {
                            // if user is not logged in redirect to account screen for authentication
                            // otherwise add product to cart
                            if (!Provider.of<UserProvider>(context,
                                    listen: false)
                                .isLoggedIn) {
                              Provider.of<PersistentTabProvider>(context,
                                      listen: false)
                                  .changeTab(3);
                            } else {
                              await Provider.of<OrderProvider>(context,
                                      listen: false)
                                  .postOrderProduct(MinimalProduct(
                                      id: data.product!.id,
                                      title: data.product!.title,
                                      image: data.product!.images[0],
                                      price: data.product!.price,
                                      discountPrice:
                                          data.product!.discountPrice));
                              Provider.of<PersistentTabProvider>(context,
                                      listen: false)
                                  .changeTab(2);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
