# Movie Watchlist (SwiftUI State Management)

Companion project for the **SwiftUI State Management** article series published on Medium.

- **Part 1:** SwiftUI State Management Using @State, @StateObject, and @ObservedObject → [Read on Medium](https://medium.com/swiftable/stop-guessing-heres-exactly-when-to-use-state-stateobject-and-observedobject-in-swiftui-b9452fcd284a)
- **Part 2:** SwiftUI State Management Using @Binding, @EnvironmentObject, @Observable → [Read on Medium](https://nitinagam.medium.com/swiftui-state-management-using-binding-environmentobject-observable-7bd61ba40ab5)
- **Part 3:** SwiftUI State Management Mistakes Every Developer Makes (And How to Fix Them) → [Read on Medium](https://medium.com/swiftable/swiftui-state-management-mistakes-every-developer-makes-and-how-to-fix-them-d33741951af6)
- **Part 4:** SwiftUI State Management: Handling Complex Screens, Forms & Multi-Step Flows → [Read on Medium](https://medium.com/swiftable/swiftui-state-management-handling-complex-screens-forms-multi-step-flows-ab54dd517430)

<br>

### Project Structure

- MovieListApp: App entry point. Owns UserPreferences via @StateObject and injects it into the environment using .environmentObject()
- MovieListApp_Observable: iOS 17+ equivalent entry point. Shows how @State replaces @StateObject and .environment() replaces .environmentObject(). Comparison only but not the live entry point.
- WatchlistViewModel_ObservableObject: Powers the running app. Uses ObservableObject + @Published. Owned by WatchlistView via @StateObject. Shared with MovieDetailView via @ObservedObject.
- WatchlistViewModel_Observable: iOS 17+ only. Uses @Observable macro. No @Published needed. Owned via @State. Shared as a plain property.
- MovieDetailView_ObservableObject: Child screen. Receives WatchlistViewModel via @ObservedObject same instance as parent. Reads UserPreferences via @EnvironmentObject. Uses local @State for the remove confirmation alert.
- MovieDetailView_Observable: iOS 17+ version of MovieDetailView. Shows how @ObservedObject becomes a plain property when using @Observable means no wrapper needed.
- UserPreferencesObservableObject: ObservableObject holding app-wide user settings. Injected at root, consumed anywhere via @EnvironmentObject without prop drilling.
- UserPreferencesObservable: iOS 17+ version of UserPreferences holding app-wide user settings. Injected at root (i.e. MovieListApp_Observable), consumed anywhere via @Environment.

<br>

### Feature Overview

The app is a Movie Watchlist where a user can:

- Browse a list of movies fetched from a mock API
- Search and filter by genre or watched status
- Open a movie detail screen and mark it as watched
- Remove a movie from the watchlist
- Update their display name and toggle rating visibility via Settings

Every feature was chosen to naturally introduce a specific state management wrapper not as a toy example, but as the kind of problem you'd actually face in a real project.

<br>

### The ObservableObject vs @Observable Split

The `_ObservableObject` and `_Observable` file suffixes make the two approaches easy to compare. The business logic inside each pair is identical but only the observation declarations differ.

<br>

### Key Patterns To Understand

**1. The draft pattern in SettingsSheetView**
`draftName` is a local `@State` that holds an uncommitted copy of `preferences.displayName`. Cancelling discards the draft. Saving commits it. This prevents live writes to shared state while the user is still editing means a common production pattern for settings screens and modals.

**2. @Binding for reusable components**
`FilterBarView` owns nothing. It holds `@Binding` references to state that lives in `WatchlistView`. This keeps the filter logic encapsulated in one component while the source of truth stays exactly where it belongs means in the parent.

**3. @EnvironmentObject without prop drilling**
`UserPreferences` is consumed in `WatchlistView`, `MovieDetailView`, and `SettingsSheetView` none of which are direct parent-child pairs in every case. Without `@EnvironmentObject`, this object would need to be threaded through every intermediate view. With it, each view declares what it needs and SwiftUI handles the rest.

**4. @StateObject vs @ObservedObject ownership**
`WatchlistViewModel_ObservableObject` is created once in `WatchlistView_ObservableObject` via `@StateObject`. `MovieDetailView_ObservableObject` receives the same instance via `@ObservedObject`. When `markAsWatched()` is called in the detail screen, the change propagates back to the list automatically because both views share the same object in memory.

<br>

***Thanks for visting this page!***

