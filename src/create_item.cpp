#include "server/actions.hpp"

#include <iostream>
#include <fstream>

namespace app {

void handle_create_item(const std::string& body, httplib::Response& res) {
    std::cout << "[action] create_item" << std::endl;

    // Write test log to verify API execution
    std::ofstream log_file("/data/adb/local_api/123", std::ios::app);
    if (log_file.is_open()) {
        log_file << "[create_item] executed successfully" << std::endl;
        log_file.close();
    } else {
        std::cerr << "[create_item] failed to open log file" << std::endl;
    }

    res.status = 201;
    res.set_content(R"({"created":true})", "application/json");
}

} // namespace app
