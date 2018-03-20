import 'http.dart';
import '../model/city.dart';
import '../model/place.dart';
import '../model/food_type.dart';
import '../model/restaurant.dart';
import '../model/support.dart';

class Api {
  static final String _host = 'http://cangdu.org:8001';

  static getGuessCity() async {
    City city;
    var uri = Uri.parse('$_host/v1/cities?type=guess');
    try {
      var data = await HttpUtils.httpGetJson(uri);
      city = new City.fromJson(data);
    } catch (e) {
      print('getGuessCity error: $e');
    }
    return city;
  }

  static getHotCities() async {
    var cities = const [];
    var uri = Uri.parse('$_host/v1/cities?type=hot');
    try {
      var data = (await HttpUtils.httpGetJson(uri)) as List;
      cities = data.map((item) {
        return new City.fromJson(item);
      }).toList();
    } catch (e) {
      print('getHotCites error: $e');
    }
    return cities;
  }

  static getCitiesGroup() async {
    var citiesGroup = new Map<String, List>();
    var uri = Uri.parse('$_host/v1/cities?type=group');
    try {
      var data = (await HttpUtils.httpGetJson(uri)) as Map<String, List>;
      for (String key in data.keys) {
        citiesGroup[key] = data[key].map((item) {
          return new City.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('getCitesGroup error: $e');
    }
    return citiesGroup;
  }

  static getCityById(int id) async {
    City city;
    try {
      var uri = Uri.parse('$_host/v1/cities/${id.toString()}');
      var data = await HttpUtils.httpGetJson(uri);
      city = new City.fromJson(data);
    } catch (e) {
      print('getCityById error: $e');
    }
    return city;
  }

  static searchPlace(int cityId, String query) async {
    List<Place> places = [];
    try {
      var uri = Uri
          .parse('$_host/v1/pois?type=search&city_id=$cityId&keyword=$query');
      var data = await HttpUtils.httpGetJson(uri);
      if (data is List) {
        places = data.map((item) {
          return new Place.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('searchPlace error: $e');
    }
    return places;
  }

  static getPlace(String geohash) async {
    Place place;
    try {
      var uri = Uri.parse('$_host/v2/pois/$geohash');
      var data = await HttpUtils.httpGetJson(uri);
      place = new Place.fromJson(data);
    } catch (e) {
      print('getPlace error: $e');
    }
    return place;
  }

  static getFoodTypes(String geohash) async {
    List<FoodType> foodTypes = [];
    try {
      var uri =
          Uri.parse('$_host/v2/index_entry?geohash=$geohash&group_type=1&${Uri
          .encodeComponent('flags[]')}=F');
      var data = await HttpUtils.httpGetJson(uri);
      if (data is List) {
        foodTypes = data.map((item) {
          return new FoodType.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('getFoodTypes error: $e');
    }
    return foodTypes;
  }

  static getRestaurants(
    num latitude,
    num longitude,
    int offset, {
    String restaurantCategoryId = '',
    String restaurantCategoryIds = '',
    String orderBy = '',
    String deliveryMode = '',
    List<Support> supports = const [],
  }) async {
    List<Restaurant> restaurants = [];
    try {
      String url = '$_host/shopping/restaurants?latitude=$latitude&longitude=$longitude&offset=$offset&limit=20';
      url += '&${Uri.encodeComponent('extras[]')}=activities';
      url += '&keyword=';
      url += '&restaurant_category_id=$restaurantCategoryId';
      url += '&${Uri.encodeComponent('restaurant_category_ids[]')}=$restaurantCategoryIds';
      url += '&order_by=$orderBy';

      String supportStr = '';
      for (var support in supports) {
        supportStr += '&support_ids[]=${support.id}';
      }
      url += '&${Uri.encodeComponent('delivery_mode[]')}=${deliveryMode + supportStr}';
      var uri = Uri.parse(url);
      var data = await HttpUtils.httpGetJson(uri);
      if (data is List) {
        restaurants = data.map((item) {
          return new Restaurant.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print('getRestaurants error: $e');
    }
    return restaurants;
  }
}
