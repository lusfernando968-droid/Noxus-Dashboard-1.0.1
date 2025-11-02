import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { 
  Brain, 
  AlertTriangle, 
  TrendingUp, 
  Users, 
  Calendar, 
  DollarSign,
  Target,
  Lightbulb,
  ArrowRight
} from "lucide-react";

interface SmartInsightsProps {
  transacoes: any[];
  clientes: any[];
  projetos: any[];
  agendamentos: any[];
}

interface Insight {
  id: string;
  type: 'warning' | 'opportunity' | 'trend' | 'recommendation';
  title: string;
  description: string;
  impact: 'high' | 'medium' | 'low';
  action?: string;
  icon: any;
  color: string;
  bgColor: string;
}

export function SmartInsights({ transacoes, clientes, projetos, agendamentos }: SmartInsightsProps) {
  // Simulação de insights baseados em IA (em produção, viriam de análise real dos dados)
  const insights: Insight[] = [
    {
      id: '1',
      type: 'warning',
      title: 'Clientes Inativos Detectados',
      description: '12 clientes não fazem agendamentos há mais de 60 dias. Risco de churn alto.',
      impact: 'high',
      action: 'Enviar campanha de reativação',
      icon: AlertTriangle,
      color: 'text-red-600',
      bgColor: 'bg-red-500/10'
    },
    {
      id: '2',
      type: 'opportunity',
      title: 'Oportunidade de Upsell',
      description: '8 clientes com histórico de tatuagens pequenas podem estar prontos para projetos maiores.',
      impact: 'high',
      action: 'Criar proposta personalizada',
      icon: TrendingUp,
      color: 'text-green-600',
      bgColor: 'bg-green-500/10'
    },
    {
      id: '3',
      type: 'trend',
      title: 'Tendência Sazonal Identificada',
      description: 'Aumento de 35% em agendamentos nas sextas-feiras. Considere expandir horários.',
      impact: 'medium',
      action: 'Otimizar agenda',
      icon: Calendar,
      color: 'text-blue-600',
      bgColor: 'bg-blue-500/10'
    },
    {
      id: '4',
      type: 'recommendation',
      title: 'Preço Sugerido para Novos Serviços',
      description: 'Baseado no mercado local, tatuagens coloridas podem ter preço 20% maior.',
      impact: 'medium',
      action: 'Revisar tabela de preços',
      icon: DollarSign,
      color: 'text-purple-600',
      bgColor: 'bg-purple-500/10'
    },
    {
      id: '5',
      type: 'opportunity',
      title: 'Horário de Pico Subutilizado',
      description: 'Terças-feiras têm 40% menos agendamentos. Oportunidade para promoções.',
      impact: 'low',
      action: 'Criar promoção especial',
      icon: Target,
      color: 'text-orange-600',
      bgColor: 'bg-orange-500/10'
    }
  ];

  const getImpactBadge = (impact: string) => {
    switch (impact) {
      case 'high':
        return <Badge variant="destructive" className="rounded-full">Alto Impacto</Badge>;
      case 'medium':
        return <Badge variant="secondary" className="rounded-full">Médio Impacto</Badge>;
      case 'low':
        return <Badge variant="outline" className="rounded-full">Baixo Impacto</Badge>;
      default:
        return null;
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'warning':
        return AlertTriangle;
      case 'opportunity':
        return Lightbulb;
      case 'trend':
        return TrendingUp;
      case 'recommendation':
        return Brain;
      default:
        return Brain;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <Card className="rounded-3xl border-0 bg-gradient-to-r from-primary/10 to-primary/5 shadow-lg">
        <CardHeader>
          <div className="flex items-center gap-3">
            <div className="p-3 bg-primary/20 rounded-2xl">
              <Brain className="w-6 h-6 text-primary" />
            </div>
            <div>
              <CardTitle className="text-xl">Insights Inteligentes</CardTitle>
              <p className="text-sm text-muted-foreground">
                Análises baseadas em IA para otimizar seu negócio
              </p>
            </div>
          </div>
        </CardHeader>
      </Card>

      {/* Insights Grid */}
      <div className="grid gap-4 md:grid-cols-1 lg:grid-cols-2">
        {insights.map((insight) => {
          const IconComponent = insight.icon;
          const TypeIcon = getTypeIcon(insight.type);
          
          return (
            <Card key={insight.id} className={`rounded-3xl border-0 shadow-lg ${insight.bgColor} hover:shadow-xl transition-all duration-300 group`}>
              <CardContent className="p-6">
                <div className="space-y-4">
                  {/* Header */}
                  <div className="flex items-start justify-between">
                    <div className="flex items-center gap-3">
                      <div className={`p-2 rounded-xl ${insight.bgColor}`}>
                        <IconComponent className={`w-5 h-5 ${insight.color}`} />
                      </div>
                      <div className="flex items-center gap-2">
                        <TypeIcon className={`w-4 h-4 ${insight.color}`} />
                        <span className={`text-xs font-medium uppercase tracking-wide ${insight.color}`}>
                          {insight.type}
                        </span>
                      </div>
                    </div>
                    {getImpactBadge(insight.impact)}
                  </div>

                  {/* Content */}
                  <div className="space-y-2">
                    <h3 className="font-semibold text-foreground">{insight.title}</h3>
                    <p className="text-sm text-muted-foreground leading-relaxed">
                      {insight.description}
                    </p>
                  </div>

                  {/* Action */}
                  {insight.action && (
                    <Button 
                      variant="outline" 
                      size="sm" 
                      className="w-full rounded-xl group-hover:bg-primary group-hover:text-primary-foreground transition-all"
                    >
                      {insight.action}
                      <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
                    </Button>
                  )}
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Summary Stats */}
      <div className="grid gap-4 md:grid-cols-3">
        <Card className="rounded-3xl border-0 bg-gradient-to-br from-green-500/10 to-green-600/5 shadow-lg">
          <CardContent className="p-6 text-center">
            <div className="space-y-2">
              <div className="p-3 bg-green-500/20 rounded-2xl w-fit mx-auto">
                <TrendingUp className="w-6 h-6 text-green-600" />
              </div>
              <p className="text-2xl font-bold text-green-600">5</p>
              <p className="text-sm text-muted-foreground">Insights Ativos</p>
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-3xl border-0 bg-gradient-to-br from-blue-500/10 to-blue-600/5 shadow-lg">
          <CardContent className="p-6 text-center">
            <div className="space-y-2">
              <div className="p-3 bg-blue-500/20 rounded-2xl w-fit mx-auto">
                <Target className="w-6 h-6 text-blue-600" />
              </div>
              <p className="text-2xl font-bold text-blue-600">R$ 15K</p>
              <p className="text-sm text-muted-foreground">Potencial de Receita</p>
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-3xl border-0 bg-gradient-to-br from-purple-500/10 to-purple-600/5 shadow-lg">
          <CardContent className="p-6 text-center">
            <div className="space-y-2">
              <div className="p-3 bg-purple-500/20 rounded-2xl w-fit mx-auto">
                <Users className="w-6 h-6 text-purple-600" />
              </div>
              <p className="text-2xl font-bold text-purple-600">20</p>
              <p className="text-sm text-muted-foreground">Clientes Impactados</p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}