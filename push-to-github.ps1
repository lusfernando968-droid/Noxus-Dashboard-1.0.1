<#
.SYNOPSIS
  Script para empurrar (push) o projeto atual para um repositório GitHub.

.DESCRIPTION
  - Inicializa o repositório Git se necessário
  - Opcionalmente configura user.name e user.email
  - Faz commit das alterações com mensagem fornecida
  - Configura remote origin (adiciona ou atualiza)
  - Faz push para a branch escolhida (por padrão: main)

.PARAMETER RepoUrl
  URL do repositório remoto (ex.: https://github.com/usuario/repo.git)

.PARAMETER Branch
  Nome da branch para push (padrão: main)

.PARAMETER CommitMessage
  Mensagem do commit. Se não fornecida, usa uma mensagem padrão.

.PARAMETER UserName
  Define git config user.name (opcional)

.PARAMETER UserEmail
  Define git config user.email (opcional)

.PARAMETER Force
  Se verdadeiro, usa --force-with-lease no push

.EXAMPLE
  .\push-to-github.ps1 -RepoUrl "https://github.com/lusfernando968-droid/Noxus-Dashboard-vers-o-1.0.1-.git"

.EXAMPLE
  .\push-to-github.ps1 -RepoUrl "https://github.com/usuario/repo.git" -Branch "release/noxus-v1.0.1" -CommitMessage "release: v1.0.1" -UserName "Seu Nome" -UserEmail "seu@email.com"
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [Parameter()] [string]$RepoUrl,
  [Parameter()] [string]$Branch = "main",
  [Parameter()] [string]$CommitMessage = "feat(clientes): Enter salva nos inputs e no Select; duplo clique para editar; hover sutil por tema; toolbar oculta na visão Rede; melhorias de UX",
  [Parameter()] [string]$UserName,
  [Parameter()] [string]$UserEmail,
  [Parameter()] [switch]$Force
)

function LoadDotEnv($path) {
  $envData = @{}
  if (Test-Path $path) {
    Get-Content $path | ForEach-Object {
      $line = $_.Trim()
      if (-not [string]::IsNullOrWhiteSpace($line) -and -not $line.StartsWith('#') -and $line.Contains('=')) {
        $kv = $line.Split('=',2)
        $key = $kv[0].Trim()
        $val = $kv[1].Trim()
        $envData[$key] = $val
      }
    }
  }
  return $envData
}

function ExecGit($gitArgs) {
  & git @gitArgs
  if ($LASTEXITCODE -ne 0) {
    throw "Falha ao executar: git $($gitArgs -join ' ')"
  }
}

if (-not $RepoUrl -or [string]::IsNullOrWhiteSpace($RepoUrl)) {
  $dotEnv = LoadDotEnv ".env"
  if ($env:GITHUB_REPO_URL) { $RepoUrl = $env:GITHUB_REPO_URL }
  elseif ($dotEnv.ContainsKey('GITHUB_REPO_URL')) { $RepoUrl = $dotEnv['GITHUB_REPO_URL'] }
  elseif ((Test-Path ".git\config")) {
    try {
      $currentOrigin = & git config --get remote.origin.url 2>$null
      if ($currentOrigin) { $RepoUrl = $currentOrigin }
    } catch {}
  }
  if (-not $RepoUrl -or [string]::IsNullOrWhiteSpace($RepoUrl)) {
    $RepoUrl = "https://github.com/lusfernando968-droid/Noxus-Dashboard-vers-o-1.0.1-.git"
  }
}

Write-Host "Preparando push para $RepoUrl (branch: $Branch)" -ForegroundColor Cyan

# Verificar Git
# Tentar adicionar Git ao PATH dinamicamente se instalado no local padrão
$gitCmdPath = 'C:\Program Files\Git\cmd\git.exe'
if ((Test-Path $gitCmdPath) -and -not (Get-Command git -ErrorAction SilentlyContinue)) {
  $env:Path = "$env:Path;C:\Program Files\Git\cmd;C:\Program Files\Git\bin"
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host "Git não está instalado ou não está no PATH." -ForegroundColor Red
  Write-Host "Instale o Git e tente novamente: https://git-scm.com/downloads" -ForegroundColor Yellow
  exit 1
}

# Inicializar repositório se necessário
if (!(Test-Path ".git")) {
  Write-Host "Inicializando repositório Git..." -ForegroundColor Blue
  ExecGit @('init')
}

# Definir branch padrão
Write-Host "Definindo branch atual para '$Branch'..." -ForegroundColor Blue
ExecGit @('branch','-M', $Branch)

# Configurar user.name e user.email (se fornecidos)
if ($UserName) {
  Write-Host "Configurando user.name: $UserName" -ForegroundColor Blue
  ExecGit @('config','user.name', $UserName)
}
if ($UserEmail) {
  Write-Host "Configurando user.email: $UserEmail" -ForegroundColor Blue
  ExecGit @('config','user.email', $UserEmail)
}

# Adicionar e commitar
Write-Host "Adicionando alterações..." -ForegroundColor Blue
ExecGit @('add','-A')

Write-Host "Fazendo commit..." -ForegroundColor Blue
try {
  & git commit -m $CommitMessage
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Nenhuma alteração para commitar ou commit falhou." -ForegroundColor Yellow
  }
} catch {
  Write-Host "Commit não executado: $_" -ForegroundColor Yellow
}

# Configurar remote origin
$hasOrigin = (& git remote 2>$null) -contains 'origin'
if ($hasOrigin) {
  Write-Host "Atualizando remote origin..." -ForegroundColor Blue
  ExecGit @('remote','set-url','origin', $RepoUrl)
} else {
  Write-Host "Adicionando remote origin..." -ForegroundColor Blue
  ExecGit @('remote','add','origin', $RepoUrl)
}

# Preparar credenciais opcionais via .env/ambiente
$dotEnvPush = LoadDotEnv ".env"
$ghUser = $env:GITHUB_USER
$ghToken = $env:GITHUB_TOKEN
if (-not $ghUser) { if ($dotEnvPush.ContainsKey('GITHUB_USER')) { $ghUser = $dotEnvPush['GITHUB_USER'] } }
if (-not $ghToken) { if ($dotEnvPush.ContainsKey('GITHUB_TOKEN')) { $ghToken = $dotEnvPush['GITHUB_TOKEN'] } }

# Push (primeira tentativa: via origin)
Write-Host "Enviando para $RepoUrl ($Branch) ..." -ForegroundColor Blue
try {
  if ($Force) {
    ExecGit @('push','-u','origin', $Branch, '--force-with-lease')
  } else {
    ExecGit @('push','-u','origin', $Branch)
  }
} catch {
  # Fallback com token embedado (não persiste no remote)
  if ($ghUser -and $ghToken) {
    $repoAuth = $RepoUrl
    if ($RepoUrl.StartsWith('https://github.com/')) {
      $repoAuth = $RepoUrl.Replace('https://github.com/', "https://${ghUser}:${ghToken}@github.com/")
    }
    Write-Host "Tentando push com credenciais de .env (sem guardar no remote)..." -ForegroundColor Yellow
    if ($Force) {
      & git push $repoAuth $Branch --force-with-lease
    } else {
      & git push $repoAuth $Branch
    }
    if ($LASTEXITCODE -ne 0) {
      throw "Falha ao executar push autenticado via URL. Verifique token e permissões."
    }
  } else {
    throw "Push falhou e não há credenciais GITHUB_USER/GITHUB_TOKEN configuradas. Configure e tente novamente."
  }
}

Write-Host "Push concluído com sucesso!" -ForegroundColor Green