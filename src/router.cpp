#include "server/router.hpp"

#include <httplib.h>
#include <iostream>
#include <string>

namespace app {

// Simple JSON string field extractor (no external JSON library needed)
static std::string extract_json_string(const std::string& json, const std::string& key) {
    std::string search = "\"" + key + "\"";
    auto pos = json.find(search);
    if (pos == std::string::npos) return "";
    pos = json.find(":", pos);
    if (pos == std::string::npos) return "";
    pos = json.find("\"", pos);
    if (pos == std::string::npos) return "";
    auto end = json.find("\"", pos + 1);
    if (end == std::string::npos) return "";
    return json.substr(pos + 1, end - pos - 1);
}

void register_routes(httplib::Server& svr) {

    // ── Health ────────────────────────────────────────────────
    svr.Get("/health", [](const httplib::Request&, httplib::Response& res) {
        res.set_content(R"({"status":"ok"})", "application/json");
    });

    // ── Unified POST endpoint ─────────────────────────────────
    // Request:  POST /api/v1/execute
    // Body:     {"action": "<action_name>"}
    //
    // Supported actions:
    //   list_items   -> returns item list
    //   create_item  -> creates a new item
    //   update_item  -> updates an existing item
    //   delete_item  -> deletes an item
    // ─────────────────────────────────────────────────────────
    svr.Post("/api/v1/execute", [](const httplib::Request& req, httplib::Response& res) {
        std::string action = extract_json_string(req.body, "action");

        if (action.empty()) {
            res.status = 400;
            res.set_content(R"({"error":"missing or invalid 'action' field"})", "application/json");
            return;
        }

        std::cout << "[POST /api/v1/execute] action=" << action
                  << " body=" << req.body << std::endl;

        if (action == "list_items") {
            res.set_content(R"({"items":[]})", "application/json");

        } else if (action == "create_item") {
            res.status = 201;
            res.set_content(R"({"created":true})", "application/json");

        } else if (action == "update_item") {
            res.set_content(R"({"updated":true})", "application/json");

        } else if (action == "delete_item") {
            res.set_content(R"({"deleted":true})", "application/json");

        } else {
            res.status = 400;
            res.set_content(R"({"error":"unknown action","action":")" + action + "\"}", "application/json");
        }
    });

    // ── 404 ───────────────────────────────────────────────────
    svr.set_error_handler([](const httplib::Request&, httplib::Response& res) {
        res.status = 404;
        res.set_content(R"({"error":"not found"})", "application/json");
    });
}

} // namespace app
