FROM python:3.9-slim

WORKDIR /app

# Création d'un utilisateur non-root pour la sécurité
RUN useradd -m appuser && chown -R appuser /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Changement d'utilisateur
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
