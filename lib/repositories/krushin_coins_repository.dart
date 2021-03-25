
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/utils/T.dart';

class KrushinCoinsRepository {
  KrushinCoinsRepository();

  Future<int> getCoins() {
    return UserSettingsManager.getuserCoins();
  }

  addCoins( int coins) async {
    int updatedCoinsCount;

    await ApiClient.apiClient.addCoinsAPI( coins).then((value) {
      if (value.status) {
        // UserSettingsManager.setuserCoins(value.data.user.coins);
        // T.message("Coins added Successfully");
        // getCoins();
        // getTransactions();
        // if (widget.prevPage == "AddKrush" ||
        //     widget.prevPage == "RequestsReceived" || widget.prevPage == "HomePage") {
        //   Navigator.pop(context);
        // }

        updatedCoinsCount = value.data.user.coins;
      } else {
        T.message("Coins adding failed");
      }
    });

    return updatedCoinsCount;
  }


}
