<?php
declare(strict_types=1);

require __DIR__ . '/db.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

final class Goal
{
    public function __construct(private mysqli $db)
    {
    }

    public function all(?string $category, ?string $term): array
    {
        $sql = 'SELECT * FROM goals ORDER BY id DESC';
        $stmt = $this->db->prepare($sql);

        if ($category && $term) {
            $stmt = $this->db->prepare('SELECT * FROM goals WHERE category = ? AND term = ? ORDER BY id DESC');
            $stmt->bind_param('ss', $category, $term);
        } elseif ($category) {
            $stmt = $this->db->prepare('SELECT * FROM goals WHERE category = ? ORDER BY id DESC');
            $stmt->bind_param('s', $category);
        } elseif ($term) {
            $stmt = $this->db->prepare('SELECT * FROM goals WHERE term = ? ORDER BY id DESC');
            $stmt->bind_param('s', $term);
        }

        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM goals WHERE id = ?');
        $stmt->bind_param('i', $id);
        $stmt->execute();
        $goal = $stmt->get_result()->fetch_assoc();
        return $goal ?: null;
    }

    public function create(array $data): int
    {
        [$title, $category, $term, $status, $notes] = $this->clean($data);
        $stmt = $this->db->prepare(
            'INSERT INTO goals (title, category, term, status, notes) VALUES (?, ?, ?, ?, ?)'
        );
        $stmt->bind_param('sssss', $title, $category, $term, $status, $notes);
        $stmt->execute();
        return $stmt->insert_id;
    }

    public function update(int $id, array $data): bool
    {
        [$title, $category, $term, $status, $notes] = $this->clean($data);
        $stmt = $this->db->prepare(
            'UPDATE goals SET title = ?, category = ?, term = ?, status = ?, notes = ? WHERE id = ?'
        );
        $stmt->bind_param('sssssi', $title, $category, $term, $status, $notes, $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }

    public function delete(int $id): bool
    {
        $stmt = $this->db->prepare('DELETE FROM goals WHERE id = ?');
        $stmt->bind_param('i', $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }

    private function clean(array $data): array
    {
        $title = trim((string) ($data['title'] ?? ''));
        $category = trim((string) ($data['category'] ?? 'Personal'));
        $term = trim((string) ($data['term'] ?? 'Short Term'));
        $status = trim((string) ($data['status'] ?? 'Not Started'));
        $notes = trim((string) ($data['notes'] ?? ''));

        if ($title === '') {
            sendJson(['error' => 'title is required'], 422);
        }

        return [$title, $category, $term, $status, $notes];
    }
}

function body(): array
{
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    return is_array($data) ? $data : $_POST;
}

function sendJson(array $payload, int $status = 200): void
{
    http_response_code($status);
    echo json_encode($payload);
    exit;
}

try {
    $goal = new Goal((new Database())->connection());
    $method = strtoupper($_POST['_method'] ?? $_SERVER['REQUEST_METHOD']);

    if ($method === 'GET' && isset($_GET['id'])) {
        $item = $goal->find((int) $_GET['id']);
        $item ? sendJson(['data' => $item]) : sendJson(['error' => 'Goal not found'], 404);
    }

    if ($method === 'GET') {
        sendJson(['data' => $goal->all($_GET['category'] ?? null, $_GET['term'] ?? null)]);
    }

    if ($method === 'POST') {
        sendJson(['message' => 'Goal created', 'id' => $goal->create(body())], 201);
    }

    if ($method === 'PUT' || $method === 'PATCH') {
        $data = body();
        $id = (int) ($data['id'] ?? 0);
        if ($id <= 0) {
            sendJson(['error' => 'id is required'], 422);
        }

        $goal->update($id, $data)
            ? sendJson(['message' => 'Goal updated'])
            : sendJson(['message' => 'No changes made or goal not found']);
    }

    if ($method === 'DELETE') {
        $id = (int) ($_GET['id'] ?? body()['id'] ?? 0);
        if ($id <= 0) {
            sendJson(['error' => 'id is required'], 422);
        }

        $goal->delete($id)
            ? sendJson(['message' => 'Goal deleted'])
            : sendJson(['message' => 'Goal not found']);
    }

    sendJson(['error' => 'Invalid request method'], 405);
} catch (Throwable) {
    sendJson(['error' => 'Server error. Check database settings.'], 500);
}
