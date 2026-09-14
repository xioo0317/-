#include "server/actions.hpp"

#include <iostream>

namespace app {

void handle_update_item(const std::string& body, httplib::Response& res) {
    std::cout << "[action] update_item" << std::endl;
    res.set_content(R"({"updated":true})", "application/json");
}

} // namespace app
