# Goal Tracker Presentation Guide

Use this as your reviewer before presenting the project virtually. The short answer is: yes, the `api_crud` project implements the required CRUD API, database connection, manual Postman testing, and an extra Flutter frontend.

## Requirement Checklist

| Requirement | Status | Where |
| --- | --- | --- |
| PHP CRUD API | Done | `goals.php` |
| Connected to database | Done | `db.php`, `schema.sql` |
| Create data | Done | `POST /goals.php` |
| Read all data | Done | `GET /goals.php` |
| Read one data | Done | `GET /goals.php?id=1` |
| Update data | Done | `PUT /goals.php` |
| Delete data | Done | `DELETE /goals.php?id=1` |
| Postman testing | Done | Manual requests in Postman |
| Frontend connected to API | Done | `flutter_goal_app/` |
| GitHub submission | Needs your account/repo link | Use the commands in `README.md` |

Important note: the older `copy_api-project` folder still looks like a product/user sample. The completed goal tracker version is in `C:\Users\Admin\Documents\api_crud`.

## Project Summary

This project is a simple Goal Tracker or Goal Management System. A user can add goals, view goals, edit goals, delete goals, and filter them by category, term, or progress status.

The main categories are examples like:

- Personal
- School
- Home
- Health
- Work

The goal terms are:

- Short Term
- Medium Term
- Long Term

The progress statuses are:

- Not Started
- In Progress
- Done

## Tools Used

PHP is used for the backend API. It receives HTTP requests from Postman or Flutter, performs database actions, and returns JSON.

MySQL is used as the main database. It permanently stores the goals in the `goals` table.

MySQLi is the PHP database extension used to connect PHP to MySQL. This project uses prepared statements through MySQLi.

Postman is used to manually test the API. This is important because it proves the backend works even without the frontend.

Flutter and Dart are used for the frontend application. This gives the project extra points because the API is connected to a working app interface.

sqflite is used inside Flutter only as a local cache. The main database is still MySQL.

Git and GitHub are used to save the project history and submit the repository link to the teacher.

## Database Explanation

The database name is `goal_tracker`.

The table name is `goals`.

The table columns are:

| Column | Meaning |
| --- | --- |
| `id` | Unique number for each goal |
| `title` | Main name of the goal |
| `category` | Group of the goal, like School or Personal |
| `term` | Time length, like Short Term or Long Term |
| `status` | Progress, like Not Started or Done |
| `notes` | Extra details about the goal |
| `created_at` | Automatically stores when the row was created |
| `updated_at` | Automatically updates when the row is edited |

The `id` is important because update, delete, and read-one operations need to know exactly which goal to target.

## API Explanation

The API file is `goals.php`.

An API is a way for two programs to communicate. In this project, Postman and Flutter send requests to the PHP API. PHP talks to MySQL. Then PHP returns JSON.

JSON is the format used for the response. Example:

```json
{
  "message": "Goal created",
  "id": 4
}
```

## CRUD Mapping

CRUD means Create, Read, Update, Delete.

| CRUD Action | HTTP Method | Endpoint |
| --- | --- | --- |
| Create | POST | `/goals.php` |
| Read all | GET | `/goals.php` |
| Read one | GET | `/goals.php?id=1` |
| Update | PUT/PATCH | `/goals.php` |
| Delete | DELETE | `/goals.php?id=1` |

## Postman Demo Steps

1. Start the PHP server from the project folder.

```bash
php -S localhost:8000
```

2. Create each request manually in Postman.

3. Run `Read all goals`.

Expected result: JSON with a `data` array.

4. Run `Create goal`.

Expected result: a success message and a new `id`.

5. Run `Read one goal`.

Change the `id` if needed.

6. Run `Update goal`.

Make sure the body contains an existing `id`.

7. Run `Delete goal`.

Use the id of a goal you are safe to remove.

## Main PHP Files

### `db.php`

This file is responsible for the database connection.

Key parts:

`declare(strict_types=1);`

This makes PHP stricter about data types. It helps avoid confusing bugs.

`class Database`

This is an object-oriented class. Its responsibility is only database connection.

`loadEnv(__DIR__ . '/.env')`

This loads local database settings if you create a `.env` file.

`new mysqli($host, $user, $pass, $name, $port)`

This connects PHP to MySQL.

`connect_error`

This checks if the database connection failed.

`set_charset('utf8mb4')`

This makes the connection support normal text and wider characters.

`connection()`

This returns the MySQL connection so `goals.php` can use it.

### `goals.php`

This is the main backend API.

Key parts:

`require __DIR__ . '/db.php';`

This imports the database connection class.

`header('Content-Type: application/json');`

This tells clients that the response is JSON.

`Access-Control-Allow-Origin: *`

This allows a frontend like Flutter Web to call the API.

`final class Goal`

This class contains the goal database operations.

`all()`

Gets all goals. It can also filter by category, term, and status.

`find($id)`

Gets one goal by id.

`create($data)`

Creates a new goal from the request body.

`update($id, $data)`

Updates an existing goal.

`delete($id)`

Deletes one goal.

`clean($data)`

Prepares and validates input. It trims spaces and checks that title is not empty.

`body()`

Reads JSON from Postman or Flutter.

`sendJson()`

Sends a JSON response and stops the script.

`try/catch`

If an unexpected database or server error happens, the API returns a clean error response instead of showing raw PHP errors.

## Prepared Statements

This project uses prepared statements. Example:

```php
$stmt = $this->db->prepare('SELECT * FROM goals WHERE id = ?');
$stmt->bind_param('i', $id);
```

The `?` is a placeholder. The real value is attached using `bind_param()`.

This is safer than directly placing user input inside SQL because it helps prevent SQL injection.

In `bind_param()`:

- `i` means integer
- `s` means string

Example:

```php
$stmt->bind_param('sssss', $title, $category, $term, $status, $notes);
```

That means all five values are strings.

## Flutter Frontend Explanation

The Flutter app is inside `flutter_goal_app`.

Important files:

| File | Purpose |
| --- | --- |
| `main.dart` | Starts the Flutter app |
| `home.dart` | Main screen with filters and goal list |
| `goal.dart` | Goal model class |
| `api_services.dart` | Sends GET, POST, PUT, DELETE requests |
| `local_goal_db.dart` | Local cache using sqflite |
| `goal_form.dart` | Add/edit form |
| `goal_card.dart` | Displays one goal |
| `goal_list.dart` | Displays all goals |
| `filter_bar.dart` | Category/term/status filters |

The frontend talks to:

```text
http://localhost:8000/goals.php
```

When you add a goal in Flutter, Flutter sends a POST request to PHP. PHP inserts the goal into MySQL. Then Flutter reloads the list.

When you edit a goal, Flutter sends a PUT request.

When you delete a goal, Flutter sends a DELETE request.

## Common Teacher Questions and Answers

What is your project?

It is a Goal Tracker CRUD API with a connected frontend. It manages goals by category, term, and status.

What is CRUD?

CRUD means Create, Read, Update, Delete. These are the main operations for managing database records.

What language did you use for the backend?

PHP.

What database did you use?

MySQL.

What API did you use?

I built my own REST-style CRUD API in PHP. It uses HTTP methods like GET, POST, PUT, and DELETE.

Why did you use MySQL?

MySQL is common with PHP, easy to run in XAMPP/phpMyAdmin, and suitable for storing structured data like goals.

Why did you use prepared statements?

Prepared statements make database queries safer by separating SQL code from user input.

What is SQL injection?

SQL injection is an attack where a user tries to put harmful SQL code into input fields. Prepared statements help prevent it.

Why is Postman important?

Postman lets me test the backend directly. It proves that the API works even before opening the frontend.

What is JSON?

JSON is a data format used to send structured data between the backend and frontend.

What happens if the title is empty?

The API returns a 422 error saying that `title is required`.

Why do you have `created_at` and `updated_at`?

They automatically track when a goal was created and last updated.

Why do you have `.env`?

It allows database settings to be changed without editing the main code.

Why is `.env` in `.gitignore`?

Because `.env` can contain private database credentials. The example file is safe to upload, but the real `.env` should not be uploaded.

What is the difference between backend and frontend?

The backend is PHP and MySQL. It handles data and API logic. The frontend is Flutter. It is the user interface.

What is the role of `schema.sql`?

It creates the database, creates the `goals` table, and inserts sample data.

What is the role of `README.md`?

It explains how to set up, run, test, and submit the project.

What would you improve if you had more time?

I would add login authentication, stronger validation, due dates, priority levels, and deployment to an online hosting service.

## Simple Presentation Script

Good day. My project is a Goal Tracker CRUD API built with PHP and MySQL. It allows users to create, read, update, and delete goals. Each goal has a title, category, term, status, notes, and timestamps.

The backend API is in `goals.php`. It receives requests from Postman or the Flutter frontend and returns JSON responses. The database connection is handled by `db.php`, and the database structure is created by `schema.sql`.

For testing, I used Postman. I prepared a collection that tests reading all goals, reading one goal, creating a goal, updating a goal, and deleting a goal.

For additional points, I also made a Flutter frontend connected to the API. The app displays goals, filters them, and lets the user add, edit, and delete goals.

## Before You Submit

Make sure these are done:

- Import `schema.sql` into MySQL.
- Start the PHP server.
- Test all Postman requests.
- Run the Flutter app if you want to show the frontend.
- Push the project to GitHub.
- Send the GitHub repository link to your teacher.
