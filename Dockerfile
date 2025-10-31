# Use the latest official Python 3.13 slim image
FROM python:3.13-slim

# Prevent Python from writing .pyc files and buffer output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt /app/

# Install system dependencies needed for OpenCV and building some Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libgl1 \
    libglib2.0-0 \
    cmake \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip, setuptools, and wheel to avoid build issues
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . /app/

# Expose the port Flask runs on
EXPOSE 8008

# Run the app
CMD ["python", "app.py"]
