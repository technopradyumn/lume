# Lume

Lume is a full-stack video and community platform. It combines video discovery, creator tools, social posts, comments, subscriptions, notifications, and a personal **Watch Later** list in one responsive experience.

## Highlights

- Browse, search, and watch videos
- Like videos and comments
- Save videos to **Watch Later** from the player or a video card’s three-dot menu
- View, remove, and revisit saved videos from **Saved Videos**
- Create posts, reply to community discussions, and report content
- Subscribe to channels and receive notifications
- Manage a channel, profile settings, uploads, and watch history
- Responsive desktop and mobile navigation with light and dark themes

> User-created playlists are intentionally not part of the current product. Saved videos are handled through the dedicated Watch Later feature.

## Tech stack

| Area | Technology |
| --- | --- |
| Frontend | React 18, Vite, React Router, Axios, Lucide React |
| Backend | Node.js, Express 5, MongoDB, Mongoose |
| Authentication | JWT access tokens with HTTP-only refresh-token cookies |
| Media storage | Supabase |
| Mobile app | Flutter source is available in `lume_app/` |

## Repository structure

```text
Lume/
├── frontend/       # React + Vite web app
├── backend/        # Express API and MongoDB models
├── lume_app/       # Flutter mobile client
└── package.json     # Root development commands
```

## Quick start

### Prerequisites

- Node.js 18 or later
- npm 9 or later
- A MongoDB database (local or Atlas)
- A Supabase project for media uploads

### 1. Install dependencies

```bash
npm run setup
```

### 2. Configure the API

Copy the sample environment file and replace its placeholder values:

```bash
copy backend\\.env.sample backend\\.env
```

On macOS or Linux:

```bash
cp backend/.env.sample backend/.env
```

Required values in `backend/.env`:

```env
PORT=8000
MONGODB_URI=mongodb+srv://<user>:<password>@<cluster>/<database>
ACCESS_TOKEN_SECRET=<long-random-secret>
ACCESS_TOKEN_EXPIRY=1d
REFRESH_TOKEN_SECRET=<another-long-random-secret>
REFRESH_TOKEN_EXPIRY=10d
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=<supabase-anon-key>
```

### 3. Run the web app and API

```bash
npm run dev
```

This starts:

- Web app: `http://localhost:5173`
- API: `http://localhost:8000`

The Vite development server proxies `/api` requests to the API server.

## Available commands

| Command | Description |
| --- | --- |
| `npm run setup` | Install frontend and backend dependencies |
| `npm run dev` | Start frontend and backend together |
| `npm run frontend` | Start only the Vite frontend |
| `npm run backend` | Start only the Express API with Nodemon |
| `npm --prefix frontend run build` | Create a production frontend build |
| `npm --prefix frontend run preview` | Preview the production frontend build |

## Saved Videos / Watch Later

Saving is available in two places:

1. On a video page, use the **Save** button.
2. On any video card, open the three-dot menu and select **Save to Watch Later**.

The control changes to a filled remove state when a video is saved. Saved items are listed at `/saved` and can be removed from either the video page or video-card menu.

The API endpoints are authenticated and are available under:

```text
GET   /api/v1/users/saved-videos
PATCH /api/v1/users/saved-videos/:videoId
```

## Development notes

- Keep secrets only in `backend/.env`; do not commit that file.
- If backend routes change while using a manually started server, restart the backend process. `npm run backend` uses Nodemon and reloads automatically.
- Run the frontend build before opening a pull request or deploying:

  ```bash
  npm --prefix frontend run build
  ```

## License

This project is licensed under the ISC license.
