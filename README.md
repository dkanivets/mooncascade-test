## Mooncascade test project
### Setup
To setup project simply clone repository and open **.xcworspace* file. All dependencies are commited to the repo to simplify project setup. However in real life example I would prefer to gitignore pods.

### Features

* I tried to follow *MVVM* architecture with usage of **ReactiveCocoa**
* Persistency implemented with **Realm**, however you wouldn't find any migration, only adding entities and cleaning full database is implemented in this test project. I've added cleaning because there is no unique ID for employees, also because of this reason you will find some duplicates in DB.
* I've added simple tests to ensure that server responses are parsed
* The only complex algorithm that I can see here is concatenating responses from two URLs. At first I've made them to finish and concat results, but it caused problems with DB cleaning, so I decided to concat resulting JSONs and after that map [JSON] to [Employee], also performing cleaning just before mapping operation. You can check how it works by changing cities array in EmployeesViewController call at line 71: 
        viewModel.updateItemsAction.apply([.tartu, .tallinn]).on(
Passing single city to this call will returns result only for it.        

### What this app can do:

* get and show contacts & details
* show native contact view if any match found


