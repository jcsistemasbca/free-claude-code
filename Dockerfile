# Usar una imagen base de Python ligera y estable
FROM python:3.11-slim

# Evitar que Python escriba archivos .pyc en el disco y asegurar salida de logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar los archivos de requerimientos e instalar dependencias de Python
# (Ajustar si el repositorio usa requirements.txt, pyproject.toml o setup.py)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código de la aplicación
COPY . .

# Exponer el puerto por defecto que utiliza el proxy local
EXPOSE 8082

# Comando para iniciar la aplicación mediante Uvicorn
# Nota: Ajustar 'main:app' si el punto de entrada o la instancia de FastAPI se llama distinto
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8082"]