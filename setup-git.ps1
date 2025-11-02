# Script para configurar Git e fazer push inicial para GitHub
# Execute este script no PowerShell: .\setup-git.ps1

Write-Host "Configurando Git para Apple Zen CRM..." -ForegroundColor Green

# Verificar se Git esta instalado
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git nao esta instalado. Instale o Git primeiro." -ForegroundColor Red
    exit 1
}

# Verificar se ja e um repositorio Git
if (Test-Path ".git") {
    Write-Host "Repositorio Git ja existe." -ForegroundColor Yellow
} else {
    Write-Host "Inicializando repositorio Git..." -ForegroundColor Blue
    git init
}

# Configurar informacoes do usuario (se nao estiver configurado)
$userName = git config user.name
$userEmail = git config user.email

if (!$userName) {
    $inputName = Read-Host "Digite seu nome para o Git"
    git config user.name "$inputName"
}

if (!$userEmail) {
    $inputEmail = Read-Host "Digite seu email para o Git"
    git config user.email "$inputEmail"
}

# Adicionar todos os arquivos
Write-Host "Adicionando arquivos ao Git..." -ForegroundColor Blue
git add .

# Fazer commit inicial
Write-Host "Fazendo commit inicial..." -ForegroundColor Blue
$commitMessage = @"
Initial commit: Apple Zen CRM with referral network visualization

Features:
- Sistema completo de CRM
- Visualizacao de rede de indicacoes estilo Obsidian
- Dashboard avancado com analytics
- Sistema de notificacoes em tempo real
- Edicao inline de clientes
- Multiplas visualizacoes (Lista, Grid, Tabela, Rede)
- Banco temporario com localStorage
- Sistema de povoacao para testes
- Interface moderna com shadcn/ui
- Suporte a temas claro/escuro

Tech Stack:
- React 18 + TypeScript
- Vite + Tailwind CSS
- Supabase (PostgreSQL + Auth)
- Canvas API para visualizacoes
- shadcn/ui components
"@

git commit -m $commitMessage

# Solicitar URL do repositorio GitHub
Write-Host ""
Write-Host "Agora voce precisa criar um repositorio no GitHub:" -ForegroundColor Yellow
Write-Host "1. Acesse https://github.com/new" -ForegroundColor White
Write-Host "2. Nome: apple-zen-crm" -ForegroundColor White
Write-Host "3. Descricao: Sistema de CRM moderno com visualizacao de rede de indicacoes" -ForegroundColor White
Write-Host "4. Marque como PUBLICO (para Lovable gratuito)" -ForegroundColor White
Write-Host "5. NAO inicialize com README" -ForegroundColor White
Write-Host "6. Clique em Create repository" -ForegroundColor White
Write-Host ""

$repoUrl = Read-Host "Cole a URL do repositorio GitHub (ex: https://github.com/usuario/apple-zen-crm.git)"

if ($repoUrl) {
    Write-Host "Adicionando remote origin..." -ForegroundColor Blue
    git remote add origin $repoUrl
    
    Write-Host "Fazendo push para GitHub..." -ForegroundColor Blue
    git branch -M main
    git push -u origin main
    
    Write-Host ""
    Write-Host "Sucesso! Seu codigo esta no GitHub!" -ForegroundColor Green
    Write-Host "Proximos passos:" -ForegroundColor Yellow
    Write-Host "1. Acesse https://lovable.dev" -ForegroundColor White
    Write-Host "2. Clique em New Project > Import from GitHub" -ForegroundColor White
    Write-Host "3. Selecione seu repositorio apple-zen-crm" -ForegroundColor White
    Write-Host "4. Configure as variaveis de ambiente do Supabase" -ForegroundColor White
    Write-Host "5. Aguarde o deploy automatico!" -ForegroundColor White
    Write-Host ""
    Write-Host "Consulte o arquivo DEPLOY.md para instrucoes detalhadas." -ForegroundColor Cyan
} else {
    Write-Host "URL do repositorio nao fornecida. Configure manualmente:" -ForegroundColor Red
    Write-Host "git remote add origin https://github.com/usuario/apple-zen-crm.git" -ForegroundColor White
    Write-Host "git push -u origin main" -ForegroundColor White
}

Write-Host ""
Write-Host "Setup concluido!" -ForegroundColor Green