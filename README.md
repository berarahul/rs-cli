````markdown
# 🔧 RS (Rahul Structure) - Flutter CLI Project Scaffolding Tool

**RS (Rahul Structure)** is a simple yet powerful Dart-based command-line tool that helps you scaffold a Flutter project architecture instantly. Whether you prefer Clean Architecture, MVVM, or a custom folder structure, `rs` will set up everything for you in seconds!

---

## 📌 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture Options](#architecture-options)
- [Example Project Structure](#example-project-structure)
- [Project Directory Explained](#project-directory-explained)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## ✨ Features

- 📁 Instantly generate project structure in Flutter projects
- 🏗 Supports multiple architecture patterns:
  - Clean Architecture
  - MVVM
  - Rahul's Custom Architecture
- 🧠 Beginner-friendly CLI interface
- 🧰 Written in Dart using the `args` package
- ⚡ Super fast and easily extendable

---

## 📦 Installation

### 1️⃣ Clone the Repo

```bash
git clone https://github.com/your-username/rs.git
cd rs
````

### 2️⃣ Activate the Tool Globally

```bash
dart pub global activate --source path .
```

> ℹ️ Make sure `$HOME/.pub-cache/bin` is in your PATH.

---

## 🚀 Usage

Create a Flutter project first:

```bash
flutter create my_app
cd my_app
rs
```

You'll see a prompt:

```bash
Are you creating your project structure?

1. Clean Architecture
2. MVVM Architecture
3. Rahul Architecture

Enter your choice (1/2/3):
```

After you choose, it will auto-generate the structure and print:

```
✅ Successfully generated Clean Architecture project structure.
```

---

## 🏗 Architecture Options

You can scaffold the following:

### 1. Clean Architecture

* Organizes code in layers: `data`, `domain`, `presentation`
* Suitable for enterprise-level apps

### 2. MVVM

* Separates `Model`, `View`, `ViewModel`
* Great for small to medium apps with UI logic

### 3. Rahul Architecture

* Comming soon
* Comming soon

---

## 📂 Example Project Structure

Here’s a generated folder layout for Clean Architecture:

```
lib/
├── core/
│   └── utils/
├── features/
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── main.dart
```

---

## 📁 Project Directory Explained

* `core/`: App-wide utilities, constants, error handling
* `features/`: Divides your app by features/modules
* `data/`: Handles API, local DB, and data sources
* `domain/`: Business logic, use cases, entities
* `presentation/`: UI screens, widgets, controllers

---

## 🤝 Contributing

Want to contribute? Follow these steps:

```bash
git clone https://github.com/berarahul/rs-cli.git
cd rs
dart run bin/rs.dart
```

Open an issue or submit a pull request — all contributions are welcome!

---

## 📜 License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2025 Rahul

Permission is hereby granted, free of charge, to any person obtaining a copy
...
```

---

## 👨‍💻 Author

Made with ❤️ by [**Rahul Bera**](https://github.com/your-username)

* 📧 Email: [rb6764385@gmail.com](mailto:rb6764385@gmail.com)
* 🧰 GitHub: [berarahul](https://github.com/berarahul)
---

## 🔮 Coming Soon

* ☁️ Cloud templates
* 📦 Flutter package integrations
* 🧪 Unit test starter
