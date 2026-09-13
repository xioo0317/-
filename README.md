# Local API

C++17 local HTTP API server built on [cpp-httplib](https://github.com/yhirose/cpp-httplib).

## Project Structure

```
.
├── CMakeLists.txt
├── include/
│   └── server/
│       ├── server.hpp    # Server wrapper class
│       └── router.hpp    # Route registration
├── src/
│   ├── main.cpp          # Entry point (minimal)
│   ├── server.cpp        # Server implementation
│   └── router.cpp        # Route handlers
└── third_party/
    ── httplib.h         # Header-only HTTP library
```

## Build

```bash
mkdir -p build && cd build
cmake ..
make -j$(nproc)
```

## Run

```bash
./local_api
```

Server starts on `http://localhost:8080`.

## API Endpoints

| Method | Path                  | Description        |
|--------|-----------------------|--------------------|
| GET    | /health               | Health check       |
| GET    | /api/v1/items         | List items         |
| POST   | /api/v1/items         | Create item        |
| PUT    | /api/v1/items/:id     | Update item        |
| DELETE | /api/v1/items/:id     | Delete item        |

## Adding New Routes

Edit `src/router.cpp` and add handlers:

```cpp
svr.Get("/api/v1/foo", [](const httplib::Request& req, httplib::Response& res) {
    res.set_content(R"({"message":"hello"})", "application/json");
});
```
