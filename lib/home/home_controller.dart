import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:rts_web/tracking/tracking_controller.dart';
import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';

import '../NFTs/NFTModel.dart';

class HomeController extends GetxController {
  TrackingController trackingController = Get.put(TrackingController());
  String _hoveringOver = '';
  bool introSectionVisible = false;
  bool whitepaperSectionVisible = false;
  bool marketplaceSectionVisible = false;
  bool isEldmenTileSelected = true;
  bool isGrollTileSelected = false;
  bool isKeldarinTileSelected = false;
  bool isKeenfolkTileSelected = false;
  bool isTravelerTileSelected = false;
  bool _isCookieBannerVisible = true;
  bool _isCookieBannerDestroyed = false;
  int _page = 0;

  get hoveringOver => _hoveringOver;
  get isCookieBannerVisible => _isCookieBannerVisible;
  get isCookieBannerDestroyed => _isCookieBannerDestroyed;
  get page => _page.toDouble();


  @override
  void onInit() {
    if (trackingController.isTrackingEnabled()) {
      hideCookiesBanner();
    }
    _hoveringOver = '';
    switchIntroSectionVisibility(true);
    super.onInit();
    executeAfterBuild();
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void selectNewTile(Race race) {
    isEldmenTileSelected = false;
    isGrollTileSelected = false;
    isKeldarinTileSelected = false;
    isKeenfolkTileSelected = false;
    isTravelerTileSelected = false;

    switch (race) {
      case Race.Eldmen:
        isEldmenTileSelected = true;
        break;
      case Race.Grolls:
        isGrollTileSelected = true;
        break;
      case Race.Keldarin:
        isKeldarinTileSelected = true;
        break;
      case Race.Keenfolk:
        isKeenfolkTileSelected = true;
        break;
      case Race.Travelers:
        isTravelerTileSelected = true;
        break;
      default:
        isEldmenTileSelected = true;
    }
    update();
  }

  void onEntering(String region) {
    _hoveringOver = region;
    update();
  }

  Future<void> executeAfterBuild() async {
    await Future.delayed(Duration.zero);
  }

  void acceptAllCookies() {
    trackingController.acceptAllCookies();
    hideCookiesBanner();
  }

  void hideCookiesBanner() {
    trackingController.hideCookiesBanner();
    _isCookieBannerVisible = false;
    update();
    destroyCookiesBanner();
  }

  void destroyCookiesBanner() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isCookieBannerDestroyed = true;
    update();
  }

  void setHomePage(int page) {
    _page = page;
    switchIntroSectionVisibility(false);
    switchWhitepaperSectionVisibility(false);
    switchMarketplaceSectionVisibility(false);
    switch(page) {
      case 0:
        switchIntroSectionVisibility(true);
        break;
      case 1:
        switchWhitepaperSectionVisibility(true);
        break;
      case 2:
        switchMarketplaceSectionVisibility(true);
        break;
      default:
        switchIntroSectionVisibility(true);
    }
    update();
  }

  void switchIntroSectionVisibility(bool value) {
    introSectionVisible = value;
    update();
  }

  void switchWhitepaperSectionVisibility(bool value) {
    whitepaperSectionVisible = value;
    update();
  }

  void switchMarketplaceSectionVisibility(bool value) {
    marketplaceSectionVisible = value;
    update();
  }
}