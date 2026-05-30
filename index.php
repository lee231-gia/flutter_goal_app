<?php
declare(strict_types=1);

header('Content-Type: application/json');

echo json_encode([
    'project' => 'Goal Tracker CRUD API',
    'frontend' => 'Flutter app in flutter_goal_app/',
    'database' => 'MySQL using schema.sql',
    'endpoints' => [
        'GET /goals.php',
        'GET /goals.php?id=1',
        'POST /goals.php',
        'PUT /goals.php',
        'DELETE /goals.php?id=1',
    ],
]);
