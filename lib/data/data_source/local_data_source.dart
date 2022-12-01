// ignore_for_file: constant_identifier_names, prefer_collection_literals

import 'package:clean_achitecture/data/network/error_handler.dart';
import 'package:clean_achitecture/data/responses/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_DETAILS_KEY = "CACHE_DETAILS_KEY";
const CACHE_HOME_INTERVAL = 120 * 1000; //1 MINUTE IN MILLISECONDS

//run time Caching
abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<DetailsResponse> getDetailsData();
  Future<void> saveHomeToCache(HomeResponse homeDataResponse);
  Future<void> saveDetailsToCache(DetailsResponse detailsDataResponse);

  Future<void> clearCache();
  Future<void> removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  Map<String, CachedItem> cacheMap = Map();
  Map<String, CachedItem> cacheMapToDetails = Map();
  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];

    if (cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)) {
      //return response from cache
      return cachedItem.data; //Home Response
    } else {
      //throw error that cache is not valid or not there chching!
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeDataResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeDataResponse);
  }

  @override
  Future<void> clearCache() async {
    cacheMap.clear();
    cacheMapToDetails.clear();
  }

  @override
  Future<void> removeFromCache(String key) async {
    cacheMap.remove(key);
  }

  @override
  Future<DetailsResponse> getDetailsData() async {
    CachedItem? cachedItem = cacheMapToDetails[CACHE_DETAILS_KEY];
    if (cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)) {
      //return response from cache
      return cachedItem.data; //Home Response
    } else {
      //throw error that cache is not valid or not there chching!
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveDetailsToCache(DetailsResponse detailsDataResponse) async {
    cacheMapToDetails[CACHE_DETAILS_KEY] = CachedItem(detailsDataResponse);
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItEmextension on CachedItem {
  bool isValid(int expirationTimeInMillis) {
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    bool isValid = currentTimeInMillis - cacheTime <= expirationTimeInMillis;
    return isValid;
  }
}
