import 'package:flutter/material.dart';
import 'package:gemography_mobile_challenge/styles/textstyle.dart';

class RepoItem extends StatelessWidget {
  const RepoItem(
      {Key key,
      @required this.title,
      @required this.author,
      @required this.description,
      @required this.stars,
      this.imageLink})
      : super(key: key);

  final String title;
  final String description;
  final String imageLink;
  final String author;
  final String stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GTextStyle.bold.copyWith(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description ?? "",
            style: GTextStyle.normal.copyWith(fontSize: 18),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.network(
                imageLink,
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                author,
                style: GTextStyle.bold.copyWith(fontSize: 16),
              ),
              Spacer(),
              Icon(
                Icons.star,
                color: Colors.black,
              ),
              Text(stars)
            ],
          )
        ],
      ),
    );
  }
}
