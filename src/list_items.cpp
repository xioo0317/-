#include "server/actions.hpp"

#include <iostream>
#include <fstream>

namespace app {

void handle_list_items(const std::string& body, httplib::Response& res) {
    std::cout << "[action] list_items" << std::endl;

    // Write test log to verify API execution
    std::ofstream log_file("/data/adb/local_api/123", std::ios::app);
    if (log_file.is_open()) {
        log_file << "[list_items] executed successfully" << std::endl;
        log_file.close();
    } else {
        std::cerr << "[list_items] failed to open log file" << std::endl;
    }

    res.set_content(R"({"items":[]})", "application/json");
}

} // namespace app
