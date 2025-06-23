cmake_minimum_required(VERSION 3.26)
project(PowerAI_iOS LANGUAGES Swift)

# Set iOS platform and deployment target
set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_DEPLOYMENT_TARGET 16.0)
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET 16.0)
set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2") # Universal (iPhone & iPad)

# Enable Swift support
enable_language(Swift)
set(CMAKE_Swift_LANGUAGE_VERSION 5.0)

# Set bundle identifier and version
set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.powerai.app")
set(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")

# Create the main app target
add_executable(PowerAI_iOS MACOSX_BUNDLE
    Sources/AppDelegate.swift
    Sources/SceneDelegate.swift
    Sources/ViewController.swift
)

# Set target properties
set_target_properties(PowerAI_iOS PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER ${MACOSX_BUNDLE_GUI_IDENTIFIER}
    XCODE_ATTRIBUTE_SWIFT_VERSION 5.0
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ""  # Set your team ID here
)

# Set iOS specific build settings
set_target_properties(PowerAI_iOS PROPERTIES
    XCODE_ATTRIBUTE_SDKROOT iphoneos
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
    XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
    XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)"
    XCODE_ATTRIBUTE_SKIP_INSTALL NO
    XCODE_ATTRIBUTE_ENABLE_BITCODE NO
)

# Add resource files
set(RESOURCES
    Resources/Assets.xcassets
    Resources/LaunchScreen.storyboard
    Resources/Main.storyboard
)

target_sources(PowerAI_iOS PRIVATE ${RESOURCES})
set_source_files_properties(${RESOURCES} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
