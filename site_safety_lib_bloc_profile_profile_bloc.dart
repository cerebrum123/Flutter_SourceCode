import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:site_safety/api/bloc_provider.dart';
import 'package:site_safety/api/web_service_client.dart';
import 'package:site_safety/data/profile_detail_res.dart';
import 'package:site_safety/util/utils.dart';



class ProfileBloc implements BlocBase{
  final _profileDetailsRes = StreamController<ProfileDetailRes>.broadcast();

  //Add data to streams
  StreamSink<ProfileDetailRes> get _profileDetailsResSink => _profileDetailsRes.sink;

  //Get data from streams using getters below
  Stream<ProfileDetailRes> get profileDetailsRes => _profileDetailsRes.stream;

  //Return profile data response or web errors
  Future profileDetails(Map<String, dynamic> parameters) async {
    return WebServiceClient.hitDetailProfile(parameters).then((response) async {
      if (response is WebError) {
        switch (response) {
          case WebError.INTERNAL_SERVER_ERROR:
            {
              Utils.showErrorMessage(
                  "Unable to reach server. Please check connection.");
              break;
            }
          case WebError.ALREADY_EXIST:
            {
              Utils.showErrorMessage(
                  "This email or phone number is already registered.");
              break;
            }
          case WebError.NOT_FOUND:
            {
              Utils.showErrorMessage(
                  "This email or phone number is already registered.");
              break;
            }
          default:
            Utils.showErrorMessage(
                "Something went unexpectedly wrong. Please try again later");
            break;
        }
        return false;
      } else {
        ProfileDetailRes profileDetailRes = ProfileDetailRes.fromJson(json.decode(response));
        _profileDetailsResSink.add(profileDetailRes);
        //_profileDetailsRes.add(profileDetailRes);
        return profileDetailRes;
      }
    }).catchError((e) {
      Utils.showErrorMessage("Something is broken \n $e");
    });
  }

  //profile image result or errors
  Future profileImage(Map<String, dynamic> parameters,Map<String, File> file) async {
    return WebServiceClient.hitImageProfile(parameters,file).then((response) async {
      if (response is WebError) {
        switch (response) {
          case WebError.INTERNAL_SERVER_ERROR:
            {
              Utils.showErrorMessage(
                  "Unable to reach server. Please check connection.");
              break;
            }
          case WebError.ALREADY_EXIST:
            {
              Utils.showErrorMessage(
                  "This email or phone number is already registered.");
              break;
            }
          case WebError.NOT_FOUND:
            {
              Utils.showErrorMessage(
                  "This email or phone number is already registered.");
              break;
            }
          default:
            Utils.showErrorMessage(
                "Something went unexpectedly wrong. Please try again later");
            break;
        }
        return false;
      } else {

        return true;
      }
    }).catchError((e) {
      Utils.showErrorMessage("Something is broken \n $e");
    });
  }

  //For closing all streams
  @override
  void dispose() {
    _profileDetailsRes.close();
  }
}

//Bloc object
ProfileBloc profileBloc = new ProfileBloc();