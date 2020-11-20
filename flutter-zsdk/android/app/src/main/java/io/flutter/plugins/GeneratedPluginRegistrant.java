package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import tr.gen.devinim.flutterzsdk.FlutterZsdkPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterZsdkPlugin.registerWith(registry.registrarFor("tr.gen.devinim.flutterzsdk.FlutterZsdkPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
