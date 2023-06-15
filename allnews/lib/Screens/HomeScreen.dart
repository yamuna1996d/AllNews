import 'package:allnews/Screens/SearchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../Models/ProductModel.dart';
import '../ProviderHelper/ArticleProvider.dart';
import '../Widgets/ArticleCard.dart';
import '../constraints/constraints.dart';
import 'DetailsPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String _selectedCategory = "general";
  static const _pageSize = 10;
  bool _isLast = false;
  //The PagingController class is used to manage pagination and provide the items to be displayed in the PagedGridView
  final PagingController<int, Results> _pagingController =
  PagingController(firstPageKey: 1);

  reload() {
    Provider.of<PopularArticlesProvider>(context, listen: false).resetPage();
    _pagingController.refresh();
    setState(() {});
  }

  @override
  void initState() {
    Provider.of<PopularArticlesProvider>(context, listen: false).resetPage();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
      await Provider.of<PopularArticlesProvider>(context, listen: false).fetchArticles(category: _selectedCategory);
      setState(() {
        _isLast = newItems.length < _pageSize;
      });
      if (_isLast) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title:  Text("Top Headlines in INDIA",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold,fontSize: 20),),
          actions: [
            IconButton(
              icon: const Icon(Icons.search,color: blackColor,),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.category,color: blackColor,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Category'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: const [
                            DropdownMenuItem(
                              value: 'general',
                              child: Text('General'),
                            ),
                            DropdownMenuItem(
                              value: 'business',
                              child: Text('Business'),
                            ),
                            DropdownMenuItem(
                              value: 'technology',
                              child: Text('Technology'),
                            ),
                            DropdownMenuItem(
                              value: 'health',
                              child: Text('Health'),
                            ),
                            DropdownMenuItem(
                              value: 'entertainment',
                              child: Text('Entertainment'),
                            ),
                            DropdownMenuItem(
                              value: 'sports',
                              child: Text('Sports'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value??"";
                              reload();
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },),
          ],
        ),
        body:  Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  // The onRefresh callback is used to refresh the data displayed in the grid when the user pulls down on the screen.
                  // The resetPage method of the HomeProvider is called to reset the current page to 1,
                  // and the refresh method of the PagingController is called to fetch the new data.
                    onRefresh: () {
                      Provider.of<PopularArticlesProvider>(context, listen: false)
                          .resetPage();
                      return Future.sync(() {
                        _pagingController.refresh();
                      });
                    },
                    child: PagedListView<int, Results>(
                      pagingController: _pagingController,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      builderDelegate: PagedChildBuilderDelegate(
                        animateTransitions: true,
                        itemBuilder: (context, item, index) {
                          return ArticleCard(
                                              image: item.urlToImage,
                                              title: item.title,
                                              publishedDate: item.publishedAt,
                                              byline: item.author,
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                                  popularArticles: item,
                                                )));
                        });},
                        firstPageProgressIndicatorBuilder: (context) =>
                        const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.red,
                            radius: 20,
                          ),
                        ),
                        //AppLoader(),
                        newPageProgressIndicatorBuilder: (context) =>
                        const Center(
                          child: CupertinoActivityIndicator(
                            radius: 20,
                            color: Colors.red,
                          ),
                        ),
                        noItemsFoundIndicatorBuilder: (context) =>
                        const Center(child: Text("No Data Found")),
                      ),
                    )),
              ),
            ],
          ),
        ),
    );
  }
}
