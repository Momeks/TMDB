## 🎬 The Movie Database  
A Swift-based iOS app that allows users to browse, search, and explore movies from various categories including Popular and Top Rated. Users can view real-time movie data, search by title, and tap on a movie to see detailed information including synopsis, ratings, and release date.

![TMDB Screenshot](http://worldofdinosaurs.net/news/wp-content/uploads/2025/05/tmdb.png)

### 🧭 Features
*    Movie List: Browse movies from various categories such as Popular, Top Rated, and more.
*    Detail View: Tap on any movie to see detailed information including synopsis, ratings, and release date.
*    Search: Find movies quickly by searching for titles.

### 🧱 Architecture
This project follows the MVVM (Model-View-ViewModel) architecture, ensuring a clear separation of concerns between UI, business logic, and data handling. It is designed with modularity and maintainability in mind.

#### 🧩 Modular Design
The app is structured into distinct, reusable Swift modules:
*    MovieKit: Contains domain models and logic related to movie data.
*    NetworkKit: Responsible for all networking tasks, such as API requests and decoding, utilizing native Swift features.

This modular setup allows for better testability, separation of responsibilities, and potential reuse in other projects.

####  ⚙️ Swift Concurrency
The project makes extensive use of Swift Concurrency features, including:
*    async/await for asynchronous tasks like fetching data from APIs
*    Structured concurrency to manage task lifecycles in a safe and readable way

Using Swift Concurrency improves performance and readability while reducing the complexity of callback-based code.

#### 🧼 Clean Principles
*    Single Responsibility Principle: Each class, struct, and module serves a clear and distinct purpose.
*    Clear boundaries between presentation, business logic, and data layers
*    Dependency injection for flexibility and testability

This design keeps the codebase scalable, testable, and easy to extend.

#### 🧪 Testing
The app includes unit tests that cover all important code paths, focusing on:
* Use case logic
* View model behavior
* Network responses (with mock data)

Tests are written pragmatically to ensure correctness while keeping test maintenance minimal.

#### 🔐 Security
This project takes API key protection seriously by using Obfuscator to encode the API key, helping prevent static extraction from the app binary.

#### 🔌 Data Source
All movie data in this app is fetched in real-time from the [TMDB API](https://developer.themoviedb.org/), a free and community-driven movie and TV database.  
For more information about the available endpoints and usage, refer to the official documentation:  
[https://developer.themoviedb.org/reference/intro](https://developer.themoviedb.org/reference/intro/getting-started)

## 📦 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Momeks/TMDB.git
2.    Open TMDB.xcodeproj in Xcode.
3.    Run on a simulator or device.
