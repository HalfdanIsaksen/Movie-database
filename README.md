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
<img width="321" height="694" alt="image" src="https://github.com/user-attachments/assets/dee91536-6371-40c1-81c4-f3ec932586d6" />
<img width="321" height="694" alt="image" src="https://github.com/user-attachments/assets/50d489a0-0af5-4772-9171-24ebae275198" />
<img width="321" height="694" alt="image" src="https://github.com/user-attachments/assets/f9a35c09-253f-4bff-ae90-0b8458087350" />


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
```bash\
git clone https://github.com/your-username/Swift-Movie-Search.git\
cd Swift-Movie-Search
```

###  2. Install dependencies
No external dependencies – everything runs with Swift and Xcode.

### 3. Configure API Key
Get a free API key from TMDB: https://www.themoviedb.org. \
Create a file called Secrets.xcconfig in the project root: \
TMDB_API_KEY = your_api_key_here \
The project will automatically use this key when building.
