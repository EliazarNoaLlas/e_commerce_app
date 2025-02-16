import 'package:ecommerce/providers/product/search_product_provider.dart';
import 'package:ecommerce/screens/components/product_card.dart';
//import 'package:ecommerce/screens/components/search_bar.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/screens/search/search.dart';
import 'package:ecommerce/constants.dart';

class ProductListPage extends StatefulWidget {
  final String query;

  ProductListPage({required this.query});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  static TextEditingController _controller = TextEditingController();
  SearchProductProvider searchProductProvider = SearchProductProvider();
  ScrollController _sc = ScrollController();

  @override
  void initState() {
    // fetch initial product
    searchProductProvider.fetchData(widget.query);
    super.initState();

    // if scroll's position at maxScrollExtent fetch new products(new page)
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        searchProductProvider.fetchData(widget.query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      body: SafeArea(
        child: _buildList(itemHeight, itemWidth),
      ),
    );
  }

  Widget _buildList(itemHeight, itemWidth) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  // showSearch(context: context, delegate: SearchScreen());
                  pushNewScreen(context,
                      screen: SearchScreen(),
                      pageTransitionAnimation: PageTransitionAnimation.fade);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                      vertical: getProportionateScreenHeight(10)),
                  child: Hero(
                      tag: kSearchBarCategoryTag,
                      child:
                          SearchBar(enabled: false, controller: _controller)),
                ),
              ),
            ),
          ],
        ),
        Flexible(
          child: ChangeNotifierProvider.value(
            value: searchProductProvider,
            child: Consumer<SearchProductProvider>(
              builder: (context, data, index) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      // mainAxisExtent: 250,
                      mainAxisSpacing: getProportionateScreenHeight(5)),
                  controller: _sc,
                  // purpose of itemCount + 1 is progress indicator.
                  // progress indicator is always at the end but it only appears when isLoading=true
                  itemCount: data.productList.length + 1,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == data.productList.length) {
                      return _buildProgressIndicator();
                    }
                    return ProductCard(product: data.productList[index]);
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: searchProductProvider.isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }
}
