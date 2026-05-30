# Goal Tracker CRUD API

This is a simple final-exam project: a PHP OOP CRUD API connected to a MySQL database, a Postman collection for testing, and a Flutter/Dart frontend connected to the API.

## Tools Used

- PHP: builds the backend API.
- MySQL: stores the goals permanently.
- MySQLi prepared statements: safely runs SQL queries.
- Postman: tests each API endpoint.
- Flutter and Dart: builds the mobile frontend.
- sqflite: local Flutter cache after goals are fetched from the API.
- Git and GitHub: version control and online repository submission.

## Project Files

```text
api_crud/
|-- db.php
|-- goals.php
|-- index.php
|-- schema.sql
|-- postman_collection.json
|-- env.example
`-- flutter_goal_app/
    |-- pubspec.yaml
    `-- lib/
        |-- main.dart
        |-- models/goal.dart
        |-- api_services/api_services.dart
        |-- database/local_goal_db.dart
        `-- pages/
            |-- home.dart
            `-- widgets/
                |-- filter_bar.dart
                |-- goal_card.dart
                |-- goal_form.dart
                `-- goal_list.dart
```

## Database Setup

Import `schema.sql` in phpMyAdmin or MySQL. It creates a database named `goal_tracker` and a table named `goals`.

```sql
CREATE DATABASE IF NOT EXISTS goal_tracker;
USE goal_tracker;
```

The `goals` table stores:

- `id`: unique number for each goal.
- `title`: goal name.
- `category`: Personal, School, Home, Health, or Work.
- `term`: Short Term, Medium Term, or Long Term.
- `status`: Not Started, In Progress, or Done.
- `notes`: extra details.
- `created_at` and `updated_at`: automatic timestamps.

## Run the PHP API

Copy `env.example` to `.env` if your MySQL settings are different.

```text
DB_HOST=localhost
DB_NAME=goal_tracker
DB_USER=root
DB_PASS=
DB_PORT=3306
```

Start the PHP server:

```bash
php -S localhost:8000
```

If you use XAMPP on Windows:

```bash
C:\xampp\php\php.exe -S localhost:8000
```

Open:

```text
http://localhost:8000
```

## API Endpoints

| Method | Endpoint | Meaning |
| --- | --- | --- |
| GET | `/goals.php` | Read all goals |
| GET | `/goals.php?id=1` | Read one goal |
| GET | `/goals.php?category=School` | Filter by category |
| GET | `/goals.php?term=Long%20Term` | Filter by term |
| POST | `/goals.php` | Create a goal |
| PUT | `/goals.php` | Update a goal |
| DELETE | `/goals.php?id=1` | Delete a goal |

Create body:

```json
{
  "title": "Review API code",
  "category": "School",
  "term": "Short Term",
  "status": "In Progress",
  "notes": "Practice explaining each function."
}
```

Update body:

```json
{
  "id": 1,
  "title": "Finish PHP CRUD API",
  "category": "School",
  "term": "Short Term",
  "status": "Done",
  "notes": "Ready for presentation."
}
```

## Postman Testing

Import `postman_collection.json` into Postman. It already contains:

- Read all goals
- Read one goal
- Create goal
- Update goal
- Delete goal

Use Postman to prove the API works even without the Flutter app.

## Run the Flutter App

Go inside the Flutter folder:

```bash
cd flutter_goal_app
flutter pub get
flutter run
```

Important URL note:

- Android emulator uses `http://10.0.2.2:8000/goals.php`.
- Real phone must use your computer IP address, for example `http://192.168.1.10:8000/goals.php`.
- Browser or desktop Flutter can use `http://localhost:8000/goals.php`.

The URL is in `flutter_goal_app/lib/api_services/api_services.dart` inside `ApiService`.

## How the Code Works

### `db.php`

`Database` is a class. Its job is only to connect PHP to MySQL.

- `declare(strict_types=1);` makes PHP stricter with data types.
- `private mysqli $connection;` stores the database connection inside the object.
- `__construct()` runs automatically when `new Database()` is called.
- `loadEnv()` reads `.env` so database settings are not hardcoded.
- `new mysqli(...)` connects to MySQL.
- `connect_error` checks if the connection failed.
- `set_charset('utf8mb4')` supports normal text and special characters.
- `connection()` returns the MySQL connection to other classes.

### `goals.php`

This is the API file. It receives HTTP requests and returns JSON.

- `header('Content-Type: application/json')` tells Postman/Flutter the response is JSON.
- CORS headers allow the frontend to call the API.
- `Goal` is an OOP class for database actions.
- `all()` reads all goals and can filter by category or term.
- `find()` reads one goal using its `id`.
- `create()` inserts a new goal.
- `update()` edits an existing goal.
- `delete()` removes a goal.
- `clean()` validates and prepares input data.
- `body()` reads JSON sent by Postman or Flutter.
- `sendJson()` sends a response and stops the script.

Prepared statements are used like this:

```php
$stmt = $this->db->prepare('SELECT * FROM goals WHERE id = ?');
$stmt->bind_param('i', $id);
```

The `?` is a placeholder. `bind_param()` safely puts the value into the query. This helps prevent SQL injection.

### Flutter files

The Flutter app is the frontend.

- `main.dart` starts the app only, so it stays short.
- `pages/home.dart` is the main screen, like the attached cat API `home.dart`.
- `widgets/filter_bar.dart` is based on the cat tag filter bar, but it filters goal categories.
- `widgets/goal_card.dart` is based on the cat card style, but it shows goal title, notes, category, term, and status.
- `widgets/goal_list.dart` displays the goal cards, like the cat list file.
- `widgets/goal_form.dart` contains the add/update form.
- `models/goal.dart` is the Dart model class.
- `Goal.fromJson()` converts API JSON into a Dart object.
- `toJson()` converts a Dart object into JSON for the API.
- `api_services/api_services.dart` sends HTTP requests to PHP.
- `getGoals()` reads goals from the API.
- `saveGoal()` creates or updates a goal.
- `deleteGoal()` deletes a goal.
- `database/local_goal_db.dart` uses sqflite to cache the latest goals locally.

## Common Teacher Questions

What is CRUD?

CRUD means Create, Read, Update, Delete. In this project: POST creates, GET reads, PUT updates, and DELETE removes goals.

What database did you use?

MySQL for the backend database. Flutter also uses sqflite only as a local cache, not as the main database.

Why use PHP?

PHP handles the backend API. It receives requests from Postman or Flutter, talks to MySQL, and returns JSON.

Why use OOP?

OOP separates responsibilities. `Database` handles connection. `Goal` handles goal-related CRUD queries.

Why use prepared statements?

Prepared statements make SQL queries safer because user input is not directly joined into SQL text.

What is JSON?

JSON is a data format used to send data between the API and frontend. Flutter and Postman can easily read JSON.

What is Postman for?

Postman tests the API directly. It proves the backend works even before connecting a frontend.

What is the difference between MySQL and sqflite?

MySQL is the server database used by PHP. sqflite is a local mobile database used by Flutter for offline/local cache.

Why is `id` important?

`id` uniquely identifies one goal. It is needed when reading one goal, updating a goal, or deleting a goal.

What happens when the title is empty?

The API returns a `422` validation error because `title` is required.

## GitHub Submission

Create an empty GitHub repository, then run:

```bash
git add .
git commit -m "Build goal tracker CRUD API"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Submit the GitHub repository link to your teacher.
