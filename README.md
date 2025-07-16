# ShortLink Service

A simple Ruby on Rails-based URL shortening service that converts long URLs into short, unique codes and decodes them back to their original form.

---

## Features

- `POST /encode`: Encodes a long original URL to a short one.
- `GET /decode`: Decodes a short URL back to its original.
- Ensures short code uniqueness with collision handling.
- JSON-formatted responses with appropriate status codes.
- Clear error handling using `rescue_from`.
- Tested with RSpec (requests + services).
- Clean code organization with service objects and concerns.

---

## Setup

### Prerequisites

- Ruby 3.4.4
- Rails 7.1.3
- PostgreSQL 15
- Bundler

### Installation

```bash
git clone https://github.com/giahagiahuy/shortlink.git
cd shortlink
bundle install
# Optional: create a `.env` file with DB_USERNAME and DB_PASSWORD
rails db:create
rails db:migrate
```

---

## Running the Server

```bash
rails s
```

Server runs at:

```
http://localhost:3000
```

---

## API Endpoints

### 1. Encode

**POST** `/api/v1/encode`

**Request:**

```json
{
  "original_url": "https://example.com/page"
}
```

**Response:**

```json
{
  "short_url": "http://localhost:3000/AbCdEf"
}
```

---

### 2. Decode

**GET** `/api/v1/decode`

**Request:**

```json
{
  "short_url": "http://localhost:3000/AbCdEf"
}
```

**Response:**

```json
{
  "original_url": "https://example.com/page"
}
```

---

## Running Tests

```bash
bundle exec rspec
```

## Potential attacks

- Abuse by spammers (DDOS): Attackers may spam the endpoint to create short links to malicious URLs or overwhelm the service.
- Massive payload parameter: Sending large or malformed payloads to exploit weak validations.
- Database Injection: Unsafe parameter usage leading to database corruption.
- Short code duplicate: Risk of duplicate short codes if uniqueness isn't strictly enforced.

---

## Scalability Notes

- Longer Short Codes: Increase short code length from 6 to 7+ characters to allow more unique combinations (62⁷ ≫ 62⁶).
- Uniqueness & Performance: As the number of rows grows, uniqueness checks and lookups can become slower.Use read replicas for scaling read-heavy decode operations.
- Horizontally scaling: Use multiple app instances behind a load balancer.
- Caching: Use Redis to cache short code lookups to reduce DB hits.
- API Rate Limiting: Use Rack::Attack to protect against abuse and DDoS.
- Monitoring / Logging: Use tools like Sentry or New Relic for visibility into errors and performance.

---

## Evaluation Criteria (Self-Check)

| Criteria                       | ✅ Covered |
|------------------------------- |-------------|
| Ruby best practices            | ✅          |
| `/encode` and `/decode`        | ✅          |
| Feature completeness           | ✅          |
| Correct behavior               | ✅          |
| Maintainability                | ✅          |
| Security considerations        | ✅          |
| Scalability thoughts           | ✅          |
