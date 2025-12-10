import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Use a test Ad Unit ID for development
  final String adUnitId = 'ca-app-pub-3940256099942544/9214589741';

  @override
  void initState() {
    super.initState();
    // Load the ad immediately
    _loadAd();
  }

  // ⭐ MODIFIED: Reverted to a synchronous load using AdSize.banner
  // to ensure reliable loading without context-dependent async size calculation.
  void _loadAd() {
    // Using the standard, reliable AdSize.banner
    const AdSize adSize = AdSize.banner;

    _bannerAd = BannerAd(
      // Use the standard size
      size: adSize,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
          print("Banner ad loaded successfully using AdSize.banner.");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Banner ad failed to load: $error");
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If ad is loaded, return the SizedBox with the correct dimensions
    if (_bannerAd != null && _isLoaded) {
      // Ensure height is set to the ad's calculated height
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Return an empty widget if the ad is not loaded
    return const SizedBox.shrink();
  }
}
