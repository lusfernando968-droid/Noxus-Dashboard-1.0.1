# Script simplificado para configurar o banco de dados local
Write-Host "🚀 Configurando banco de dados local..." -ForegroundColor Green

# Verificar se o Supabase CLI está instalado
$supabaseInstalled = $false
try {
    supabase --version > $null 2>&1
    if ($?) {
        Write-Host "✅ Supabase CLI encontrado" -ForegroundColor Green
        $supabaseInstalled = $true
    }
} catch {
    # Ignorar erro
}

if (-not $supabaseInstalled) {
    Write-Host "❌ Supabase CLI não encontrado!" -ForegroundColor Red
    Write-Host "📥 Instale o Supabase CLI manualmente:" -ForegroundColor Yellow
    Write-Host "npm install -g supabase" -ForegroundColor White
    Write-Host "Ou baixe de: https://github.com/supabase/cli/releases" -ForegroundColor White
    exit 1
}

# Verificar se o Docker está rodando
$dockerRunning = $false
try {
    docker ps > $null 2>&1
    if ($?) {
        Write-Host "✅ Docker está rodando" -ForegroundColor Green
        $dockerRunning = $true
    }
} catch {
    # Ignorar erro
}

if (-not $dockerRunning) {
    Write-Host "❌ Docker não está rodando!" -ForegroundColor Red
    Write-Host "🐳 Inicie o Docker Desktop e execute este script novamente." -ForegroundColor Yellow
    exit 1
}

# Parar qualquer instância anterior
Write-Host "🛑 Parando instâncias anteriores..." -ForegroundColor Yellow
supabase stop > $null 2>&1

# Inicializar se necessário
if (-not (Test-Path "supabase/config.toml")) {
    Write-Host "🔧 Inicializando projeto Supabase..." -ForegroundColor Yellow
    supabase init
}

# Iniciar Supabase
Write-Host "🚀 Iniciando Supabase local..." -ForegroundColor Yellow
supabase start

if ($?) {
    Write-Host "✅ Supabase iniciado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao iniciar Supabase" -ForegroundColor Red
    exit 1
}

# Aguardar inicialização
Write-Host "⏳ Aguardando inicialização..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Aplicar migrações
Write-Host "📊 Aplicando migrações..." -ForegroundColor Yellow
supabase db reset

# Criar/atualizar arquivo .env
Write-Host "📝 Configurando arquivo .env..." -ForegroundColor Yellow
$envContent = @"
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
"@

$envContent | Out-File -FilePath ".env" -Encoding UTF8
Write-Host "✅ Arquivo .env configurado!" -ForegroundColor Green

# Mostrar status
Write-Host "`n🔗 Status dos serviços:" -ForegroundColor Cyan
supabase status

Write-Host "`n🎉 Configuração concluída!" -ForegroundColor Green
Write-Host "`n📊 Acesse o Supabase Studio: http://localhost:54323" -ForegroundColor Cyan
Write-Host "🌐 API URL: http://localhost:54321" -ForegroundColor Cyan

Write-Host "`n📋 Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Reinicie o servidor (npm run dev)" -ForegroundColor White
Write-Host "2. Teste as funcionalidades na aplicação" -ForegroundColor White
Write-Host "3. Visualize os dados no Supabase Studio" -ForegroundColor White