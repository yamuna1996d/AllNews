import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Models/ProductModel.dart';
import '../Widgets/TitleBold500.dart';
import '../constraints/constraints.dart';

class NewsDetailScreen extends StatelessWidget {
  /*Results object as input, which contains the details of the article.
  It displays the article image (if available), section, title, published date, author,
   and abstract using various Text and Container widgets.*/
  final Results? popularArticles;
   const NewsDetailScreen({Key? key,this.popularArticles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                     image: DecorationImage(
                       image: NetworkImage(popularArticles?.urlToImage??""),
                       fit: BoxFit.cover,
                     ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                      )),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  iconTheme: const IconThemeData(color: Colors.black,size: 35,),
                ),
              ],
            ),
            Details(popularArticles: popularArticles)
          ],
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    Key? key,
    required this.popularArticles,
  }) : super(key: key);

  final Results? popularArticles;
//function for launching url

  launchUrls(String url)async{
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url),);
    }
    throw 'Could not launch $url';
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: grey1, width: 1.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child:
                  Text(
                    popularArticles?.source?.name??"",
                    style: Theme.of(context)
                        .textTheme.labelMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),),
            const SizedBox(height: 5,),
            Text(
              popularArticles?.title??"",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              child: TitleBold500(
                title: "Published Date :  ${popularArticles?.publishedAt}",
                fontSize: 13,
                titleColor: dimBlack,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TitleBold500(
                    title: "By : ${popularArticles?.author??"UnKnown"}",
                    titleColor: grey1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Text(
                popularArticles?.description??'',
                maxLines: 100,
                style:
                Theme.of(context).textTheme.bodyMedium!.
                copyWith(height: 1.5,fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("For complete news : ",style:
              Theme.of(context).textTheme.bodyMedium!.
              copyWith(height: 1.5,fontSize: 15)),
            ),

            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  InkWell(
                      onTap: (){
                       launchUrlString(popularArticles?.url??"");
                      },
                      child: Text(
                        "${popularArticles?.url}",
                        maxLines: 3,
                        style:
                        Theme.of(context).textTheme.bodyMedium!.
                        copyWith(height: 1.5,fontSize: 15,color: Colors.blueAccent,overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Share.share(popularArticles?.url??"");
                    },
                      child: const Icon(Icons.share)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


