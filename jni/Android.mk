# Android.mk - ndk-build configuration for local_api
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := local_api

# Source files
LOCAL_SRC_FILES := \
    ../src/main.cpp \
    ../src/server.cpp \
    ../src/router.cpp

# Include directories
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../include \
    $(LOCAL_PATH)/../third_party

# C++17 standard
LOCAL_CPPFLAGS := -std=c++17 -frtti -fexceptions

# Link libraries
LOCAL_LDLIBS := -llog -pthread

include $(BUILD_EXECUTABLE)
