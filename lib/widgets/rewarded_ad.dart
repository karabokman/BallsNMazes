import 'package:balls_n_mazes/models/player_data.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:balls_n_mazes/services/admob_service.dart';
import 'package:provider/provider.dart';

class RewardedAdButton extends StatefulWidget {
  const RewardedAdButton({super.key});

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  RewardedAd? _rewardedAd;
  bool _isLoading = true;

  @override
  void initState() {
    _createRewardedAd();
    super.initState();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdmobService.rewardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => setState(() {
            _rewardedAd = ad;
            _isLoading = false;
          }),
          onAdFailedToLoad: ((error) => setState(() {
                _rewardedAd = null;
                _isLoading = false;
              })),
        ));
  }

  void _showRewardedAd() {
    setState(() => _isLoading = true);

    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: ((ad, reward) {
        final playerdata = Provider.of<PlayerData>(context);
        playerdata.coins += 10;
        playerdata.save();
      }));
      _rewardedAd = null;
      _createRewardedAd();
    } else {
      _createRewardedAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _isLoading ? null : _showRewardedAd,
        child: _isLoading
            ? const Text('Please wait...')
            : const Text('Watch Ad +10'));
  }
}
