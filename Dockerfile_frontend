# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install necessary build tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libcairo2 \
    libcairo2-dev \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Clone the frontend repository
RUN git clone https://github.com/smathev/pyLibre_frontend.git pylib_frontend

# Copy the requirements file
COPY pylib_frontend/requirements.txt /app/pylib_frontend/

# Upgrade pip
RUN pip install --upgrade pip

# Install the Flask app requirements
RUN pip install --no-cache-dir -r /app/pylib_frontend/requirements.txt

# Copy the Flask app code
COPY pylib_frontend /app/pylib_frontend

# Expose port for the Flask app
EXPOSE 5000

# Install Hypercorn
RUN pip install --no-cache-dir hypercorn

# Create a script to run the server
RUN echo "#!/bin/bash\n\
cd /app/pylib_frontend && hypercorn app:app --bind 0.0.0.0:5000\n" > /app/start.sh

RUN chmod +x /app/start.sh

# Set the command to run the script
CMD ["/bin/bash", "/app/start.sh"]
