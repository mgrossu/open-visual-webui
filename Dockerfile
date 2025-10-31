# Use openSUSE Tumbleweed base
FROM opensuse/tumbleweed:latest

# Prevent Python from writing .pyc files and buffer output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install Python 3.11 and development tools
RUN zypper refresh && \
    zypper install -y --no-recommends \
    python311 \
    python311-pip \
    python311-devel \
    gcc \
    g++ \
    make \
    cmake \
    git \
    wget \
    libGL1 \
    libglib-2_0-0 \
    && zypper clean -a

# Upgrade pip, setuptools, and wheel
RUN python3.11 -m pip install --upgrade pip setuptools wheel

# Copy requirements first for caching
COPY requirements.txt /app/

# Install Python dependencies using Python 3.11
RUN python3.11 -m pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . /app/

# Expose Flask port
EXPOSE 8008

# Run the app using Python 3.11
CMD ["python3.11", "app.py"]
