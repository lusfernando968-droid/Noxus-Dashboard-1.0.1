# Script simples para configurar Git
# Execute: .\setup-simple.ps1

Write-Host "=== APPLE ZEN CRM - SETUP GIT ===" -ForegroundColor Green
Write-Host ""

# Verificar Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERRO: Git nao encontrado. Instale o Git primeiro." -ForegroundColor Red
    Write-Host "Download: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host "Git encontrado!" -ForegroundColor Green

# Inicializar repositorio
if (!(Test-Path ".git")) {
    Write-Host "Inicializando repositorio Git..." -ForegroundColor Blue
    git init
} else {
    Write-Host "Repositorio Git ja existe." -ForegroundColor Yellow
}

# Configurar usuario
$userName = git config user.name
$userEmail = git config user.email

if (!$userName) {
    $name = Read-Host "Digite seu nome"
    git config user.name "$name"
}

if (!$userEmail) {
    $email = Read-Host "Digite seu email"
    git config user.email "$email"
}

# Adicionar arquivos
Write-Host "Adicionando arquivos..." -ForegroundColor Blue
git add .

# Commit
Write-Host "Fazendo commit..." -ForegroundColor Blue
git commit -m "Initial commit: Apple Zen CRM"

Write-Host ""
Write-Host "=== PROXIMOS PASSOS ===" -ForegroundColor Yellow
Write-Host "1. Crie um repositorio no GitHub:"
Write-Host "   - Acesse: https://github.com/new"
Write-Host "   - Nome: apple-zen-crm"
Write-Host "   - Publico: SIM"
Write-Host "   - README: NAO"
Write-Host ""
Write-Host "2. Execute os comandos:"
Write-Host "   git remote add origin https://github.com/SEU-USUARIO/apple-zen-crm.git"
Write-Host "   git branch -M main"
Write-Host "   git push -u origin main"
Write-Host ""
Write-Host "3. Deploy no Lovable:"
Write-Host "   - Acesse: https://lovable.dev"
Write-Host "   - New Project > Import from GitHub"
Write-Host "   - Selecione: apple-zen-crm"
Write-Host ""
Write-Host "=== SETUP CONCLUIDO ===" -ForegroundColor Green