import 'package:allnews/constraints/TitleBold500.dart';
import 'package:flutter/material.dart';

import '../constraints/constraints.dart';

class ArticleCard extends StatelessWidget {
  String? title, byline, publishedDate,image;
  final void Function()? onTap;
  ArticleCard(
      {Key? key, this.byline, this.onTap, this.title, this.publishedDate,this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(right: 10,left: 10),
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    blurRadius: 10.0,
                    spreadRadius: 0.5,
                    offset: const Offset(
                      0.8,
                      10.0,
                    ),
                  )
                ],
              ),
              child: Card(
                child: Container(
                  height: 160,
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 135,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TitleBold500(
                                  title: title ?? "",
                                  fontSize: 15,
                                  maxLines: 4,
                                  titleColor: blackColor,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TitleBold500(
                                  title: publishedDate ?? "",
                                  maxLines: 3,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: TitleBold500(
                                    title: byline ?? "",
                                    maxLines: 3,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            Container(
              height: 170,
              width: 135,
              margin: const EdgeInsets.only(
                left: 10,
                top: 7,
                bottom: 5
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      image??'',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
