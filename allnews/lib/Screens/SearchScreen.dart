import 'package:allnews/constraints/constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../Models/ProductModel.dart';
import '../ProviderHelper/ArticleProvider.dart';
import '../Widgets/ArticleCard.dart';
import 'DetailsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController(text: "");
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
      await Provider.of<PopularArticlesProvider>(context, listen: false).fetchArticles(category:"",query: _searchController.text);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: blackColor,size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10,left: 8,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Discover',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            Text(
              'News from all over the India',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _searchController,
              autofocus: false,
              onChanged: (value){
                setState(() {
                  reload();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: Colors.grey.shade200,
                filled: true,
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10,),
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
