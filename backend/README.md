# CapCut Clone Backend (FastAPI)

This is the backend server for the CapCut Clone mobile app, providing user authentication, cloud project sync, asset cataloging (stickers/effects), and video processing.

## Setup Instructions

### Prerequisites
- Python 3.10 or higher installed.
- Git.

### 1. Create a Python Virtual Environment
Navigate to the `backend` directory and run:
```bash
python -m venv .venv
```

### 2. Activate the Virtual Environment
- **On Windows (PowerShell)**:
  ```powershell
  .venv\Scripts\Activate.ps1
  ```
- **On Windows (Command Prompt)**:
  ```cmd
  .venv\Scripts\activate.bat
  ```
- **On macOS/Linux**:
  ```bash
  source .venv/bin/activate
  ```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Run the Server
Start the local development server:
```bash
uvicorn app.main:app --reload
```
The API server will run at [http://127.0.0.1:8000](http://127.0.0.1:8000).
- Open [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs) in your browser to view the interactive Swagger API documentation.
