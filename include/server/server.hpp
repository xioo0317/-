#pragma once

#include <httplib.h>
#include <memory>
#include <string>

namespace app {

class ApiServer {
public:
    explicit ApiServer(const std::string& host = "0.0.0.0", int port = 8080);
    ~ApiServer();

    // Non-copyable, movable
    ApiServer(const ApiServer&) = delete;
    ApiServer& operator=(const ApiServer&) = delete;
    ApiServer(ApiServer&&) noexcept;
    ApiServer& operator=(ApiServer&&) noexcept;

    void register_routes();
    void start();   // blocking
    void stop();

private:
    std::unique_ptr<httplib::Server> server_;
    std::string host_;
    int port_;
};

} // namespace app
