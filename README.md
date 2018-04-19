## Mooncascade test project
### Setup
To setup project simply clone repository and open **.xcworspace* file. All dependencies are commited to the repo to simplify project setup. However in real life example I would prefer to gitignore pods.

### Features

* I tried to follow *MVVM* architecture with usage of **ReactiveCocoa**
* Persistency implemented with **Realm**, however you wouldn't find any migration, only adding entities and cleaning full database is implemented in this test project. I've added cleaning because there is no unique ID for employees, also because of this reason you will find some duplicates in DB.
* I've added simple tests to ensure that server responses are parsed

### What this app can do:

* get and show contacts & details
* show native contact view if any match found

