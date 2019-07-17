HomeTime
========

Xcode version: 10.2.1

---
# Setps to restructure the code


* Separating all API call into service (TramDataService class) for better testability and reusability (use DI whenever use it)
* Separating data logic into viewModel  (TramTimeTableViewModel class) for better testability and reusability
* Keeping viewController (TramTimeTableViewController class) lean and focus on handle user interaction and display data
* Adding model layer (TramData struct)
* Adding different extensions for future potential usage (e.g. error banner in UIView extension)
* Adding unit tests to test most of the method in viewModel and service
* Modified and included more behavior-driven-test




