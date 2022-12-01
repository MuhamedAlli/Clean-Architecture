class SliderObject {
  String title;
  String subTitle;
  String image;
  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}

///Login Models

class Customer {
  String id;
  String name;
  int numOfNotifications;
  Customer(this.id, this.name, this.numOfNotifications);
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer, this.contacts);
}
//Main View Models

class Serives {
  int id;
  String title;
  String image;
  Serives(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String link;
  String title;
  String image;
  BannerAd(this.id, this.link, this.title, this.image);
}

class Store {
  int id;
  String title;
  String image;
  Store(this.id, this.title, this.image);
}

class HomeData {
  List<Serives> services;
  List<BannerAd> banners;
  List<Store> stores;
  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData? data;
  HomeObject(this.data);
}

class DetailsData {
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;

  DetailsData(
      this.image, this.id, this.title, this.details, this.services, this.about);
}
