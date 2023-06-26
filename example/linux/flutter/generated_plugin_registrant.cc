//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <response_wrapper/response_wrapper_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) response_wrapper_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ResponseWrapperPlugin");
  response_wrapper_plugin_register_with_registrar(response_wrapper_registrar);
}
