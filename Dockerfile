# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install necessary build tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libcairo2 \
    libcairo2-dev \
    pkg-config \
    libgirepository1.0-dev \
    gir1.2-gtk-3.0 \
    qtbase5-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Clone the frontend and backend repositories
RUN git clone https://github.com/smathev/pyLibre_frontend.git pylib_frontend
RUN git clone https://github.com/smathev/pyLibre_backend.git pylib_backend

# Copy the requirements files
COPY pylib_frontend/requirements.txt /app/pylib_frontend/
COPY pylib_backend/requirements.txt /app/pylib_backend/

# Upgrade pip
RUN pip install --upgrade pip

# Install the Flask app requirements
RUN pip install --no-cache-dir -r /app/pylib_frontend/requirements.txt

# Install the FastAPI app requirements
RUN pip install --no-cache-dir -r /app/pylib_backend/requirements.txt

# Expose ports for the Flask app and FastAPI app
EXPOSE 5000 8000

# Install Hypercorn
RUN pip install --no-cache-dir hypercorn

# Create a script to run both servers
RUN echo "#!/bin/bash\n\
cd /app/pylib_frontend && hypercorn app:app --bind 0.0.0.0:5000 &\n\
cd /app/pylib_backend && hypercorn main:app --bind 0.0.0.0:8000\n" > /app/start.sh

RUN chmod +x /app/start.sh

# Set the command to run the script
CMD ["/bin/bash", "/app/start.sh"]
