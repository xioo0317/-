#include "server/actions.hpp"

#include <iostream>

namespace app {

void handle_delete_item(const std::string& body, httplib::Response& res) {
    std::cout << "[action] delete_item" << std::endl;
    res.set_content(R"({"deleted":true})", "application/json");
}

} // namespace app
