import 'package:aspects/src/aspects/after_aspect.aspect.dart';
import 'package:aspects/src/aspects/around_aspect.aspect.dart';
import 'package:aspects/src/aspects/before_aspect.aspect.dart';
import 'package:aspects/src/models/hooked.model.dart';
import 'package:mustang_core/mustang_core.dart';

import 'hooked_service.service.dart';

@screenService
abstract class $HookedService {
  Future<void> memoizedGetData() {
    Hooked hooked = MustangStore.get<Hooked>() ?? Hooked();
    if (hooked.clearScreenCache) {
      clearMemoizedScreen(reload: false);
      hooked = hooked.rebuild(
        (b) => b..clearScreenCache = false,
      );
      updateState1(hooked, reload: false);
    }
    return memoizeScreen(getData);
  }

  @Before([beforeAspect], args: {'one': 1, 'two': 2.2})
  @After([afterAspect], args: {})
  @Around(aroundAspect, args: {'three': null})
  Future<void> getData({
    bool showBusy = true,
  }) async {
    print('source method - start');
    Hooked hooked = MustangStore.get<Hooked>() ?? Hooked();
    if (showBusy) {
      hooked = hooked.rebuild(
        (b) => b
          ..busy = true
          ..errorMsg = '',
      );
      updateState1(hooked);
    }
    await Future.delayed(const Duration(seconds: 5));

    // Add API calls here, if any
    hooked = hooked.rebuild((b) => b..busy = false);
    updateState1(hooked);

    print('source method - end');
  }

  void sampleMethod() {
    print('normal method');
  }

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }
}
