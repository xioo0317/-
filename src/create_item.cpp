#include "server/actions.hpp"

#include <iostream>

namespace app {

void handle_create_item(const std::string& body, httplib::Response& res) {
    std::cout << "[action] create_item" << std::endl;
    res.status = 201;
    res.set_content(R"({"created":true})", "application/json");
}

} // namespace app
