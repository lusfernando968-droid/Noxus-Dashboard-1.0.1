import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { 
  GripVertical, 
  Settings, 
  Eye, 
  EyeOff, 
  RotateCcw,
  Users,
  Briefcase,
  DollarSign,
  Calendar,
  TrendingUp,
  BarChart3,
  PieChart,
  Activity
} from "lucide-react";

interface Widget {
  id: string;
  title: string;
  type: 'metric' | 'chart' | 'list' | 'progress';
  size: 'small' | 'medium' | 'large';
  visible: boolean;
  position: number;
  icon: any;
  color: string;
  bgColor: string;
  value?: string | number;
  change?: number;
  data?: any[];
}

interface DraggableWidgetsProps {
  transacoes: any[];
  clientes: any[];
  projetos: any[];
  agendamentos: any[];
}

export function DraggableWidgets({ transacoes, clientes, projetos, agendamentos }: DraggableWidgetsProps) {
  const [isEditMode, setIsEditMode] = useState(false);
  const [widgets, setWidgets] = useState<Widget[]>([
    {
      id: 'clients-total',
      title: 'Total de Clientes',
      type: 'metric',
      size: 'small',
      visible: true,
      position: 1,
      icon: Users,
      color: 'text-blue-600',
      bgColor: 'bg-blue-500/10',
      value: clientes.length,
      change: 12.5
    },
    {
      id: 'projects-active',
      title: 'Projetos Ativos',
      type: 'metric',
      size: 'small',
      visible: true,
      position: 2,
      icon: Briefcase,
      color: 'text-purple-600',
      bgColor: 'bg-purple-500/10',
      value: projetos.filter(p => p.status === 'em_andamento').length,
      change: 8.3
    },
    {
      id: 'revenue-month',
      title: 'Receita do Mês',
      type: 'metric',
      size: 'medium',
      visible: true,
      position: 3,
      icon: DollarSign,
      color: 'text-green-600',
      bgColor: 'bg-green-500/10',
      value: 'R$ 28.5K',
      change: 15.2
    },
    {
      id: 'appointments-today',
      title: 'Agendamentos Hoje',
      type: 'metric',
      size: 'small',
      visible: true,
      position: 4,
      icon: Calendar,
      color: 'text-orange-600',
      bgColor: 'bg-orange-500/10',
      value: agendamentos.filter(a => a.status === 'agendado').length,
      change: -5.1
    },
    {
      id: 'growth-chart',
      title: 'Crescimento Mensal',
      type: 'chart',
      size: 'large',
      visible: true,
      position: 5,
      icon: TrendingUp,
      color: 'text-indigo-600',
      bgColor: 'bg-indigo-500/10',
      data: [
        { name: 'Jan', value: 12000 },
        { name: 'Fev', value: 15000 },
        { name: 'Mar', value: 18000 },
        { name: 'Abr', value: 22000 },
        { name: 'Mai', value: 25000 },
        { name: 'Jun', value: 28000 },
      ]
    },
    {
      id: 'conversion-rate',
      title: 'Taxa de Conversão',
      type: 'progress',
      size: 'medium',
      visible: true,
      position: 6,
      icon: BarChart3,
      color: 'text-cyan-600',
      bgColor: 'bg-cyan-500/10',
      value: '68%',
      change: 3.2
    },
    {
      id: 'client-satisfaction',
      title: 'Satisfação do Cliente',
      type: 'progress',
      size: 'small',
      visible: false,
      position: 7,
      icon: Activity,
      color: 'text-pink-600',
      bgColor: 'bg-pink-500/10',
      value: '94%',
      change: 2.1
    },
    {
      id: 'service-distribution',
      title: 'Distribuição de Serviços',
      type: 'chart',
      size: 'medium',
      visible: false,
      position: 8,
      icon: PieChart,
      color: 'text-emerald-600',
      bgColor: 'bg-emerald-500/10',
      data: [
        { name: 'Tatuagens', value: 65 },
        { name: 'Retoques', value: 20 },
        { name: 'Consultas', value: 15 },
      ]
    }
  ]);

  const toggleWidgetVisibility = (widgetId: string) => {
    setWidgets(prev => prev.map(widget => 
      widget.id === widgetId 
        ? { ...widget, visible: !widget.visible }
        : widget
    ));
  };

  const resetLayout = () => {
    setWidgets(prev => prev.map((widget, index) => ({
      ...widget,
      position: index + 1,
      visible: index < 6 // Mostrar apenas os primeiros 6 por padrão
    })));
  };

  const getGridClass = (size: string) => {
    switch (size) {
      case 'small':
        return 'col-span-1';
      case 'medium':
        return 'col-span-2';
      case 'large':
        return 'col-span-3';
      default:
        return 'col-span-1';
    }
  };

  const visibleWidgets = widgets.filter(w => w.visible).sort((a, b) => a.position - b.position);

  const renderWidget = (widget: Widget) => {
    const IconComponent = widget.icon;
    const isPositive = (widget.change || 0) >= 0;

    return (
      <Card 
        key={widget.id}
        className={`${getGridClass(widget.size)} rounded-3xl border-0 shadow-lg ${widget.bgColor} hover:shadow-xl transition-all duration-300 group ${
          isEditMode ? 'ring-2 ring-primary/20 cursor-move' : ''
        }`}
      >
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <div className={`p-2 rounded-xl ${widget.bgColor}`}>
                <IconComponent className={`w-4 h-4 ${widget.color}`} />
              </div>
              <CardTitle className="text-sm font-medium">{widget.title}</CardTitle>
            </div>
            {isEditMode && (
              <div className="flex items-center gap-1">
                <Button
                  size="sm"
                  variant="ghost"
                  className="h-6 w-6 p-0 opacity-0 group-hover:opacity-100 transition-opacity"
                  onClick={() => toggleWidgetVisibility(widget.id)}
                >
                  <EyeOff className="w-3 h-3" />
                </Button>
                <GripVertical className="w-4 h-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-opacity" />
              </div>
            )}
          </div>
        </CardHeader>
        <CardContent className="pt-0">
          {widget.type === 'metric' && (
            <div className="space-y-2">
              <div className="flex items-end gap-2">
                <span className="text-2xl font-bold">{widget.value}</span>
                {widget.change && (
                  <Badge 
                    variant={isPositive ? "default" : "destructive"}
                    className="text-xs rounded-full"
                  >
                    {isPositive ? '+' : ''}{widget.change}%
                  </Badge>
                )}
              </div>
            </div>
          )}

          {widget.type === 'progress' && (
            <div className="space-y-3">
              <div className="flex items-end gap-2">
                <span className="text-xl font-bold">{widget.value}</span>
                {widget.change && (
                  <Badge 
                    variant={isPositive ? "default" : "destructive"}
                    className="text-xs rounded-full"
                  >
                    {isPositive ? '+' : ''}{widget.change}%
                  </Badge>
                )}
              </div>
              <div className="w-full bg-muted/30 rounded-full h-2">
                <div
                  className={`h-full rounded-full transition-all duration-1000 bg-gradient-to-r ${widget.color.replace('text-', 'from-')} to-${widget.color.replace('text-', '').replace('-600', '-400')}`}
                  style={{ width: widget.value }}
                />
              </div>
            </div>
          )}

          {widget.type === 'chart' && widget.data && (
            <div className="space-y-2">
              {widget.size === 'large' ? (
                <div className="space-y-2">
                  {widget.data.slice(0, 4).map((item: any, index: number) => (
                    <div key={index} className="flex items-center justify-between text-sm">
                      <span>{item.name}</span>
                      <span className="font-medium">
                        {typeof item.value === 'number' && item.value > 1000 
                          ? `R$ ${(item.value / 1000).toFixed(1)}K`
                          : item.value
                        }
                      </span>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center">
                  <span className="text-lg font-semibold">{widget.data.length}</span>
                  <p className="text-xs text-muted-foreground">itens</p>
                </div>
              )}
            </div>
          )}
        </CardContent>
      </Card>
    );
  };

  return (
    <div className="space-y-6">
      {/* Controls */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-semibold">Widgets Personalizáveis</h2>
          <p className="text-sm text-muted-foreground">
            {isEditMode ? 'Arraste para reorganizar ou clique no olho para ocultar' : 'Visualização personalizada do seu dashboard'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={resetLayout}
            className="rounded-xl"
          >
            <RotateCcw className="w-4 h-4 mr-2" />
            Resetar
          </Button>
          <Button
            variant={isEditMode ? "default" : "outline"}
            size="sm"
            onClick={() => setIsEditMode(!isEditMode)}
            className="rounded-xl"
          >
            <Settings className="w-4 h-4 mr-2" />
            {isEditMode ? 'Concluir' : 'Editar'}
          </Button>
        </div>
      </div>

      {/* Hidden Widgets (when in edit mode) */}
      {isEditMode && (
        <div className="space-y-3">
          <h3 className="text-sm font-medium text-muted-foreground">Widgets Ocultos</h3>
          <div className="flex flex-wrap gap-2">
            {widgets.filter(w => !w.visible).map(widget => {
              const IconComponent = widget.icon;
              return (
                <Button
                  key={widget.id}
                  variant="outline"
                  size="sm"
                  onClick={() => toggleWidgetVisibility(widget.id)}
                  className="rounded-xl"
                >
                  <IconComponent className="w-4 h-4 mr-2" />
                  {widget.title}
                  <Eye className="w-4 h-4 ml-2" />
                </Button>
              );
            })}
          </div>
        </div>
      )}

      {/* Widgets Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {visibleWidgets.map(renderWidget)}
      </div>
    </div>
  );
}