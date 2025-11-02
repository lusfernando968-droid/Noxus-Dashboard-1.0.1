# 🚀 Configuração Sem Docker - Banco de Dados Local

## 📋 Situação Atual

O Docker não está instalado/rodando, mas podemos configurar o banco de dados de forma alternativa para testes.

## 🎯 Opção 1: Usar Supabase Cloud (Recomendado)

### 1. Criar Conta no Supabase
1. Acesse: https://supabase.com
2. Clique em "Start your project"
3. Faça login com GitHub ou crie uma conta

### 2. Criar Novo Projeto
1. Clique em "New Project"
2. Escolha uma organização
3. Nome do projeto: `apple-zen-crm-dev`
4. Senha do banco: `sua-senha-segura`
5. Região: `South America (São Paulo)`
6. Clique em "Create new project"

### 3. Obter Credenciais
Após criar o projeto, vá em Settings > API:
- **Project URL**: `https://seu-projeto.supabase.co`
- **Anon Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

### 4. Configurar .env
Crie/atualize o arquivo `.env`:
```env
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sua-anon-key-aqui
```

### 5. Aplicar Migrações
No SQL Editor do Supabase (https://supabase.com/dashboard/project/seu-projeto/sql):

1. **Execute a migração principal:**
```sql
-- Cole o conteúdo do arquivo: supabase/migrations/20250103000000_add_project_financial_fields.sql
```

2. **Execute os dados de teste:**
```sql
-- Cole o conteúdo do arquivo: supabase/migrations/20250103000001_seed_test_data.sql
```

## 🎯 Opção 2: Instalar Docker Desktop

### 1. Baixar Docker Desktop
- Acesse: https://www.docker.com/products/docker-desktop/
- Baixe para Windows
- Execute o instalador
- Reinicie o computador se necessário

### 2. Iniciar Docker Desktop
- Abra o Docker Desktop
- Aguarde inicializar completamente
- Verifique se está rodando (ícone na bandeja do sistema)

### 3. Configurar Supabase Local
```powershell
# Iniciar Supabase
npx supabase start

# Aplicar migrações
npx supabase db reset

# Ver status
npx supabase status
```

### 4. Configurar .env Local
```env
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

## 🎯 Opção 3: Usar JSON Local (Temporário)

### 1. Modificar o Código para Usar JSON
Crie um arquivo `src/data/mock-data.json`:
```json
{
  "clientes": [
    {
      "id": "1",
      "nome": "João Silva",
      "email": "joao@email.com",
      "telefone": "(11) 99999-1111"
    },
    {
      "id": "2", 
      "nome": "Maria Santos",
      "email": "maria@email.com",
      "telefone": "(11) 99999-2222"
    }
  ],
  "projetos": [
    {
      "id": "1",
      "cliente_id": "1",
      "titulo": "Tatuagem Dragão",
      "descricao": "Tatuagem de dragão oriental",
      "status": "andamento",
      "valor_total": 2500,
      "valor_por_sessao": 500,
      "quantidade_sessoes": 5,
      "categoria": "tatuagem"
    }
  ]
}
```

### 2. Criar Hook para Dados Mock
Crie `src/hooks/useMockData.ts`:
```typescript
import { useState, useEffect } from 'react';
import mockData from '../data/mock-data.json';

export function useMockData() {
  const [data, setData] = useState(mockData);
  
  const addProject = (project: any) => {
    setData(prev => ({
      ...prev,
      projetos: [...prev.projetos, { ...project, id: Date.now().toString() }]
    }));
  };
  
  return { data, addProject };
}
```

## 📋 Recomendação

**Para desenvolvimento e testes completos, recomendo a Opção 1 (Supabase Cloud):**

✅ **Vantagens:**
- Configuração rápida (5 minutos)
- Todas as funcionalidades disponíveis
- Interface web para visualizar dados
- Não requer Docker
- Gratuito para desenvolvimento

❌ **Desvantagens:**
- Requer internet
- Dados na nuvem (não local)

## 🚀 Próximos Passos

1. **Escolha uma opção** acima
2. **Configure as credenciais** no arquivo .env
3. **Reinicie o servidor** de desenvolvimento
4. **Teste as funcionalidades** na aplicação

## 🛠️ Comandos Úteis

```powershell
# Verificar se o Docker está rodando
docker --version

# Usar Supabase via npx (não precisa instalar globalmente)
npx supabase --version
npx supabase start
npx supabase status
npx supabase stop

# Reiniciar servidor de desenvolvimento
npm run dev
```

## 📞 Suporte

Se precisar de ajuda:
1. Verifique se o arquivo `.env` está correto
2. Reinicie o servidor de desenvolvimento
3. Verifique o console do navegador para erros
4. Teste a conexão no Supabase Dashboard

---

**🎉 Escolha a opção que preferir e vamos configurar o banco de dados para testes!**