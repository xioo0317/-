#include "server/server.hpp"

int main() {
    app::ApiServer server("0.0.0.0", 8080);
    server.start();
    return 0;
}
