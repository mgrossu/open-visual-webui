# Base image
FROM opensuse/tumbleweed:latest

# Prevent Python from writing .pyc files and buffer output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install Python 3.11, build tools, and OpenCV dependencies
RUN zypper refresh && \
    zypper install -y --no-recommends \
        python311 \
        python311-pip \
        python311-devel \
        gcc \
        gcc-c++ \
        make \
        cmake \
        git \
        wget \
        Mesa-libGL1 \
        libglib-2_0-0 \
    && zypper clean -a

# Upgrade pip and install Python packages
COPY requirements.txt /app/
RUN python3.11 -m pip install --upgrade pip setuptools wheel
RUN python3.11 -m pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . /app/

EXPOSE 8008

CMD ["python3.11", "app.py"]
