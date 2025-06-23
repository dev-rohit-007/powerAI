# PowerAI - iOS Project with CMake

This project demonstrates how to set up an iOS application using CMake and Swift in Zed IDE. It provides a basic foundation for iOS development with a modern build system setup.

## Project Structure

```
powerAI/
├── ios/
│   ├── CMakeLists.txt
│   ├── Info.plist
│   ├── Sources/
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   └── ViewController.swift
│   └── Resources/
│       ├── Assets.xcassets/
│       ├── LaunchScreen.storyboard
│       └── Main.storyboard
└── .gitignore
```

## Prerequisites

- macOS with Xcode 16 or later
- CMake 3.26 or later
- Zed IDE
- Git

## Project Creation Steps

### 1. Initial Setup

```bash
# Create project directory
mkdir -p powerAI/ios
cd powerAI
```

### 2. Creating Project Files

1. **CMake Configuration**
   - Created `ios/CMakeLists.txt` with:
     - iOS platform settings
     - Swift language configuration
     - Bundle identifier and version
     - Target properties and build settings

2. **Source Files**
   - Created basic Swift files in `ios/Sources/`:
     ```swift
     // AppDelegate.swift - Application entry point
     // SceneDelegate.swift - Scene lifecycle management
     // ViewController.swift - Main view controller
     ```

3. **Resource Files**
   - Set up `ios/Resources/` directory with:
     - Assets catalog
     - Storyboard files

4. **Configuration Files**
   - Created `Info.plist` with required iOS app settings
   - Added `.gitignore` for iOS/Xcode/CMake specific files

### 3. Building the Project

```bash
# Generate Xcode project
mkdir -p ios/build
cd ios/build
cmake -G Xcode ..

# Open in Xcode
open PowerAI_iOS.xcodeproj
```

### 4. GitHub Repository Setup

1. **Repository Creation**
```bash
# Initialize git repository
git init

# Add all files
git add .

# Initial commit
git commit -m "Initial commit: Basic iOS project with CMake setup"

# Add remote repository
git remote add origin https://github.com/dev-rohit-007/powerAI.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Build and Run

1. Open the generated Xcode project
2. Select your development team in project settings
3. Choose a simulator or device
4. Build and run (⌘R)

## Project Features

- Modern iOS app structure
- CMake-based build system
- Programmatic UI with Auto Layout
- Scene-based app lifecycle
- Universal app support (iPhone & iPad)
- iOS 16.0+ deployment target

## Development Tools Used

- **Zed IDE**: Primary development environment
- **CMake**: Build system generation
- **Xcode**: iOS SDK and toolchain
- **Git**: Version control
- **GitHub**: Repository hosting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the MIT License.

## Contact

Rohit Mishra - [GitHub Profile](https://github.com/dev-rohit-007)

Project Link: [https://github.com/dev-rohit-007/powerAI](https://github.com/dev-rohit-007/powerAI)