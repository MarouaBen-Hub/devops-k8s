from flask import Flask, render_template_string
import os

app = Flask(__name__)

HTML_PAGE = """
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>DevOps K8s App</title>
  <style>
    body { font-family: Arial, sans-serif; background: #0f172a; color: #e2e8f0; text-align: center; padding: 60px; }
    h1 { color: #38bdf8; font-size: 2.5rem; }
    .badge { background: #22c55e; color: white; padding: 6px 16px; border-radius: 20px; font-size: 0.9rem; }
    .card { background: #1e293b; border-radius: 12px; padding: 30px; max-width: 500px; margin: 40px auto; }
    .version { color: #94a3b8; margin-top: 10px; }
  </style>
</head>
<body>
print("Modification live pour démo - TEST123")
  <h1> DevOps K8s Project</h1>
  <span class="badge">✅ Running</span>
  <div class="card">
    <p><strong>Version :</strong>version</p>
    <p><strong>Environnement :</strong> Kubernetes</p>
    <p><strong>CI/CD :</strong> GitHub Actions ✅</p>
    <p class="version">Déployé automatiquement via pipeline CI/CD</p>
  </div>
</body>
</html>
"""

@app.route('/')
def home():
 version = os.getenv("APP_VERSION", " 3.0")
    return render_template_string(HTML_PAGE, version=version)

@app.route('/health')
def health():
    return {"status": "healthy"}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
