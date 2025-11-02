# 🚀 Guia de Deploy - Apple Zen CRM

Este guia te ajudará a fazer o deploy do Apple Zen CRM no GitHub e hospedar no Lovable.

## 📋 Pré-requisitos

- [ ] Conta no GitHub
- [ ] Conta no Lovable
- [ ] Projeto Supabase configurado
- [ ] Git instalado localmente

## 🔧 Passo 1: Preparar o Repositório Local

### 1.1 Inicializar Git (se ainda não foi feito)
```bash
cd apple-zen-crm
git init
```

### 1.2 Adicionar arquivos ao Git
```bash
git add .
git commit -m "🎉 Initial commit: Apple Zen CRM with referral network visualization"
```

## 🌐 Passo 2: Criar Repositório no GitHub

### 2.1 Via Interface Web
1. Acesse [GitHub](https://github.com)
2. Clique em "New repository"
3. Nome: `apple-zen-crm`
4. Descrição: `Sistema de CRM moderno com visualização de rede de indicações`
5. Marque como **Público** (para usar com Lovable gratuito)
6. **NÃO** inicialize com README (já temos um)
7. Clique em "Create repository"

### 2.2 Via GitHub CLI (alternativo)
```bash
# Instalar GitHub CLI se não tiver
gh repo create apple-zen-crm --public --description "Sistema de CRM moderno com visualização de rede de indicações"
```

## 🔗 Passo 3: Conectar e Fazer Push

### 3.1 Adicionar remote origin
```bash
git remote add origin https://github.com/SEU-USUARIO/apple-zen-crm.git
```

### 3.2 Fazer push inicial
```bash
git branch -M main
git push -u origin main
```

## ⚙️ Passo 4: Configurar Variáveis de Ambiente

### 4.1 No Supabase
1. Acesse seu projeto no [Supabase](https://supabase.com)
2. Vá em Settings > API
3. Copie:
   - Project URL
   - Project ID  
   - Anon/Public Key

### 4.2 Criar arquivo .env local
```bash
cp .env.example .env
```

Edite o `.env` com suas credenciais:
```env
VITE_SUPABASE_URL=https://seu-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=sua-chave-anonima
VITE_SUPABASE_PROJECT_ID=seu-project-id
```

## 🌟 Passo 5: Deploy no Lovable

### 5.1 Acessar Lovable
1. Acesse [Lovable](https://lovable.dev)
2. Faça login com sua conta

### 5.2 Conectar Repositório
1. Clique em "New Project"
2. Selecione "Import from GitHub"
3. Autorize o Lovable a acessar seus repositórios
4. Selecione `apple-zen-crm`
5. Clique em "Import"

### 5.3 Configurar Variáveis de Ambiente no Lovable
1. No projeto, vá em Settings > Environment Variables
2. Adicione as variáveis:
   ```
   VITE_SUPABASE_URL=https://seu-project-id.supabase.co
   VITE_SUPABASE_ANON_KEY=sua-chave-anonima
   VITE_SUPABASE_PROJECT_ID=seu-project-id
   ```

### 5.4 Deploy Automático
1. O Lovable fará o build automaticamente
2. Aguarde a conclusão (2-5 minutos)
3. Acesse a URL fornecida

## 🔄 Passo 6: Configurar Deploy Contínuo

### 6.1 Webhook Automático
O Lovable configura automaticamente um webhook no GitHub para deploy a cada push.

### 6.2 Testar Deploy Contínuo
```bash
# Fazer uma pequena alteração
echo "# Deploy Test" >> README.md
git add README.md
git commit -m "🧪 Test: Deploy contínuo"
git push origin main
```

## 🗄️ Passo 7: Configurar Banco de Dados

### 7.1 Executar Migrações
No painel do Supabase:
1. Vá em SQL Editor
2. Execute as migrações da pasta `supabase/migrations/`
3. Ou execute cada arquivo .sql manualmente

### 7.2 Configurar RLS (Row Level Security)
Certifique-se de que as políticas RLS estão ativas:
```sql
-- Verificar se RLS está habilitado
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

## 🧪 Passo 8: Testar Aplicação

### 8.1 Funcionalidades Básicas
- [ ] Login/Registro
- [ ] Dashboard carrega
- [ ] Criar cliente
- [ ] Visualizar rede de indicações

### 8.2 Funcionalidades Avançadas
- [ ] Sistema de indicações
- [ ] Edição inline
- [ ] Notificações
- [ ] Povoação de dados

## 🔧 Passo 9: Configurações Avançadas

### 9.1 Domínio Customizado (Opcional)
1. No Lovable, vá em Settings > Domains
2. Clique em "Connect Domain"
3. Siga as instruções para configurar DNS

### 9.2 Analytics (Opcional)
Adicionar Google Analytics ou similar:
```html
<!-- No index.html -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
```

## 🚨 Troubleshooting

### Erro: "Supabase connection failed"
- Verifique se as variáveis de ambiente estão corretas
- Confirme se o projeto Supabase está ativo
- Teste a conexão localmente primeiro

### Erro: "Build failed"
- Verifique se todas as dependências estão no package.json
- Rode `npm run build` localmente para testar
- Verifique os logs de build no Lovable

### Erro: "RLS policy violation"
- Confirme se as políticas RLS estão configuradas
- Verifique se o usuário está autenticado
- Teste as queries no SQL Editor do Supabase

## 📊 Monitoramento

### Logs de Aplicação
- Lovable: Settings > Logs
- Supabase: Logs & Analytics

### Performance
- Lighthouse no navegador
- Supabase Dashboard para queries

## 🔄 Atualizações Futuras

### Workflow Recomendado
1. Desenvolver localmente
2. Testar com `npm run build`
3. Commit e push para GitHub
4. Deploy automático no Lovable
5. Testar em produção

### Branches
```bash
# Criar branch para nova feature
git checkout -b feature/nova-funcionalidade

# Desenvolver e testar
git add .
git commit -m "✨ Add: Nova funcionalidade"

# Merge para main
git checkout main
git merge feature/nova-funcionalidade
git push origin main
```

## 🎉 Conclusão

Após seguir todos os passos, você terá:

- ✅ Código versionado no GitHub
- ✅ Deploy automático no Lovable  
- ✅ Banco de dados configurado
- ✅ Aplicação funcionando em produção
- ✅ Pipeline de CI/CD ativo

**URL da aplicação:** Será fornecida pelo Lovable após o deploy

---

💡 **Dica:** Mantenha sempre um backup das variáveis de ambiente e documente qualquer configuração especial!