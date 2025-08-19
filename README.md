Created an iOS Reader app that fetches and displays news articles using a public API (NewsAPI.org). The app supports offline viewing.

//MARK: ADD your API KEY in apiServices.swift file.

Used URLSession, for fetching all the data form REST API.
Used Coredata to store articles localy on Device for offline Viewing.
Pull to Refresh article list via UIRefreshControl on TopHeadlines page.
Added a search bar to filter news titles.
Added a Bookmarked Tab, you can save your favorite article in bookmark tab.
Used MVVM architecture.
System Default Light/Dark mode support.
Kingfisher- Used this in the Past, due to lack of time not able to use here. Its a lightweight Swift library for downloading and caching images from the web.
