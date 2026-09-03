# Android.mk pour compiler les bindings natifs

LOCAL_PATH := $(call my-dir)

# Inclure les sources
include $(CLEAR_VARS)

# Nom du module
LOCAL_MODULE := owildzimut_native

# Sources C++
LOCAL_SRC_FILES := \
    geopdf_bindings.cpp \
    poppler_wrapper.cpp \
    gdal_wrapper.cpp

# Inclure les headers
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH) \
    $(LOCAL_PATH)/../../../../native/poppler_gdal/src

# Configuration pour C++
LOCAL_CPPFLAGS := -std=c++17 -frtti -fexceptions

# Librairies à lier
# Note: Les librairies Poppler et GDAL doivent être pré-compilées
LOCAL_LDLIBS := -llog -lz

# Si Poppler et GDAL sont disponibles comme librairies partagées
ifdef POPPLER_LIB_PATH
LOCAL_SHARED_LIBRARIES := $(POPPLER_LIB_PATH)/libpoppler $(GDAL_LIB_PATH)/libgdal
endif

# Compiler comme librairie partagée
include $(BUILD_SHARED_LIBRARY)
