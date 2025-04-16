
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

Widget buildStarRating(double rating) {
  int fullStars = rating.floor(); // Number of full stars
  bool hasHalfStar =
      (rating - fullStars) >= 0.5; // Check if there's a half star
  int emptyStars =
      5 - fullStars - (hasHalfStar ? 1 : 0); // Remaining empty stars

  List<Widget> stars = [];

  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(
      CupertinoIcons.star_fill,
      color: Colors.amber,
      size: 16,
    ));
  }

  if (hasHalfStar) {
    stars.add(const Icon(
      CupertinoIcons.star_lefthalf_fill,
      color: Colors.amber,
      size: 16,
    ));
  }

  for (int i = 0; i < emptyStars; i++) {
    stars.add(const Icon(
      CupertinoIcons.star,
      color: Colors.amber,
      size: 16,
    ));
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: stars,
  );
}

Widget cashFormatter(int cashValue, double fontsize) {
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );

  return Row(
    children: [
      Platform.isIOS
          ? Text(
              "₦",
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: fontsize,
              ),
            )
          : Text(
              "₦",
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: fontsize,
              ),
            ),
      const SizedBox(
        width: 3,
      ),
      if (cashValue.toString().isEmpty)
        ...[]
      else ...[
        Column(
          children: [
            Text(
              formatter.format(cashValue),
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: fontsize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ]
    ],
  );
}


