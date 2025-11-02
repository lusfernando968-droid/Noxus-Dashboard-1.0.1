# 🗄️ Banco de Dados - Apple Zen CRM

## 📋 Visão Geral

Este documento descreve a estrutura do banco de dados do Apple Zen CRM, incluindo todas as tabelas, relacionamentos e como configurar o ambiente local para testes.

## 🚀 Configuração Rápida

### Pré-requisitos
- Docker Desktop instalado e rodando
- Node.js e npm instalados
- PowerShell (Windows)

### Configuração Automática
```powershell
# Execute o script de configuração
.\setup-database.ps1
```

Este script irá:
- ✅ Instalar Supabase CLI (se necessário)
- ✅ Inicializar o projeto Supabase
- ✅ Executar todas as migrações
- ✅ Popular com dados de teste
- ✅ Configurar arquivo .env
- ✅ Fornecer URLs de acesso

## 📊 Estrutura do Banco

### 👥 Tabelas Principais

#### `profiles`
Perfis dos usuários do sistema
```sql
- id (UUID, PK) - Referência ao auth.users
- nome_completo (TEXT)
- avatar_url (TEXT)
- telefone (TEXT)
- cargo (TEXT)
- created_at, updated_at (TIMESTAMP)
```

#### `user_roles`
Roles/permissões dos usuários
```sql
- id (UUID, PK)
- user_id (UUID, FK → auth.users)
- role (app_role ENUM: admin, manager, user)
```

#### `clientes`
Clientes do estúdio
```sql
- id (UUID, PK)
- user_id (UUID, FK → auth.users)
- nome (TEXT)
- email (TEXT)
- telefone (TEXT)
- documento (TEXT)
- endereco (TEXT)
- indicado_por (UUID, FK → clientes.id)
- created_at, updated_at (TIMESTAMP)
```

#### `projetos`
Projetos dos clientes
```sql
- id (UUID, PK)
- user_id (UUID, FK → auth.users)
- cliente_id (UUID, FK → clientes.id)
- titulo (TEXT)
- descricao (TEXT)
- status (TEXT: planejamento, andamento, concluido, cancelado)
- valor_total (DECIMAL)
- valor_por_sessao (DECIMAL)
- quantidade_sessoes (INTEGER)
- data_inicio, data_fim (DATE)
- categoria (TEXT)
- notas (TEXT)
- conclusao_final (TEXT)
- created_at, updated_at (TIMESTAMP)
```

### 🔗 Tabelas Relacionadas

#### `projeto_sessoes`
Sessões individuais dos projetos
```sql
- id (UUID, PK)
- projeto_id (UUID, FK → projetos.id)
- agendamento_id (UUID, FK → agendamentos.id)
- numero_sessao (INTEGER)
- data_sessao (DATE)
- valor_sessao (DECIMAL)
- status_pagamento (TEXT: pendente, pago, cancelado)
- metodo_pagamento (TEXT)
- feedback_cliente (TEXT)
- observacoes_tecnicas (TEXT)
- avaliacao (INTEGER 1-5)
- created_at, updated_at (TIMESTAMP)
```

#### `projeto_fotos`
Fotos de progresso dos projetos
```sql
- id (UUID, PK)
- projeto_id (UUID, FK → projetos.id)
- sessao_id (UUID, FK → projeto_sessoes.id)
- url_foto (TEXT)
- descricao (TEXT)
- tipo (TEXT: antes, durante, depois, referencia, progresso)
- data_upload (TIMESTAMP)
```

#### `projeto_referencias`
Referências e inspirações dos projetos
```sql
- id (UUID, PK)
- projeto_id (UUID, FK → projetos.id)
- titulo (TEXT)
- url (TEXT)
- descricao (TEXT)
- created_at (TIMESTAMP)
```

#### `projeto_anexos`
Anexos dos projetos
```sql
- id (UUID, PK)
- projeto_id (UUID, FK → projetos.id)
- nome (TEXT)
- url (TEXT)
- tipo (TEXT)
- tamanho (INTEGER)
- created_at (TIMESTAMP)
```

#### `agendamentos`
Agendamentos de sessões
```sql
- id (UUID, PK)
- user_id (UUID, FK → auth.users)
- projeto_id (UUID, FK → projetos.id)
- titulo (TEXT)
- descricao (TEXT)
- data (DATE)
- hora (TIME)
- status (TEXT: agendado, confirmado, em_andamento, concluido, cancelado)
- created_at, updated_at (TIMESTAMP)
```

## 🔐 Segurança (RLS)

Todas as tabelas implementam Row Level Security (RLS):

- ✅ **Isolamento por usuário**: Cada usuário só vê seus próprios dados
- ✅ **Políticas granulares**: SELECT, INSERT, UPDATE, DELETE específicos
- ✅ **Relacionamentos seguros**: Verificação de propriedade em tabelas relacionadas

## 🧮 Funções Utilitárias

### `calcular_progresso_projeto(projeto_id)`
Calcula o progresso do projeto baseado nas sessões realizadas
```sql
SELECT public.calcular_progresso_projeto('projeto-uuid');
-- Retorna: INTEGER (0-100)
```

### `calcular_valor_pago_projeto(projeto_id)`
Calcula o valor total pago do projeto
```sql
SELECT public.calcular_valor_pago_projeto('projeto-uuid');
-- Retorna: DECIMAL(10,2)
```

## 📊 Dados de Teste

O banco é populado automaticamente com:
- 👥 **5 clientes** de exemplo
- 🎨 **3 projetos** (tatuagem, piercing, design)
- 📅 **5 sessões** realizadas
- 🗓️ **3 agendamentos** futuros
- 🔗 **3 referências** de projeto

### Usuário de Teste
```
User ID: 00000000-0000-0000-0000-000000000001
```

## 🌐 URLs de Acesso

Após executar o setup:

- **Aplicação**: http://localhost:8080
- **Supabase Studio**: http://localhost:54323
- **API**: http://localhost:54321

## 🛠️ Comandos Úteis

```powershell
# Ver status dos serviços
supabase status

# Parar todos os serviços
supabase stop

# Iniciar todos os serviços
supabase start

# Resetar banco e aplicar migrações
supabase db reset

# Ver logs em tempo real
supabase logs

# Gerar tipos TypeScript
supabase gen types typescript --local > src/types/database.types.ts
```

## 🔄 Migrações

### Aplicar nova migração
```powershell
# Criar nova migração
supabase migration new nome_da_migracao

# Aplicar migrações
supabase migration up
```

### Histórico de Migrações
1. `20251027111534` - Estrutura inicial (profiles, roles)
2. `20251028055919` - Clientes, projetos, agendamentos
3. `20251029093914` - Estoque e produtos
4. `20251029094110` - Transações financeiras
5. `20251029104139` - Metas e objetivos
6. `20251230000000` - Campo indicado_por em clientes
7. `20250103000000` - Campos financeiros e estrutura completa de projetos
8. `20250103000001` - Dados de teste

## 🐛 Troubleshooting

### Problema: Docker não está rodando
```
Solução: Inicie o Docker Desktop
```

### Problema: Porta já em uso
```powershell
# Parar Supabase e reiniciar
supabase stop
supabase start
```

### Problema: Migrações falharam
```powershell
# Resetar completamente
supabase db reset
```

### Problema: Dados de teste não aparecem
```sql
-- Verificar se existem dados
SELECT COUNT(*) FROM public.clientes;
SELECT COUNT(*) FROM public.projetos;
```

## 📈 Performance

### Índices Criados
- `idx_projeto_referencias_projeto_id`
- `idx_projeto_anexos_projeto_id`
- `idx_projeto_sessoes_projeto_id`
- `idx_projeto_sessoes_agendamento_id`
- `idx_projeto_fotos_projeto_id`
- `idx_projeto_fotos_sessao_id`

## 🔮 Próximos Passos

- [ ] Implementar backup automático
- [ ] Adicionar métricas de performance
- [ ] Criar views para relatórios
- [ ] Implementar cache de consultas frequentes
- [ ] Adicionar triggers para auditoria

---

**✨ Banco de dados configurado e pronto para desenvolvimento!**