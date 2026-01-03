$envName = "mlops_formation_v2"

Write-Host " Installation complète MLOps Formation (Version Optimisée)" -ForegroundColor Cyan
Write-Host "=" * 70

# 1. Créer environnement propre
Write-Host "`n 1. Création de l'environnement Conda..." -ForegroundColor Yellow
conda create -n $envName python=3.11 -c conda-forge -y
if ($LASTEXITCODE -ne 0) {
    Write-Host " Échec de la création de l'environnement" -ForegroundColor Red
    exit 1
}

# 2. Activer
Write-Host "`n🔧 2. Activation de l'environnement..." -ForegroundColor Yellow
conda activate $envName

# 3. Mettre à jour les outils de base
Write-Host "`n 3. Mise à jour des outils de base..." -ForegroundColor Yellow
python -m pip install --upgrade pip setuptools wheel

# 4. Installer packages Conda 
Write-Host "`n 4. Installation packages Conda de base..." -ForegroundColor Yellow
$condaPackages = @(
    # Core scientifique
    "numpy=1.26", "pandas=2.1", "scipy=1.11", "matplotlib=3.8", "seaborn=0.12",
    # ML
    "scikit-learn=1.3", "xgboost=2.0", "lightgbm=4.1",
    # Jupyter
    "jupyterlab=4.0", "ipykernel=6.29",
    # Base de données
    "sqlalchemy=2.0", "pymongo=4.5", "redis-py=5.0",
    # Utilitaires
    "black=23.9", "flake8=6.1", "pre-commit=3.5"
)

foreach ($pkg in $condaPackages) {
    Write-Host "  ➤ $pkg" -ForegroundColor Gray
    conda install -c conda-forge $pkg -y 2>&1 | Out-Null
}

# 5. Installation PIP par groupes compatibles
Write-Host "`n 5. Installation stratégique par groupes..." -ForegroundColor Yellow

# Groupe 1: Fondations avec versions compatibles
Write-Host "`n   Groupe 1: Fondations" -ForegroundColor Green
$group1 = @(
    # Gestion de version et de données
    "dvc[s3,azure,gdrive]==3.65.0",
    "dvc-data==3.17.0",
    "dvc-objects==5.2.0",
    # ORM et connecteurs
    "sqlalchemy[asyncio]==2.0.28"
)
pip install $group1

# Groupe 2: MLOps Core (versions compatibles entre elles)
Write-Host "`n   Groupe 2: MLOps Core" -ForegroundColor Green
$group2 = @(
    # MLflow avec dépendances compatibles
    "mlflow[extras]==2.14.0",  
    "gto==1.9.0",
    # Monitoring
    "great-expectations==0.18.1",
    # Orchestration moderne
    "prefect==3.6.7",
    "prefect-aws==0.3.6",
    "prefect-docker==0.3.6"
)
pip install $group2

# Groupe 3: Cloud Providers
Write-Host "`n  Groupe 3: Cloud" -ForegroundColor Green
$group3 = @(
    # AWS
    "boto3==1.34.0",
    "awscli==1.32.0",
    # Azure
    "azureml-core==1.57.0",  # Version mise à jour
    "azure-identity==1.15.0",
    # GCP
    "google-cloud-aiplatform==1.56.0",  
    "google-cloud-storage==2.16.0"
)
pip install $group3

# Groupe 4: Frameworks ML avancés
Write-Host "`n   Groupe 4: ML Avancé" -ForegroundColor Green
$group4 = @(
    "catboost==1.2.6",
    "optuna==3.6.1",
    "hydra-core==1.3.2",
    "statsmodels==0.14.1",
    "plotly==5.18.0"
)
pip install $group4

# Groupe 5: Pipelines et Orchestration alternatives
Write-Host "`n   Groupe 5: Pipelines" -ForegroundColor Green
$group5 = @(
    "kedro==0.19.0",  
    "kedro-viz==6.6.0",
   
    "dagster==1.6.12",  
    "dagster-webserver==1.6.12"
)
pip install $group5

# Groupe 6: Monitoring et Observability (sans evidently pour compatibilité)
Write-Host "`n  Groupe 6: Monitoring" -ForegroundColor Green
$group6 = @(
    "prometheus-client==0.19.0",
    "grafanalib==0.7.1",
    # Alternatives à evidently qui sont compatibles
    "deepchecks==0.18.3",
    "whylogs==1.3.9",
    "alibi-detect==0.11.2"
)
pip install $group6

# Groupe 7: UI et Dashboards
Write-Host "`n Groupe 7: UI/Dashboards" -ForegroundColor Green
$group7 = @(
    "streamlit==1.33.0",
    "streamlit-option-menu==0.3.6",
    "dash==2.15.0",
    "dash-bootstrap-components==1.5.0",
    "gradio==4.19.2"
)
pip install $group7

# Groupe 8: DevOps et Conteneurisation
Write-Host " Groupe 8: DevOps" -ForegroundColor Green
$group8 = @(
    "docker==7.1.0",
    "kubernetes==29.0.0",
    "databricks-cli==0.18.0",
    "cookiecutter==2.5.0",
    "python-dotenv==1.0.0"
)
pip install $group8

# Groupe 9: Logging et CLI
Write-Host "Groupe 9: CLI & Logging" -ForegroundColor Green
$group9 = @(
    "typer[all]==0.9.0",
    "rich==13.7.0",
    "loguru==0.7.2",
    "python-json-logger==2.0.7",
    "jupyterlab-code-formatter==1.6.0"
)
pip install $group9

# Groupe 10: API et Web
Write-Host " Groupe 10: API & Web" -ForegroundColor Green
$group10 = @(
    "fastapi==0.104.1",
    "uvicorn[standard]==0.24.0",
    "flask==3.0.0",
    "flask-sqlalchemy==3.1.1"
)
pip install $group10

# 6. Installer evidently dans un environnement virtuel séparé (à cause de pydantic v1)
Write-Host "  Note: evidently nécessite pydantic v1, incompatible avec cet environnement." -ForegroundColor Yellow
Write-Host "   Pour l'utiliser, créez un venv séparé:" -ForegroundColor Yellow
Write-Host "   python -m venv evidently_env" -ForegroundColor Gray
Write-Host "   .\evidently_env\Scripts\activate" -ForegroundColor Gray
Write-Host "   pip install evidently==0.4.8" -ForegroundColor Gray

# 7. Vérifications finales
Write-Host "`n 7. Vérification des installations..." -ForegroundColor Green

$checkPackages = @(
    @{Name="numpy"; Version="1.26"},
    @{Name="pandas"; Version="2.1"},
    @{Name="mlflow"; Version="2.14"},
    @{Name="prefect"; Version="3.6"},
    @{Name="dvc"; Version="3.65"},
    @{Name="kedro"; Version="0.19"},
    @{Name="dagster"; Version="1.6"},
    @{Name="boto3"; Version="1.34"},
    @{Name="streamlit"; Version="1.33"}
)

foreach ($pkg in $checkPackages) {
    try {
        python -c "import $($pkg.Name); print(' $($pkg.Name) v' + $($pkg.Name).__version__)"
    } catch {
        Write-Host " $($pkg.Name) non installé correctement" -ForegroundColor Red
    }
}

# 8. Créer un kernel Jupyter
Write-Host "`n📓 8. Configuration du kernel Jupyter..." -ForegroundColor Yellow
python -m ipykernel install --user --name $envName --display-name "MLOps Formation"

Write-Host "`n" + "=" * 70
Write-Host " Installation MLOps terminée avec succès !" -ForegroundColor Green
Write-Host " Commandes utiles:" -ForegroundColor Cyan
Write-Host "   Activer l'environnement: conda activate $envName"
Write-Host "   Lancer JupyterLab: jupyter lab"
Write-Host "   Vérifier mlflow: mlflow ui"
Write-Host "   Lancer Prefect: prefect server start"
Write-Host "   Tester DVC: dvc version"
Write-Host " Outils installés:" -ForegroundColor Cyan
Write-Host "   • MLFlow (Experiment Tracking)"
Write-Host "   • Prefect (Orchestration)"
Write-Host "   • DVC (Data Version Control)"
Write-Host "   • Kedro (Pipeline Framework)"
Write-Host "   • Dagster (Orchestration)"
Write-Host "   • Streamlit/Dash (Dashboards)"
Write-Host "   • Boto3/AzureML/GCP (Cloud)"
Write-Host "   • Great Expectations (Data Validation)"
Write-Host "   • Optuna (Hyperparameter Tuning)"
Write-Host " Note importante:" -ForegroundColor Yellow
Write-Host "   evidently==0.4.8 nécessite pydantic<2 et est incompatible avec cet environnement."
Write-Host "   Utilisez deepchecks, whylogs ou alibi-detect comme alternatives." -ForegroundColor Yellow