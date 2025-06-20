FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PORT=8080

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --upgrade pip && \
    pip install poetry

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Set work directory and copy files
COPY pyproject.toml poetry.lock ./

# Copy the rest of the application
COPY . .

# Expose port (informational only, actual port is controlled by $PORT)
EXPOSE $PORT

# Run Uvicorn server
CMD ["uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8080"]
