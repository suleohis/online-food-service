import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  static const ID = "id";
  static const NAME = "name";
  static const AVG_PRICE = "avgPrice";
  static const RATING = "rating";
  static const RATES = "rates";
  static const IMAGE = "image";
  static const POPULAR = "popular";
  static const USER_LIKES = "userLikes";
  static const OWNER = 'owner';
  static const OWNERID = 'ownerId';

  final String? id;
  final String? name;
  final String? image;
  final List? userLikes;
  final int? rating;
  final int? avgPrice;
  final bool? popular;
  final int? rates;
  final String? owner;
  final String? ownerId;
  final int? totalAmount;

//  getters
  RestaurantModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.userLikes,
      required this.rating,
      required this.avgPrice,
      required this.popular,
      required this.rates,
      required this.owner,
      required this.ownerId,
      required this.totalAmount});

  // public variable
  bool? liked = false;

  factory RestaurantModel.fromSnapshot(DocumentSnapshot<dynamic> snapshot) {
    return RestaurantModel(
        id: snapshot.data()[ID],
        name: snapshot.data()[NAME],
        image: snapshot.data()[IMAGE],
        avgPrice: snapshot.data()[AVG_PRICE],
        rating: snapshot.data()[RATING],
        popular: snapshot.data()[POPULAR],
        rates: snapshot.data()[RATES],
        owner: snapshot.data()[OWNER],
        ownerId: snapshot.data()[OWNERID],
        userLikes: snapshot.data()[USER_LIKES],
      totalAmount: snapshot.data()['totalAmount']
    );
  }
}
