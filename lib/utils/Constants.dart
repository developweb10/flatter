import 'package:http/http.dart' as http;

class Constants{

  Constants._();

  static final bool production = true;

  static final http.Client httpClient = http.Client();

  static final String stripePublishableKey_test = "pk_test_rKarLZNQ7vgrqbQZuZ4rujXp";
  static final String stripePublishableKey_live = 'pk_live_GmdHUp56Qan9JnIejJnhZUxw';

  static final String revenuecatAppId = "WwLbLBMDXoPiqqniKInjOWdGJxNISNAO";

  static final String defaultProfileImage = 'https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg';
}