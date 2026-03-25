import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home(client):
    response = client.get('/')
    assert response.status_code == 200
    data = response.get_json()
    assert data['status'] == 'running'
    assert 'message' in data

def test_health(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.get_json()['status'] == 'healthy'
```
✅ Fichier **nouveau**, ne touche à rien d'existant.

---

### Étape 3 — Ajouter `pytest` dans `requirements.txt`
Ouvrir `requirements.txt` et ajouter juste une ligne :
```
pytest