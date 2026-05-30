<?php
header('Content-Type: application/json');
echo json_encode(
    ['project' => 'Goal Tracker CRUD API', 'api' => '/goals.php', 'frontend' => 'flutter_goal_app'],
    JSON_PRETTY_PRINT
);
