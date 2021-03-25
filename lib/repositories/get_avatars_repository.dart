

import '../app/api.dart';

class GetAvatarRepository {

static List<String> avatarURLs;

  getAvatars() async {

    // avatarURLs = await ApiClient.apiClient.getAvatars();
    avatarURLs = ['https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg'];
}
}