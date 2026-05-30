# Goal Tracker CRUD API Presentation Script

Use this as your speaking guide during the virtual presentation. You do not need to memorize every word. Read it, understand it, then explain it naturally.

## 1. Before The Presentation

Open these first:

1. XAMPP Control Panel
2. VS Code project folder: `C:\Users\Admin\Documents\api_crud`
3. Postman or the VS Code API testing tab
4. Browser or Flutter app, if you will show the frontend
5. phpMyAdmin if you want to show the database

Make sure MySQL is running in XAMPP.

Import the database if you have not done it yet:

1. Open `http://localhost/phpmyadmin`
2. Click Import
3. Choose `schema.sql`
4. Click Go

Start the PHP API server:

```powershell
cd C:\Users\Admin\Documents\api_crud
C:\xampp\php\php.exe -S localhost:8000
```

Keep that terminal open.

Your API URL is:

```text
http://localhost:8000/goals.php
```

## 2. Presentation Order

Recommended order:

1. Show the output first using Postman.
2. Explain what the project is.
3. Explain the tools used.
4. Explain the database.
5. Explain the API endpoints.
6. Explain the code files.
7. Show the frontend if asked or if you want extra points.
8. Mention GitHub submission.

## 3. Opening Script

Good day. Today I will present my final exam project, which is a Goal Tracker CRUD API built using PHP and MySQL.

The purpose of this project is to manage goals. A user can add a goal, view goals, update a goal, delete a goal, and filter goals by category, term, and status.

The categories include Personal, School, Home, Health, Work, and others. The terms include Short Term, Medium Term, and Long Term. The statuses include Not Started, In Progress, and Done.

This project has a PHP backend API, a MySQL database, manual Postman testing, and a Flutter frontend connected to the API.

## 4. Show The Output First

Say:

First, I will show that the API is working using Postman.

### Read All Goals

Use:

```text
GET http://localhost:8000/goals.php
```

Say:

This request uses GET, which means it reads data. The API returns a JSON response containing all goals from the MySQL database.

Expected result:

```json
{
    "data": [
        {
            "id": 1,
            "title": "Finish PHP CRUD API",
            "category": "School",
            "term": "Short Term",
            "status": "Done",
            "notes": "Prepare for final exam presentation."
        }
    ]
}
```

### Create Goal

Use:

```text
POST http://localhost:8000/goals.php
```

Headers:

```text
Content-Type: application/json
```

Body:

```json
{
    "title": "Practice presentation",
    "category": "School",
    "term": "Short Term",
    "status": "In Progress",
    "notes": "Practice explaining the code and Postman."
}
```

Say:

This request uses POST, which means it creates a new goal. The body contains the data that will be inserted into the database.

### Read One Goal

Use:

```text
GET http://localhost:8000/goals.php?id=1
```

Say:

This reads only one goal. The `id` is used because each goal has a unique id in the database.

### Update Goal

Use:

```text
PUT http://localhost:8000/goals.php
```

Body:

```json
{
    "id": 1,
    "title": "Finish PHP CRUD API",
    "category": "School",
    "term": "Short Term",
    "status": "Done",
    "notes": "I already practiced the presentation."
}
```

Say:

This request uses PUT, which means it updates an existing goal. The API needs the id so it knows which goal to update.

### Delete Goal

Use:

```text
DELETE http://localhost:8000/goals.php?id=1
```

Say:

This request uses DELETE, which removes one goal from the database using its id.

## 5. Project Explanation Script

My project is a CRUD API. CRUD means Create, Read, Update, and Delete.

In my project:

- Create means adding a new goal.
- Read means viewing all goals or one goal.
- Update means editing an existing goal.
- Delete means removing a goal.

The backend is written in PHP. The PHP file receives requests from Postman or from the Flutter frontend.

The database is MySQL. It stores the goals permanently.

The API returns JSON. JSON is a data format that is easy for Postman, Flutter, and other applications to read.

## 6. Tools Used Script

I used PHP for the backend because PHP can handle requests, process data, connect to MySQL, and return JSON responses.

I used MySQL as the database because it is common for PHP projects and works well with phpMyAdmin and XAMPP.

I used MySQLi to connect PHP to MySQL. MySQL is the database, while MySQLi is the PHP tool that allows PHP to communicate with MySQL.

I used Postman to test the API manually. This is important because it proves the backend works even without the frontend.

I used Flutter and Dart for the frontend. The frontend is an extra feature that connects to the API and lets the user manage goals through an app interface.

I used Git and GitHub for version control and project submission.

## 7. Database Explanation Script

The database name is `goal_tracker`.

The table name is `goals`.

The table has these important columns:

- `id`: unique number for each goal.
- `title`: the name of the goal.
- `category`: the type of goal, like School or Personal.
- `term`: short term, medium term, or long term.
- `status`: progress of the goal.
- `notes`: extra details.
- `created_at`: when the goal was created.
- `updated_at`: when the goal was last updated.

The `id` is very important because it is used when reading one goal, updating a goal, or deleting a goal.

## 8. Code Explanation Script

### `db.php`

This file connects the PHP project to the MySQL database.

The `Database` class stores the connection.

The code reads settings like database host, name, username, password, and port.

This line connects to MySQL:

```php
new mysqli($host, $user, $pass, $name, $port);
```

I used MySQLi because PHP needs a tool to communicate with MySQL.

The code also checks if the connection failed. If it fails, it throws an error.

### `goals.php`

This is the main API file.

It starts by setting the response type to JSON:

```php
header('Content-Type: application/json');
```

This tells Postman and Flutter that the response is JSON.

The file has a `Goal` class. This class contains the database actions:

- `all()` reads all goals.
- `find()` reads one goal.
- `create()` adds a goal.
- `update()` edits a goal.
- `delete()` removes a goal.
- `clean()` validates and prepares input.

The file checks the HTTP method:

- If the method is GET, it reads data.
- If the method is POST, it creates data.
- If the method is PUT or PATCH, it updates data.
- If the method is DELETE, it deletes data.

### Prepared Statements

The project uses prepared statements.

Example:

```php
$stmt = $this->db->prepare('SELECT * FROM goals WHERE id = ?');
$stmt->bind_param('i', $id);
```

The question mark is a placeholder. The real value is attached using `bind_param()`.

This is safer than directly putting user input into SQL because it helps prevent SQL injection.

### `schema.sql`

This file creates the database and table.

It also inserts sample goals so the API has data to show immediately.

### Flutter Files

The Flutter frontend is inside `flutter_goal_app`.

`main.dart` starts the app.

`home.dart` is the main screen.

`goal.dart` is the model. It represents one goal.

`api_services.dart` sends HTTP requests to the PHP API.

`goal_form.dart` is the add/edit form.

`goal_card.dart` displays one goal.

`goal_list.dart` displays many goals.

`filter_bar.dart` filters goals by category, term, or status.

## 9. Frontend Script

If showing the Flutter app, say:

This is the Flutter frontend connected to my PHP API. When I add, edit, or delete a goal here, Flutter sends a request to `goals.php`. The PHP API then updates the MySQL database and returns a JSON response.

The frontend is not the database. It only displays data and sends user actions to the API.

## 10. Common Questions

What is CRUD?

CRUD means Create, Read, Update, and Delete.

What is an API?

An API is a connection point that lets applications communicate. In my project, Postman and Flutter communicate with PHP through the API.

What is MySQL?

MySQL is the database where the goals are stored.

What is MySQLi?

MySQLi is the PHP extension used to connect PHP to MySQL. MySQL is the database. MySQLi is the connector.

Why use Postman?

Postman tests the API directly. It proves the backend works even without the frontend.

Why use JSON?

JSON is easy for applications to send and read. PHP returns JSON, and Flutter can convert that JSON into app data.

Why use prepared statements?

Prepared statements help protect the database from SQL injection.

What is SQL injection?

SQL injection is when harmful SQL code is placed into user input. Prepared statements help prevent that by separating SQL code from user data.

Why is `id` important?

The id identifies one exact goal. It is needed for reading one goal, updating one goal, and deleting one goal.

What happens if the title is empty?

The API returns an error because the title is required.

What is the difference between backend and frontend?

The backend handles the data and database. The frontend is what the user sees and clicks.

## 11. Closing Script

That is my Goal Tracker CRUD API project. It uses PHP for the backend, MySQL for the database, Postman for API testing, and Flutter for the frontend.

The project demonstrates the complete CRUD operations: create, read, update, and delete. It is also connected to a database, and the frontend communicates with the API.

Thank you.
