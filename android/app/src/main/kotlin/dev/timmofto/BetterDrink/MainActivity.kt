package dev.timmofto.BetterDrink

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity instead of FlutterActivity -- required by the
// health plugin's ActivityResultContract-based Health Connect permission
// request flow.
class MainActivity : FlutterFragmentActivity()
