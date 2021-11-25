class SearchProducts {
   bool? status;
   String? message;
   Data? data;

  SearchProducts({required this.status, required this.message, required this.data});

  SearchProducts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

}

class Data {
  int? currentPage;
  List<Model>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;


  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    data = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data?.add(new Model.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

}

class Model {
 late int id;
 late dynamic price;
 late String image;
 late String name;
 late String description;
 late List<String> images;
 late bool inFavorites;
 late bool inCart;

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

}

