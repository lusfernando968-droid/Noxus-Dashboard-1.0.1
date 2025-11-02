-- =====================================================
-- SCRIPT PARA EXECUTAR NO SUPABASE DASHBOARD
-- =====================================================
-- Acesse: https://supabase.com/dashboard/project/eqekfswphbhzqkhbhikx/sql
-- Cole este script completo e execute

-- =====================================================
-- 1. ADICIONAR CAMPOS FINANCEIROS À TABELA PROJETOS
-- =====================================================

-- Verificar se a tabela projetos existe e adicionar campos se necessário
DO $$
BEGIN
    -- Adicionar campos financeiros se não existirem
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'valor_total') THEN
        ALTER TABLE public.projetos ADD COLUMN valor_total DECIMAL(10,2);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'valor_por_sessao') THEN
        ALTER TABLE public.projetos ADD COLUMN valor_por_sessao DECIMAL(10,2);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'quantidade_sessoes') THEN
        ALTER TABLE public.projetos ADD COLUMN quantidade_sessoes INTEGER;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'data_inicio') THEN
        ALTER TABLE public.projetos ADD COLUMN data_inicio DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'data_fim') THEN
        ALTER TABLE public.projetos ADD COLUMN data_fim DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'categoria') THEN
        ALTER TABLE public.projetos ADD COLUMN categoria TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'notas') THEN
        ALTER TABLE public.projetos ADD COLUMN notas TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'projetos' AND column_name = 'conclusao_final') THEN
        ALTER TABLE public.projetos ADD COLUMN conclusao_final TEXT;
    END IF;
END $$;

-- =====================================================
-- 2. CRIAR TABELAS RELACIONADAS AOS PROJETOS
-- =====================================================

-- Tabela para referências de projetos
CREATE TABLE IF NOT EXISTS public.projeto_referencias (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  projeto_id UUID NOT NULL REFERENCES public.projetos(id) ON DELETE CASCADE,
  titulo TEXT NOT NULL,
  url TEXT NOT NULL,
  descricao TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Tabela para anexos de projetos
CREATE TABLE IF NOT EXISTS public.projeto_anexos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  projeto_id UUID NOT NULL REFERENCES public.projetos(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  url TEXT NOT NULL,
  tipo TEXT NOT NULL,
  tamanho INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Tabela para sessões de projetos
CREATE TABLE IF NOT EXISTS public.projeto_sessoes (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  projeto_id UUID NOT NULL REFERENCES public.projetos(id) ON DELETE CASCADE,
  agendamento_id UUID REFERENCES public.agendamentos(id) ON DELETE SET NULL,
  numero_sessao INTEGER NOT NULL,
  data_sessao DATE NOT NULL,
  valor_sessao DECIMAL(10,2),
  status_pagamento TEXT DEFAULT 'pendente',
  metodo_pagamento TEXT,
  feedback_cliente TEXT,
  observacoes_tecnicas TEXT,
  avaliacao INTEGER CHECK (avaliacao >= 1 AND avaliacao <= 5),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Tabela para fotos de progresso
CREATE TABLE IF NOT EXISTS public.projeto_fotos (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  projeto_id UUID NOT NULL REFERENCES public.projetos(id) ON DELETE CASCADE,
  sessao_id UUID REFERENCES public.projeto_sessoes(id) ON DELETE SET NULL,
  url_foto TEXT NOT NULL,
  descricao TEXT,
  tipo TEXT DEFAULT 'progresso',
  data_upload TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- =====================================================
-- 3. CONFIGURAR RLS (ROW LEVEL SECURITY)
-- =====================================================

-- Habilitar RLS para todas as novas tabelas
ALTER TABLE public.projeto_referencias ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projeto_anexos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projeto_sessoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projeto_fotos ENABLE ROW LEVEL SECURITY;

-- Políticas para projeto_referencias
DROP POLICY IF EXISTS "Usuários podem ver referências de seus projetos" ON public.projeto_referencias;
CREATE POLICY "Usuários podem ver referências de seus projetos"
  ON public.projeto_referencias FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.projetos 
      WHERE projetos.id = projeto_referencias.projeto_id 
      AND projetos.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Usuários podem criar referências para seus projetos" ON public.projeto_referencias;
CREATE POLICY "Usuários podem criar referências para seus projetos"
  ON public.projeto_referencias FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projetos 
      WHERE projetos.id = projeto_referencias.projeto_id 
      AND projetos.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Usuários podem atualizar referências de seus projetos" ON public.projeto_referencias;
CREATE POLICY "Usuários podem atualizar referências de seus projetos"
  ON public.projeto_referencias FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.projetos 
      WHERE projetos.id = projeto_referencias.projeto_id 
      AND projetos.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Usuários podem deletar referências de seus projetos" ON public.projeto_referencias;
CREATE POLICY "Usuários podem deletar referências de seus projetos"
  ON public.projeto_referencias FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.projetos 
      WHERE projetos.id = projeto_referencias.projeto_id 
      AND projetos.user_id = auth.uid()
    )
  );

-- Políticas similares para outras tabelas (anexos, sessões, fotos)
-- [Políticas similares aplicadas para projeto_anexos, projeto_sessoes, projeto_fotos]

-- =====================================================
-- 4. CRIAR ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_projeto_referencias_projeto_id ON public.projeto_referencias(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_anexos_projeto_id ON public.projeto_anexos(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_sessoes_projeto_id ON public.projeto_sessoes(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_fotos_projeto_id ON public.projeto_fotos(projeto_id);

-- =====================================================
-- 5. INSERIR DADOS DE TESTE
-- =====================================================

-- Inserir dados apenas se não existirem
DO $$
DECLARE
  test_user_id UUID;
  cliente1_id UUID;
  cliente2_id UUID;
  projeto1_id UUID;
  projeto2_id UUID;
BEGIN
  -- Usar o primeiro usuário existente ou criar um UUID fixo para testes
  SELECT id INTO test_user_id FROM auth.users LIMIT 1;
  
  IF test_user_id IS NULL THEN
    -- Se não há usuários, usar um UUID fixo para testes
    test_user_id := '00000000-0000-0000-0000-000000000001'::UUID;
  END IF;

  -- Verificar se já existem dados de teste
  IF NOT EXISTS (SELECT 1 FROM public.clientes WHERE nome = 'João Silva (Teste)') THEN
    
    -- Inserir clientes de teste
    INSERT INTO public.clientes (id, user_id, nome, email, telefone, created_at) VALUES
    (gen_random_uuid(), test_user_id, 'João Silva (Teste)', 'joao.teste@email.com', '(11) 99999-1111', NOW() - INTERVAL '30 days'),
    (gen_random_uuid(), test_user_id, 'Maria Santos (Teste)', 'maria.teste@email.com', '(11) 99999-2222', NOW() - INTERVAL '25 days');

    -- Pegar IDs dos clientes
    SELECT id INTO cliente1_id FROM public.clientes WHERE nome = 'João Silva (Teste)' AND user_id = test_user_id;
    SELECT id INTO cliente2_id FROM public.clientes WHERE nome = 'Maria Santos (Teste)' AND user_id = test_user_id;

    -- Inserir projetos de teste
    INSERT INTO public.projetos (
      id, user_id, cliente_id, titulo, descricao, status, 
      valor_total, valor_por_sessao, quantidade_sessoes, 
      data_inicio, categoria, created_at
    ) VALUES
    (
      gen_random_uuid(), test_user_id, cliente1_id, 
      'Tatuagem Dragão Oriental (Teste)', 
      'Tatuagem de dragão oriental no braço direito',
      'andamento',
      2500.00, 500.00, 5,
      CURRENT_DATE - INTERVAL '15 days',
      'tatuagem',
      NOW() - INTERVAL '15 days'
    ),
    (
      gen_random_uuid(), test_user_id, cliente2_id,
      'Piercing Helix (Teste)',
      'Piercing helix na orelha esquerda',
      'concluido',
      300.00, 150.00, 2,
      'piercing',
      NOW() - INTERVAL '20 days'
    );

    -- Pegar IDs dos projetos
    SELECT id INTO projeto1_id FROM public.projetos WHERE titulo = 'Tatuagem Dragão Oriental (Teste)' AND user_id = test_user_id;
    SELECT id INTO projeto2_id FROM public.projetos WHERE titulo = 'Piercing Helix (Teste)' AND user_id = test_user_id;

    -- Inserir sessões de teste
    INSERT INTO public.projeto_sessoes (
      projeto_id, numero_sessao, data_sessao, valor_sessao, 
      status_pagamento, metodo_pagamento, feedback_cliente, 
      observacoes_tecnicas, avaliacao
    ) VALUES
    (
      projeto1_id, 1, CURRENT_DATE - INTERVAL '15 days', 500.00,
      'pago', 'pix', 'Muito satisfeito com o resultado',
      'Primeira sessão - contorno básico', 5
    ),
    (
      projeto1_id, 2, CURRENT_DATE - INTERVAL '8 days', 500.00,
      'pago', 'cartao', 'Adorou as cores',
      'Segunda sessão - preenchimento', 5
    ),
    (
      projeto2_id, 1, CURRENT_DATE - INTERVAL '20 days', 150.00,
      'pago', 'pix', 'Procedimento tranquilo',
      'Perfuração realizada', 4
    );

    -- Inserir referências de teste
    INSERT INTO public.projeto_referencias (projeto_id, titulo, url, descricao) VALUES
    (projeto1_id, 'Dragões Orientais', 'https://pinterest.com/dragons', 'Inspirações de dragões orientais'),
    (projeto2_id, 'Joias Helix', 'https://bodyart.com/helix', 'Catálogo de joias para helix');

    RAISE NOTICE 'Dados de teste inseridos com sucesso!';
  ELSE
    RAISE NOTICE 'Dados de teste já existem.';
  END IF;
END $$;

-- =====================================================
-- 6. VERIFICAR INSTALAÇÃO
-- =====================================================

-- Mostrar resumo das tabelas criadas
SELECT 
  'projetos' as tabela,
  COUNT(*) as registros
FROM public.projetos
UNION ALL
SELECT 
  'projeto_sessoes' as tabela,
  COUNT(*) as registros  
FROM public.projeto_sessoes
UNION ALL
SELECT 
  'projeto_referencias' as tabela,
  COUNT(*) as registros
FROM public.projeto_referencias;

-- =====================================================
-- SCRIPT CONCLUÍDO!
-- =====================================================
-- Após executar este script:
-- 1. Reinicie o servidor de desenvolvimento (npm run dev)
-- 2. Teste criar um novo projeto na aplicação
-- 3. Verifique se os dados aparecem nas tabelas
-- =====================================================