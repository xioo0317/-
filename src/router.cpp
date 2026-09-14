#include "server/router.hpp"

#include <httplib.h>
#include <iostream>
#include <string>

namespace app {

void register_routes(httplib::Server& svr) {

    // ── Health ────────────────────────────────────────────────
    svr.Get("/health", [](const httplib::Request&, httplib::Response& res) {
        res.set_content(R"({"status":"ok"})", "application/json");
    });

    // ── Items (scaffold) ──────────────────────────────────────
    svr.Get("/api/v1/items", [](const httplib::Request&, httplib::Response& res) {
        res.set_content(R"({"items":[]})", "application/json");
    });

    svr.Post("/api/v1/items", [](const httplib::Request& req, httplib::Response& res) {
        std::cout << "[POST /api/v1/items] " << req.body << std::endl;
        res.status = 201;
        res.set_content(R"({"created":true})", "application/json");
    });

    svr.Put(R"(/api/v1/items/(\d+))", [](const httplib::Request& req, httplib::Response& res) {
        std::cout << "[PUT /api/v1/items/" << req.matches[1] << "] " << req.body << std::endl;
        res.set_content(R"({"updated":true})", "application/json");
    });

    svr.Delete(R"(/api/v1/items/(\d+))", [](const httplib::Request& req, httplib::Response& res) {
        std::cout << "[DELETE /api/v1/items/" << req.matches[1] << "]" << std::endl;
        res.set_content(R"({"deleted":true})", "application/json");
    });

    // ── 404 ───────────────────────────────────────────────────
    svr.set_error_handler([](const httplib::Request&, httplib::Response& res) {
        res.status = 404;
        res.set_content(R"({"error":"not found"})", "application/json");
    });
}

} // namespace app
