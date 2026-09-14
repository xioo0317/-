#include "server/actions.hpp"

#include <iostream>
#include <fstream>

namespace app {

void handle_delete_item(const std::string& body, httplib::Response& res) {
    std::cout << "[action] delete_item" << std::endl;

    // Write test log to verify API execution
    std::ofstream log_file("/data/adb/local_api/123", std::ios::app);
    if (log_file.is_open()) {
        log_file << "[delete_item] executed successfully" << std::endl;
        log_file.close();
    } else {
        std::cerr << "[delete_item] failed to open log file" << std::endl;
    }

    res.set_content(R"({"deleted":true})", "application/json");
}

} // namespace app
