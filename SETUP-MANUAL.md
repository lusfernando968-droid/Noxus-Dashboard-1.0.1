# 🛠️ Configuração Manual do Banco de Dados

## 📋 Pré-requisitos

1. **Docker Desktop** - Baixe e instale: https://www.docker.com/products/docker-desktop/
2. **Node.js** - Versão 18+ instalada
3. **Supabase CLI** - Instale com: `npm install -g supabase`

## 🚀 Passo a Passo

### 1. Verificar Pré-requisitos
```powershell
# Verificar Docker
docker --version

# Verificar Node.js
node --version

# Verificar/Instalar Supabase CLI
supabase --version
# Se não estiver instalado:
npm install -g supabase
```

### 2. Inicializar Supabase
```powershell
# No diretório do projeto
cd "C:\Users\Windows\OneDrive\Área de Trabalho\Programas de codigo\apple-zen-crm"

# Parar instâncias anteriores (se houver)
supabase stop

# Inicializar projeto (se não estiver inicializado)
supabase init

# Iniciar Supabase local
supabase start
```

### 3. Aplicar Migrações
```powershell
# Resetar banco e aplicar todas as migrações
supabase db reset
```

### 4. Configurar Arquivo .env
Crie ou atualize o arquivo `.env` na raiz do projeto:
```env
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

### 5. Verificar Status
```powershell
# Ver status de todos os serviços
supabase status
```

Você deve ver algo como:
```
supabase local development setup is running.

         API URL: http://localhost:54321
          DB URL: postgresql://postgres:postgres@localhost:54322/postgres
      Studio URL: http://localhost:54323
    Inbucket URL: http://localhost:54324
        anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 6. Reiniciar Aplicação
```powershell
# Parar o servidor de desenvolvimento (Ctrl+C)
# Reiniciar
npm run dev
```

## 🎯 Testando a Configuração

### 1. Acessar Supabase Studio
- URL: http://localhost:54323
- Visualizar tabelas e dados de teste

### 2. Testar na Aplicação
- Acesse: http://localhost:8080
- Vá para a página de Projetos
- Teste criar um novo projeto
- Verifique se os dados aparecem

### 3. Verificar Dados de Teste
No Supabase Studio, você deve ver:
- 5 clientes de exemplo
- 3 projetos (tatuagem, piercing, design)
- 5 sessões realizadas
- 3 agendamentos futuros

## 🔧 Comandos Úteis

```powershell
# Ver logs em tempo real
supabase logs

# Parar todos os serviços
supabase stop

# Iniciar novamente
supabase start

# Resetar banco completamente
supabase db reset

# Ver apenas status
supabase status
```

## 🐛 Problemas Comuns

### Docker não está rodando
```
Erro: Cannot connect to the Docker daemon
Solução: Inicie o Docker Desktop
```

### Porta já em uso
```powershell
# Parar Supabase e tentar novamente
supabase stop
supabase start
```

### Migrações falharam
```powershell
# Resetar completamente
supabase db reset
```

### Aplicação não conecta
1. Verificar se o arquivo `.env` está correto
2. Reiniciar o servidor de desenvolvimento
3. Verificar se o Supabase está rodando: `supabase status`

## ✅ Verificação Final

Após a configuração, você deve conseguir:
- ✅ Acessar http://localhost:54323 (Supabase Studio)
- ✅ Ver dados de teste nas tabelas
- ✅ Criar novos projetos na aplicação
- ✅ Ver os dados sendo salvos no banco

## 📊 Estrutura Criada

O banco terá as seguintes tabelas principais:
- `profiles` - Perfis de usuários
- `clientes` - Clientes do estúdio
- `projetos` - Projetos dos clientes
- `projeto_sessoes` - Sessões individuais
- `projeto_fotos` - Fotos de progresso
- `projeto_referencias` - Referências e inspirações
- `projeto_anexos` - Anexos dos projetos
- `agendamentos` - Agendamentos de sessões

---

**🎉 Pronto! Seu banco de dados local está configurado e funcionando!**