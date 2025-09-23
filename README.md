# 🎬 Swift Movie Search  

Swift Movie Search is an iOS app built with **SwiftUI** that allows users to search for movies, explore details, and get personalized recommendations based on their favorites. It integrates with [The Movie Database (TMDB)](https://www.themoviedb.org/) API to provide real-time movie data.  

---

## ✨ Features  

- 🔍 **Search movies** by title with live results  
- 🎥 **Movie details** including posters, descriptions, and release dates  
- ❤️ **Favorites system** to save movies you love  
- 🤖 **Recommendations** generated from your favorite movies  
- 📱 **Modern SwiftUI UI** with responsive layouts (grid & lists)  
- ⚡ **Async/Await** API requests for smooth performance  

---

## 📸 Screenshots  

*(Add screenshots or GIFs of your app here once available)*  

---

## 🛠️ Tech Stack  

- **Swift** (iOS 17+)  
- **SwiftUI** – declarative UI  
- **Combine / @StateObject / @EnvironmentObject** – reactive data binding  
- **TMDB API** – movie data provider  
- **AsyncImage** – poster loading with caching  

---

## 🚀 Getting Started  

### 1. Clone the repository  
``bash
git clone https://github.com/your-username/Swift-Movie-Search.git
cd Swift-Movie-Search ``

###  2. Install dependencies
No external dependencies – everything runs with Swift and Xcode.

### 3. Configure API Key
Get a free API key from TMDB: https://www.themoviedb.org.
Create a file called Secrets.xcconfig in the project root:
TMDB_API_KEY = your_api_key_here
The project will automatically use this key when building.
