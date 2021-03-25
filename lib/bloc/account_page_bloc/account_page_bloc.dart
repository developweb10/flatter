import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../model/get_user_response.dart';
import '../../app/shared_prefrence.dart';
import '../../repositories/account_repository.dart';
import 'package:meta/meta.dart';
import 'dart:io' as file;

part 'account_page_event.dart';
part 'account_page_state.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountPageState> {
  AccountPageBloc() : super(AllInfoLoading());
  final AccountRepository accountRepository = AccountRepository();

  @override
  Stream<AccountPageState> mapEventToState(AccountPageEvent event) async* {
    if (event is UpdateProfileImage) {
      yield ProfileImageLoading();
      try {
        String imageUrl = await accountRepository.updateProfileImage(
            event.imageFile, await UserSettingsManager.getUserToken());
  
        if (imageUrl != null) {
          yield ProfileImageUpdated(imageUrl);
        } else {
          yield ProfileImageError("Unable to update image");
        }
      } catch (error) {
        yield ProfileImageError("Unable to update image");
      }
    } else if (event is UpdateInfo) {
      yield ProfileInfoLoading();

      try {
        UserResponse result = await accountRepository.updateInfo(
            event.displayName,
            event.email,
            event.dateTime,
            event.selectedCountryName,
            event.state,
            event.city,
            event.zipcodeControl);
        if (result != null) {
          await UserSettingsManager.setUserName(result.data.profile.displayName);
          yield ProfileInfoUpdated(result);
        } else {
          yield ProfileInfoError("Unable to update info");
        }
      } catch (error) {
        yield ProfileInfoError("Unable to update info");
      }
    } else if (event is GetAllInfo) {
      yield AllInfoLoading();

      try {
        UserResponse userResponse = await accountRepository.getAllInfo();
        if (userResponse != null) {
          yield AllInfoLoaded(userResponse);
        } else {
          yield ProfileInfoError("Unable to update info");
        }
      } catch (error) {
        yield ProfileInfoError("Unable to update info");
      }
    }
  }
}
