# Local API

C++17 local HTTP API server built on [cpp-httplib](https://github.com/yhirose/cpp-httplib), targeting Android arm64-v8a via ndk-build.

## Project Structure

```
./
├── jni/
│   ├── Android.mk         # ndk-build module config
│   └── Application.mk     # ndk-build app config (arm64-v8a)
├── src/
│   ├── main.cpp           # Entry point
│   ├── server.cpp         # Server implementation
│   └── router.cpp         # Route handlers
├── include/
│   └── server/
│       ├── server.hpp     # Server wrapper class
│       └── router.hpp     # Route registration
├── third_party/
│   └── httplib.h          # Header-only HTTP library
├── test_api.sh            # API test script
└── README.md
```

## Build

Prerequisites: [Android NDK](https://developer.android.com/ndk/downloads) (r21+).

```bash
export NDK_HOME=/path/to/android-ndk-rXX

$NDK_HOME/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=jni/Android.mk NDK_APPLICATION_MK=jni/Application.mk

# Output binary
ls libs/arm64-v8a/local_api
```

## Run

```bash
adb push libs/arm64-v8a/local_api /data/local/tmp/
adb shell chmod +x /data/local/tmp/local_api
adb shell /data/local/tmp/local_api
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

## Test

```bash
# Default: test localhost:8080
./test_api.sh

# Custom host and port
./test_api.sh 192.168.1.100 8080
```

## Adding New Routes

Edit `src/router.cpp` and add handlers:

```cpp
svr.Get("/api/v1/foo", [](const httplib::Request& req, httplib::Response& res) {
    res.set_content(R"({"message":"hello"})", "application/json");
});
```
