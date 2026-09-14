#include "server/actions.hpp"

#include <iostream>

namespace app {

void handle_list_items(const std::string& body, httplib::Response& res) {
    std::cout << "[action] list_items" << std::endl;
    res.set_content(R"({"items":[]})", "application/json");
}

} // namespace app
