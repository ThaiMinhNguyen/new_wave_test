import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();
  //google map api docs https://developers.google.com/maps/documentation/urls/get-started#forming-the-directions-url
  static Future<void> openMap(String des, String des_id, double latitude, double longitude) async {
    // String googleUrl = 'https://www.google.com/maps/dir/?api=1&query=$latitude,$longitude';
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&destination=$des&destination_place_id=$des_id';
    print(Uri.parse(googleUrl));
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}