import 'package:ecommerce/models/minimal_product.dart';
import 'package:ecommerce/providers/UserProvider.dart';
import 'package:ecommerce/screens/details/product_detail.dart';
import 'package:ecommerce/services/product/favourite_product_api.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final double width, aspectRatio;
  final MinimalProduct product;
  //final Product product;
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.product,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  void _postFavourite() async {
    await FavouriteProductApi().postData(
        widget.product.id,
        widget.product.isFavourite
            ? FavouriteProductAction.remove
            : FavouriteProductAction.add);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenWidth(4)),
        child: SizedBox(
          width: getProportionateScreenWidth(widget.width),
          child: GestureDetector(
            onTap: () {
              pushNewScreen(
                context,
                screen: ProductDetail(productId: widget.product.id),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            }, // redirect to product detail page
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AspectRatio(
                  aspectRatio: 1.02,
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10.0)),
                    decoration: BoxDecoration(
                        // color: Color(0xFF979797).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Image.network(
                      widget.product.image,
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  widget.product.title,
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //if product has discount price
                        Text(
                          widget.product.discountPrice != 0.0
                              ? '\$${widget.product.discountPrice}'
                              : '\$${widget.product.price}',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF979797),
                          ),
                        ),
                        widget.product.discountPrice != 0.0
                            ? Text(
                                '\$${widget.product.price}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness:
                                      getProportionateScreenHeight(2.85),
                                  fontSize: getProportionateScreenWidth(10),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),

                    // if user is logged in show inkwell(favourite(hear)) or empty box
                    Provider.of<UserProvider>(context).isLoggedIn
                        ? InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              setState(() {
                                _postFavourite();
                                widget.product.isFavourite =
                                    !widget.product.isFavourite;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(
                                  getProportionateScreenWidth(8)),
                              height: getProportionateScreenWidth(28),
                              width: getProportionateScreenWidth(28),
                              decoration: BoxDecoration(
                                  color: widget.product.isFavourite
                                      ? Color(0xFF979797).withOpacity(0.15)
                                      : Color(0xFF979797).withOpacity(0.1),
                                  shape: BoxShape.circle),
                              child: SvgPicture.asset(
                                'assets/icons/heart.svg',
                                color: widget.product.isFavourite
                                    ? Color(0xFFFF4848)
                                    : Color(0xFFDBDEE4),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
