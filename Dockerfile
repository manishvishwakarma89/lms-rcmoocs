FROM python:3.13-slim
# Prevent Python from writing .pyc files and buffer std output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies for database connectors if necessary
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/

EXPOSE 8000
# Start Gunicorn for production or runserver for development
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
