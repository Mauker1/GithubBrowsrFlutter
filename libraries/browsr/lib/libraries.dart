import 'dart:async';

import 'package:flutter/services.dart';

class Libraries {
  static const MethodChannel _channel = const MethodChannel('libraries');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<List<dynamic>> getOrgs() async {
    return await _channel.invokeMethod("getOrganizations");
  }

  Future<void> setFavoriteOrg(int orgId) async {
    return await _channel.invokeMethod("setFavoriteOrg", {'org_id': orgId});
  }

  Future<void> removeFavoriteOrg(int orgId) async {
    return await _channel.invokeMethod("removeFavoriteOrg", {'org_id': orgId});
  }

  Future<void> removeAllFavoriteOrgs() async {
    return await _channel.invokeMethod("removeAllFavorites");
  }
}
