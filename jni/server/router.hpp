#pragma once

#include <httplib.h>

namespace app {

// Register all API routes on the given server instance.
void register_routes(httplib::Server& svr);

} // namespace app
