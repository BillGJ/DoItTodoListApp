# Do It - Todo List App

#### Video Demo:  <https://youtu.be/jGOsukZJT9A>
#### Description: A very modern Swift and SwiftUI Todo List iOS App that allows users to keep track of their "todos" or tasks if you will


## Background 

I our day to day activities we often have goals to achieve and unfortunately we also often fail to achieve them for one reason or another.
Research shows that our brains tends to be more focused on goals when we write them down and subsequently, when we can track them down and organize them we are more likely to achieve these goals. Since productivity matters in this fast-paced moving world, I decided to develop an iOS app that I call "Do It" using Swift and SwiftUI. Basically, this app allows users to search, create, read, update, delete, categorize (based on a prefilled set of categories) and star their "todos" or "tasks" if you will. In this app users can also search create, read, updatea and delete their own "todos" categories.


## Technical Overview

These are the tools that this Project leverages:

- The Swift Programming Language
- SwiftUI for the User Interface design
- Firebase for the backend


## User Stories

### 1: The "Do It" app allows its users to process new User registrations.

A user is able to create a new Account with these data points (username, first name, last name, email, password, phone number). 

- User registration will be successful if and only if:
  - Their username is not blank and is not already taken
  - Their first name is not blank
  - Their last name is not blank
  - Their email is not blank, is valid and is not already taken
  - Their password is at least 6 characters long.
    
If all these conditions are met, the new user is registered and assigned an id. The new account is persisted to the backend.

- If the registration attempt is not successful due to a duplicate username, the user sees a warning message.
- If the registration attempt is not successful due to blank first name, the user sees a warning message.
- If the registration attempt is not successful due to blank last name, the user sees a warning message.
- If the registration attempt is not successful due to a duplicate email, the user sees a warning message.
- If the registration attempt is not successful due to a blank or a less than 6 characters password the user sees a warning message.


### 2: The "Do It" app allows its users to process User logins.

A user is able to login using their credentials (email and password)

- The login will be successful if and only if the email and password provided in the text fields match a real account existing on the backend. 
  If successful, the user is redirected to his home tab account.
- If the login is not successful, the user sees a warning message and remains in the login page.


### 3: The "Do It" app allows its users to process the creation of new todos/tasks.

A user is able to create a new todo/task in his home tab account. While creating a todo, the user can also star it.

- The creation of the todo will be successful if and only if the required title and due date fields are not blank. Additionally there is a character limit for the title and description fields. 
If successful, the todo registration view is dismissed and the user sees a list of todos containing the newly added todo. The new todo is persisted to the backend.
- If the creation of the todo is not successful, the user sees a warning message.


### 4: The "Do It" app allows its users to retrieve all todos/tasks in their home tab account

A user is able to see a list of all the todos in their home tab account.

- The list of todos contains all todos retrieved from the backend based on today's date and upcoming dates. It is expected for the list to simply be empty if there are no todos.


### 5: The "Do It" app allows its users to search for todos/tasks in their home tab account

A user is able to search the list of all the todos in their home tab account by typing in a search bar.

- The list of todos returns todos searched from the search bar. It is expected for the list to simply be empty if there are no todos for the searched term.


### 6: The "Do It" app allows its users to filter todos/tasks in their home tab account by category

A user is able to filter the list of all the todos in their home tab account by tapping on a button category part of a list of category buttons that can be scrolled horizontally .

- The list of todos returns todos filtered by category. It is expected for the list to simply be empty if there are no todos for the filtered category.


### 7: The "Do It" app allows its users to retrieve a single todo/task.

A user is able to access a single todo/task from the todo list in their home tab account.


### 8: The "Do It" app allows its users to delete a single todo/task by swiping a single todo/task from right to left and tapping a delete button

A User is able to delete a single todo/task from the todo list in their home tab account.

- The deletion of an existing todo removes an existing todo from the backend.


### 9: The "Do It" app allows its users to edit a single todo/task by tapping on the single todo/task 

A User is able to edit a single todo/task from the todo list in their home tab account.

- The editing of an existing todo updates that existing todo from the backend.
- While editing a todo, a user can mark it as completed and also star it
- The list of todos contains all todos retrieved among which the newly updated todo that replaces the old todo from the backend. 


### 10: The "Do It" app allows its users to process the creation of new todo categories

A user is able to create a new todo/task category in his category tab account

- The creation of the todo category will be successful if and only if the required category name is not blank. Additionally there is a character limit for the category name field. 
If successful, the todo category registration view is dismissed and the user sees a list of todo categories containing the newly added todo category. The new todo category is persisted to the backend.
- If the creation of the todo category is not successful, the user sees a warning message.


### 11: The "Do It" app allows its users to retrieve all todo categories in their category tab account

A user is able to see a list of all the todo categories saved in the backend.

- The list of todo categories contains all todo categories retrieved from the backend. It is expected for the list to simply show prefilled categories if the user does not save new todo categories.


### 12: The "Do It" app allows its users to search for todos categories in their category tab account

A user is able to search the list of all the todo categories in their category tab account by typing in a search bar.

- The list of todo categories returns todo categories searched from the search bar. It is expected for the list to simply be empty if there are no todo categories for the searched term.


### 13: The "Do It" app allows its users to retrieve a single todo category.

A user is able to access a single todo category from the todo category list in their category tab account.


### 14: The "Do It" app allows its users to delete a single todo category by swiping a single todo category from right to left and tapping a delete button

A User is able to delete a single todo category from the todo category list in their category tab account.

- The deletion of an existing todo category removes an existing todo from the backend.


### 15: The "Do It" app allows its users to edit a single todo category by tapping on the single todo category 

A User is able to edit a single todo category from the todo category list in their category tab account.

- The editing of an existing todo category updates that existing todo category from the backend.

- The list of todo category contains all todo categories retrieved among which the newly updated todo category that replaces the old todo category from the backend. 


### 16: The "Do It" app allows its users to retrieve all starred todos/tasks in their starred tab account

A user is able to see a list of all the starred todos saved in the backend.

- The list of todos contains all starred todos retrieved from the backend. It is expected for the list to simply be empty if there are no starred todos.


### 17: The "Do It" app allows its users to search for starred todos/tasks in their starred tab account

A user is able to search the list of all the starred todos in their starred tab account by typing in a search bar.

- The list of todos returns todos searched from the search bar. It is expected for the list to simply be empty if there are no starred todos for the searched term.


### 18: The "Do It" app allows its users to filter starred todos/tasks in their starred tab account by category

A user is able to filter the list of all the starred todos in their starred tab account by tapping on a button category part of a list of category buttons that can be scrolled horizontally .

- The list of starred todos returns starred todos filtered by category. It is expected for the list to simply be empty if there are no starred todos for the filtered category.


### 19: The "Do It" app allows its users to retrieve all past todos/tasks in their past tab account

A user is able to see a list of all the past todos saved in the backend. Past todos are todos for which their due date is past.

- The list of todos contains all past todos retrieved from the backend. It is expected for the list to simply be empty if there are no starred todos.


### 20: The "Do It" app allows its users to search for past todos/tasks in their past tab account

A user is able to search the list of all the past todos in their past tab account by typing in a search bar.

- The list of todos returns todos searched from the search bar. It is expected for the list to simply be empty if there are no past todos for the searched term.


### 21: The "Do It" app allows its users to filter past todos/tasks in their past tab account by category

A user is able to filter the list of all the past todos in their past tab account by tapping on a button category part of a list of category buttons that can be scrolled horizontally .

- The list of past todos returns past todos filtered by category. It is expected for the list to simply be empty if there are no past todos for the filtered category.


### 22: The "Do It" app allows its users to view their profile in their profile tab account

- A user is able to see their profile info (avatar, username, first and last name, email, joining date) that was saved in the backend.
- A user is also able to see their todo stats (the number of completed, pending and overdue todos)
- Additionally a user is able to update their password from the profile tab account and also log out.



