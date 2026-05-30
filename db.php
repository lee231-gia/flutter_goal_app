<?php
declare(strict_types=1);

class Database
{
    private mysqli $connection;

    public function __construct()
    {
        $this->loadEnv(__DIR__ . '/.env');

        $host = $_ENV['DB_HOST'] ?? 'localhost';
        $name = $_ENV['DB_NAME'] ?? 'goal_tracker';
        $user = $_ENV['DB_USER'] ?? 'root';
        $pass = $_ENV['DB_PASS'] ?? '';
        $port = (int) ($_ENV['DB_PORT'] ?? 3306);

        $this->connection = new mysqli($host, $user, $pass, $name, $port);

        if ($this->connection->connect_error) {
            throw new RuntimeException('Database connection failed');
        }

        $this->connection->set_charset('utf8mb4');
    }

    public function connection(): mysqli
    {
        return $this->connection;
    }

    private function loadEnv(string $path): void
    {
        if (!file_exists($path)) {
            return;
        }

        foreach (file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
            $line = trim($line);
            if ($line === '' || str_starts_with($line, '#') || !str_contains($line, '=')) {
                continue;
            }

            [$key, $value] = explode('=', $line, 2);
            $_ENV[trim($key)] = trim($value);
        }
    }
}
