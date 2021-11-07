import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsLoadingStateNotifier extends StateNotifier<bool> {
  bool _isL = true;

  bool get isL => _isL;

  set isL(bool isL) {
    _isL = isL;
  }

  IsLoadingStateNotifier() : super(true);

  changeIsL({bool? v}) {
    isL = v ?? !isL;
    state = _isL;
  }
}

final IsLoadingStateNotifier isLoading = IsLoadingStateNotifier();

/// ! in the app.dart myProgressIndicatorForAll = MyProgressIndicator();
/// ! in the const.dart late MyProgressIndicator myProgressIndicatorForAll;
/// ! in the screen where you are gonna user it
/// return myProgressIndicatorForAll.getWidgetForProgressIndicator(
///   cardProgress: cardTitleLoading(context),
///   child: child or Padding(
///     padding: const EdgeInsets.symmetric(horizontal: 15),
///     child: child
///   ),
/// );
class MyProgressIndicator {
  final isLoadingProvider = StateNotifierProvider((_) => isLoading);

  // MyProgressIndicator() {
  //   isLoadingProvider =
  // }

  void changeLoading({bool? v}) {
    isLoading.changeIsL(v: v);
  }

  Widget getWidgetForProgressIndicator(
      {required cardProgress, required Widget child}) {
    return WidgetForProgressIndicator(
      cardProgress: this.cardProgress(cardTitle: cardProgress),
      isLoadingProvider: isLoadingProvider,
      child: child,
    );
  }

  Widget cardProgress({required Widget cardTitle}) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: CardProgress(
          cardTitle: cardTitle,
        ),
      ),
    );
  }
}

/// ! The Widget that manage all
class WidgetForProgressIndicator extends ConsumerWidget {
  const WidgetForProgressIndicator({
    Key? key,
    required this.cardProgress,
    required this.isLoadingProvider,
    required this.child,
  }) : super(key: key);
  final StateNotifierProvider isLoadingProvider;
  final Widget cardProgress;
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoad = ref.read(isLoadingProvider);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        child,
        Positioned(
          child: isLoad ? cardProgress : Offstage(),
        ),
      ],
    );
  }
}

/// ! The card for the progress indicator and the text loading
class CardProgress extends StatelessWidget {
  const CardProgress({Key? key, required this.cardTitle}) : super(key: key);
  final Widget cardTitle;

  @override
  Widget build(BuildContext context) {
    final Size sizeForAll = MediaQuery.of(context).size;
    return Container(
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: SizedBox(
            width: sizeForAll.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                cardTitle,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
