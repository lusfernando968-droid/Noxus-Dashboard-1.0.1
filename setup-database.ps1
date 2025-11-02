# Script para configurar o banco de dados local do Supabase
# Execute este script para configurar todo o ambiente de desenvolvimento

Write-Host "🚀 Configurando banco de dados local..." -ForegroundColor Green

# Verificar se o Supabase CLI está instalado
try {
    $supabaseVersion = supabase --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Supabase CLI encontrado: $supabaseVersion" -ForegroundColor Green
    } else {
        throw "Supabase CLI não encontrado"
    }
} catch {
    Write-Host "❌ Supabase CLI não encontrado!" -ForegroundColor Red
    Write-Host "📥 Instalando Supabase CLI..." -ForegroundColor Yellow
    
    # Instalar Supabase CLI via npm
    try {
        npm install -g supabase
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Supabase CLI instalado com sucesso!" -ForegroundColor Green
        } else {
            throw "Erro na instalação"
        }
    } catch {
        Write-Host "❌ Erro ao instalar Supabase CLI. Instale manualmente:" -ForegroundColor Red
        Write-Host "npm install -g supabase" -ForegroundColor Yellow
        exit 1
    }
}

# Verificar se o Docker está rodando
try {
    docker ps 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker está rodando" -ForegroundColor Green
    } else {
        throw "Docker não está rodando"
    }
} catch {
    Write-Host "❌ Docker não está rodando!" -ForegroundColor Red
    Write-Host "🐳 Inicie o Docker Desktop e execute este script novamente." -ForegroundColor Yellow
    exit 1
}

# Parar qualquer instância anterior do Supabase
Write-Host "🛑 Parando instâncias anteriores do Supabase..." -ForegroundColor Yellow
supabase stop

# Inicializar o projeto Supabase (se não estiver inicializado)
if (-not (Test-Path "supabase/config.toml")) {
    Write-Host "🔧 Inicializando projeto Supabase..." -ForegroundColor Yellow
    supabase init
}

# Iniciar o Supabase local
Write-Host "🚀 Iniciando Supabase local..." -ForegroundColor Yellow
supabase start

# Aguardar alguns segundos para o Supabase inicializar completamente
Write-Host "⏳ Aguardando inicialização completa..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Executar migrações
Write-Host "📊 Executando migrações do banco de dados..." -ForegroundColor Yellow
try {
    supabase db reset
    Write-Host "✅ Migrações executadas com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Erro ao executar migrações. Tentando aplicar manualmente..." -ForegroundColor Yellow
    supabase migration up
}

# Obter informações de conexão
Write-Host "`n🔗 Informações de conexão:" -ForegroundColor Cyan
supabase status

Write-Host "`n📋 Configuração do arquivo .env:" -ForegroundColor Cyan
Write-Host "VITE_SUPABASE_URL=http://localhost:54321" -ForegroundColor White
Write-Host "VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0" -ForegroundColor White

# Verificar se o arquivo .env existe e atualizá-lo
$envFile = ".env"
if (Test-Path $envFile) {
    Write-Host "`n📝 Atualizando arquivo .env existente..." -ForegroundColor Yellow
    $envContent = Get-Content $envFile
    $envContent = $envContent | Where-Object { $_ -notmatch "VITE_SUPABASE_URL|VITE_SUPABASE_ANON_KEY" }
    $envContent += "VITE_SUPABASE_URL=http://localhost:54321"
    $envContent += "VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
    $envContent | Set-Content $envFile
    Write-Host "✅ Arquivo .env atualizado!" -ForegroundColor Green
} else {
    Write-Host "`n📝 Criando arquivo .env..." -ForegroundColor Yellow
    @"
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
"@ | Set-Content $envFile
    Write-Host "✅ Arquivo .env criado!" -ForegroundColor Green
}

Write-Host "`n🎉 Configuração concluída!" -ForegroundColor Green
Write-Host "`n📊 Acesse o Supabase Studio em: http://localhost:54323" -ForegroundColor Cyan
Write-Host "🔑 Use as credenciais padrão para acessar o dashboard" -ForegroundColor Cyan

Write-Host "`n📋 Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Reinicie o servidor de desenvolvimento (npm run dev)" -ForegroundColor White
Write-Host "2. Acesse a aplicação e teste as funcionalidades" -ForegroundColor White
Write-Host "3. Use o Supabase Studio para visualizar os dados" -ForegroundColor White

Write-Host "`n🛠️ Comandos úteis:" -ForegroundColor Yellow
Write-Host "supabase status    - Ver status dos serviços" -ForegroundColor White
Write-Host "supabase stop      - Parar todos os serviços" -ForegroundColor White
Write-Host "supabase start     - Iniciar todos os serviços" -ForegroundColor White
Write-Host "supabase db reset  - Resetar banco e aplicar migrações" -ForegroundColor White

Write-Host "`n✨ Banco de dados configurado e pronto para testes!" -ForegroundColor Green