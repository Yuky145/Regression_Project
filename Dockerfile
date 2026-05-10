# ──────────────────────────────────────────────────────────────
#  ML Regression Project — Docker Image
#  Linear & Logistic Regression with JAX, Pandas, and Dask
# ──────────────────────────────────────────────────────────────
FROM python:3.10-slim

LABEL maintainer="ML Regression Project"
LABEL description="Jupyter Notebook environment for ML regression with JAX, Pandas, and Dask"
LABEL version="1.0"

# Prevent Python from writing .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies required by some Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy and install Python dependencies first (better layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the notebook into the workspace
COPY ml_regression_project.ipynb .

# Expose Jupyter Notebook port
EXPOSE 8888

# Start Jupyter Notebook server
#   --ip=0.0.0.0        : listen on all interfaces (required for Docker)
#   --port=8888          : default Jupyter port
#   --no-browser         : headless mode
#   --allow-root         : run as root inside container
#   --NotebookApp.token='' : disable token authentication for easy access
#   --NotebookApp.password='' : disable password
CMD ["jupyter", "notebook", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--NotebookApp.token=''", \
     "--NotebookApp.password=''"]
