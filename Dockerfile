FROM python:3.11-slim

# Prevenir escritura de bytecodes y asegurar logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias base del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Descargar e instalar "uv" directamente (oficial y ultra-rápido)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copiar todo el código fuente al contenedor
COPY . .

# Usar uv para instalar todas las dependencias sin fallos de compilación
RUN uv sync

EXPOSE 8082

# Ejecutar el servidor uvicorn usando el entorno nativo de uv
CMD ["uv", "run", "uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8082"]
