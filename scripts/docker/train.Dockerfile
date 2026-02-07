FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

# 1. Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 2. Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.12 python3.12-dev git ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 3. Set Environment Variables (The Segfault Blockers)
ENV ARROW_DEFAULT_MEMORY_POOL=system \
    XLA_PYTHON_CLIENT_PREALLOCATE=false \
    OMP_NUM_THREADS=1 \
    UV_SYSTEM_PYTHON=1 \
    UV_COMPILE_BYTECODE=1

WORKDIR /app

# 4. Use uv to sync dependencies
# We copy only the lockfile first to utilize Docker layer caching
COPY pyproject.toml uv.lock ./
RUN uv pip install --no-cache jax[cuda12] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
RUN uv pip install --no-cache torch torchvision --index-url https://download.pytorch.org/whl/cu124
RUN uv sync --no-cache