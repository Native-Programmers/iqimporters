import 'package:qbazar/config/route.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    print("queryParameters ${uriData.queryParameters} path ${uriData.path}");
    return RoutingData(
        route: uriData.path, queryParameters: uriData.queryParameters);
  }
}
