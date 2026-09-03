# Application.mk pour configurer le NDK

# Architecture cible
APP_ABI := arm64-v8a armeabi-v7a x86_64

# Niveau d'API minimum
APP_PLATFORM := android-21

# Utiliser le STL LLVM (recommandé pour Android)
APP_STL := c++_shared

# Optimisations
APP_OPTIM := release

# Gestion des exceptions
APP_CPPFLAGS := -fexceptions -frtti
