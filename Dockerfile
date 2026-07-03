FROM python:3.11-slim

# Prevenir escritura de bytecodes y asegurar logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias del sistema operativo
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar todo el código del repositorio (incluyendo pyproject.toml)
COPY . .

# Instalar la aplicación y sus dependencias de forma nativa
# Añadimos uvicorn explícitamente para garantizar que el servidor web se instale
RUN pip install --no-cache-dir . uvicorn

EXPOSE 8082

# Comando para iniciar el proxy
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8082"]
