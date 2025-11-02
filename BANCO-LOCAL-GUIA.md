# 🏠 Banco de Dados Local - Guia Completo

## ✅ CONFIGURAÇÃO CONCLUÍDA!

O sistema agora está configurado para usar um banco de dados local baseado em **localStorage** do navegador, eliminando a necessidade do Docker ou Supabase para desenvolvimento.

## 🚀 Como Usar

### 1. Iniciar a Aplicação
```bash
npm run dev
```

### 2. Acessar o Dashboard
- URL: http://localhost:8080
- O banco local será inicializado automaticamente com dados de exemplo

### 3. Gerenciar o Banco Local
- Acesse a aba **"Banco Local"** no dashboard
- Visualize estatísticas em tempo real
- Exporte/importe dados
- Limpe ou reinicialize dados

## 📊 Funcionalidades Implementadas

### 🗄️ Estrutura de Dados
- ✅ **Clientes** - Gestão completa de clientes
- ✅ **Projetos** - Com campos financeiros e de sessões
- ✅ **Sessões** - Tracking de progresso e pagamentos
- ✅ **Referências** - Links e inspirações
- ✅ **Anexos** - Arquivos dos projetos
- ✅ **Agendamentos** - Sistema de agendamento

### 💰 Sistema Financeiro
- ✅ **Valor total** do projeto
- ✅ **Valor por sessão**
- ✅ **Status de pagamento** (pendente, pago, cancelado)
- ✅ **Métodos de pagamento** (PIX, cartão, dinheiro)
- ✅ **Cálculos automáticos** de valores pagos

### 📈 Sistema de Progresso
- ✅ **Quantidade de sessões** planejadas vs realizadas
- ✅ **Cálculo automático** de progresso (%)
- ✅ **Timeline** de sessões
- ✅ **Feedback** por sessão

### 🔧 Ferramentas de Desenvolvimento
- ✅ **Gerenciador visual** no dashboard
- ✅ **Exportar/importar** dados JSON
- ✅ **Backup automático** via download
- ✅ **Reinicialização** com dados de exemplo
- ✅ **Limpeza** completa de dados

## 📋 Dados de Exemplo Incluídos

### 👥 Clientes (3)
- João Silva - Tatuagem em andamento
- Maria Santos - Piercing concluído  
- Pedro Oliveira - Design em planejamento

### 🎨 Projetos (3)
- **Tatuagem Dragão Oriental** - R$ 2.500 (5 sessões)
- **Piercing Helix Duplo** - R$ 300 (2 sessões)
- **Design Logo Estúdio** - R$ 1.800 (6 sessões)

### 📅 Sessões (4)
- 3 sessões da tatuagem (2 pagas)
- 2 sessões do piercing (ambas pagas)

### 🔗 Referências (2)
- Links para inspirações dos projetos

### 📆 Agendamentos (2)
- Próximas sessões agendadas

## 🎯 Como Testar

### 1. Página de Projetos
```
http://localhost:8080/projetos
```
- ✅ Ver projetos existentes
- ✅ Criar novo projeto com todos os campos
- ✅ Editar projetos existentes
- ✅ Ver estatísticas calculadas

### 2. Página de Clientes
```
http://localhost:8080/clientes
```
- ✅ Ver clientes existentes
- ✅ Criar novos clientes
- ✅ Editar informações

### 3. Página de Agendamentos
```
http://localhost:8080/agendamentos
```
- ✅ Ver agendamentos existentes
- ✅ Criar novos agendamentos
- ✅ Vincular com projetos

### 4. Dashboard Principal
```
http://localhost:8080
```
- ✅ Ver estatísticas gerais
- ✅ Acessar aba "Banco Local"
- ✅ Gerenciar dados

## 🔧 Gerenciador de Banco Local

### Localização
Dashboard → Aba "Banco Local"

### Funcionalidades

#### 📊 Estatísticas em Tempo Real
- Contadores de registros por tabela
- Valores financeiros totais
- Progresso dos projetos

#### 💾 Backup e Restore
- **Exportar**: Baixa arquivo JSON com todos os dados
- **Importar**: Restaura dados de arquivo JSON
- **Ver Dados**: Visualiza estrutura JSON atual

#### 🔄 Gerenciamento
- **Atualizar**: Recarrega estatísticas
- **Dados Exemplo**: Reinicializa com dados de teste
- **Limpar Tudo**: Remove todos os dados (⚠️ irreversível)

## 🔄 Alternância Entre Bancos

### Usar Banco Local (Atual)
```env
VITE_USE_LOCAL_DB=true
```

### Usar Supabase Cloud
```env
VITE_USE_LOCAL_DB=false
```

## 📁 Estrutura de Arquivos

### Banco Local
```
src/lib/database/
├── localDatabase.ts      # Implementação do banco local
└── databaseAdapter.ts    # Adapter que simula Supabase
```

### Componentes
```
src/components/debug/
└── LocalDatabaseManager.tsx  # Interface de gerenciamento
```

### Configuração
```
.env                      # Configuração de ambiente
src/integrations/supabase/client.ts  # Cliente adaptado
```

## 🛠️ Comandos Úteis

### Desenvolvimento
```bash
# Iniciar servidor
npm run dev

# Limpar cache do navegador
Ctrl + Shift + R (ou F12 → Application → Storage → Clear)
```

### Backup Manual
```javascript
// No console do navegador
const data = await localDatabaseUtils.exportarDados();
console.log(data); // Copiar e salvar
```

### Importar Dados
```javascript
// No console do navegador
const jsonData = '...'; // Colar dados JSON
await localDatabaseUtils.importarDados(jsonData);
```

## 🔍 Debug e Troubleshooting

### Verificar Dados no Console
```javascript
// Ver todos os clientes
await localDB.getClientes()

// Ver todos os projetos  
await localDB.getProjetos()

// Ver estatísticas
await localDatabaseUtils.obterEstatisticasProjetos()
```

### Limpar Cache
1. F12 → Application → Storage → Local Storage
2. Deletar entradas que começam com `apple_zen_crm_`
3. Recarregar página

### Problemas Comuns

#### Dados não aparecem
- Verifique se `VITE_USE_LOCAL_DB=true` no .env
- Reinicie o servidor de desenvolvimento
- Limpe o cache do navegador

#### Erro ao salvar
- Verifique o console do navegador
- Teste no gerenciador de banco local
- Reinicialize com dados de exemplo

## 🎉 Vantagens do Banco Local

### ✅ Desenvolvimento
- **Sem dependências** externas
- **Dados persistem** entre sessões
- **Controle total** sobre os dados
- **Backup fácil** via JSON

### ✅ Performance
- **Acesso instantâneo** (localStorage)
- **Sem latência** de rede
- **Funciona offline**

### ✅ Flexibilidade
- **Fácil reset** para testes
- **Dados de exemplo** incluídos
- **Migração simples** para Supabase

## 🚀 Próximos Passos

1. **Teste todas as funcionalidades** na aplicação
2. **Crie novos projetos** com dados reais
3. **Experimente** o sistema de sessões
4. **Use o gerenciador** para backup/restore
5. **Desenvolva novas features** com confiança

---

**🎉 Seu banco de dados local está pronto e funcionando!**

**✨ Agora você pode desenvolver e testar todas as funcionalidades sem depender de serviços externos!** 🏠💾