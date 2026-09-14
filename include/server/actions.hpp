#pragma once

#include <string>
#include <httplib.h>

namespace app {

// Action handler function type
using ActionHandler = std::function<void(const std::string& body, httplib::Response& res)>;

// Action handler functions (each in its own .cpp file)
void handle_list_items(const std::string& body, httplib::Response& res);
void handle_create_item(const std::string& body, httplib::Response& res);
void handle_update_item(const std::string& body, httplib::Response& res);
void handle_delete_item(const std::string& body, httplib::Response& res);

// Get action handler by name
ActionHandler get_action_handler(const std::string& action_name);

} // namespace app
