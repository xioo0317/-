#include "server/server.hpp"
#include "server/router.hpp"

#include <iostream>

namespace app {

ApiServer::ApiServer(const std::string& host, int port)
    : server_(std::make_unique<httplib::Server>())
    , host_(host)
    , port_(port) {}

ApiServer::~ApiServer() = default;

ApiServer::ApiServer(ApiServer&&) noexcept = default;
ApiServer& ApiServer::operator=(ApiServer&&) noexcept = default;

void ApiServer::register_routes() {
    app::register_routes(*server_);
}

void ApiServer::start() {
    register_routes();
    std::cout << "Listening on http://" << host_ << ":" << port_ << std::endl;
    server_->listen(host_.c_str(), port_);
}

void ApiServer::stop() {
    if (server_) server_->stop();
}

} // namespace app
