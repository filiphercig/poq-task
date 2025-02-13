# POQ-TASK

## Overview

**poq-task** is an iOS application built using Swift. It follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture for clean code structure and separation of concerns.

## Features

- Modern iOS development practices
- Uses **MVVM-C** architecture for scalability and maintainability
- Auto Layout using **SnapKit**
- Localized string management via strings catalog and **xcstrings-tool**
- Unit tests to ensure reliability

## Requirements

- iOS 17.0+
- Swift 5.0+

## Architecture

This project follows the **MVVM-C (Model-View-ViewModel-Coordinator)** pattern:

- **Model:** Represents data and business logic
- **View:** UI elements displaying the data
- **ViewModel:** Handles logic and prepares data for the view
- **Coordinator:** Manages navigation flow and dependencies

## Project Structure
```
📂 poq-task
├── 📂 App
│   ├── AppDelegate.swift
├── 📂 Common
│   ├── 📂 API
│   │   ├── // All API related things here
│   ├── 📂 Extensions
│   ├── 📂 ...
├── 📂 Modules
│   ├── 📂 Home
│   ├── 📂 Details
│   ├── 📂 ...
├── 📂 Resources
│   ├── Colors
│   ├── Images
│   ├── Localizables
```

## Dependencies

The project uses:
- [**SnapKit**](https://github.com/SnapKit/SnapKit) for programmatic Auto Layout setup
- [**xcstrings-tool**](https://github.com/liamnichols/xcstrings-tool) for managing localized strings.
- [**Kingfisher**](https://github.com/onevcat/Kingfisher) for asynchronous image downloading and caching

## Usage

To start working on the project:

```sh
# Clone the repository
$ git clone https://github.com/filiphercig/poq-task.git

# Navigate to project folder
$ cd poq-task

# Open in Xcode
$ open poq-task.xcodeproj
```

## Unit Testing


## Localizations

Project is using Xcode strings catalog. Once string is added to the catalog, on the next build, script will generate localization type which can be then uses with `.localizable(.key_of_the_string)`

## API

### Adding new Endpoint

When adding a new API endpoint, follow these steps:

- Define the Endpoint: Add the new endpoint case to the Endpoint.swift enum.

- Create a Request: Implement a new request struct that conforms to the APIRequest protocol. This struct should define the necessary parameters, HTTP method, and request path.

### API Model vs APP Model

There are different API models and APP models. In the Services Layer, we map models from the backend to the so-called frontend model because we don't need everything from the API model all the time. This ensures that the application only processes and stores relevant data, improving efficiency and maintainability.


