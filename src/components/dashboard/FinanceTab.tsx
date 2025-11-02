import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LineChart, Line, BarChart, Bar, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts";
import { format, startOfMonth, endOfMonth, eachMonthOfInterval, subMonths } from "date-fns";
import { ptBR } from "date-fns/locale";

interface FinanceTabProps {
  transacoes: any[];
}

export function FinanceTab({ transacoes }: FinanceTabProps) {
  // Revenue vs Expenses over time
  const last6Months = eachMonthOfInterval({
    start: subMonths(new Date(), 5),
    end: new Date(),
  });

  const revenueData = last6Months.map(month => {
    const monthStart = startOfMonth(month);
    const monthEnd = endOfMonth(month);
    
    const receitas = transacoes
      .filter(t => t.tipo === "receita" && new Date(t.data_vencimento) >= monthStart && new Date(t.data_vencimento) <= monthEnd)
      .reduce((sum, t) => sum + Number(t.valor), 0);

    const despesas = transacoes
      .filter(t => t.tipo === "despesa" && new Date(t.data_vencimento) >= monthStart && new Date(t.data_vencimento) <= monthEnd)
      .reduce((sum, t) => sum + Number(t.valor), 0);

    return {
      mes: format(month, "MMM", { locale: ptBR }),
      receita: receitas,
      despesas,
      lucro: receitas - despesas,
    };
  });

  // Categories distribution
  const categorias = transacoes.reduce((acc, t) => {
    acc[t.categoria] = (acc[t.categoria] || 0) + Number(t.valor);
    return acc;
  }, {} as Record<string, number>);

  const categoriaData = Object.entries(categorias).map(([name, value]) => ({
    name,
    value,
  }));

  const COLORS = ["#3b82f6", "#8b5cf6", "#10b981", "#f59e0b", "#ef4444", "#06b6d4", "#ec4899"];

  // Payment status
  const pagas = transacoes.filter(t => t.data_liquidacao).reduce((sum, t) => sum + Number(t.valor), 0);
  const pendentes = transacoes.filter(t => !t.data_liquidacao).reduce((sum, t) => sum + Number(t.valor), 0);

  const statusData = [
    { name: "Pagas", value: pagas, color: "#10b981" },
    { name: "Pendentes", value: pendentes, color: "#f59e0b" },
  ];

  return (
    <div className="grid gap-4 md:grid-cols-2">
      <Card className="rounded-3xl border-0 shadow-sm md:col-span-2">
        <CardHeader>
          <CardTitle className="text-lg font-semibold">Receitas vs Despesas</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={200}>
            <LineChart data={revenueData}>
              <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
              <XAxis dataKey="mes" className="text-xs" />
              <YAxis className="text-xs" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: "hsl(var(--card))", 
                  border: "1px solid hsl(var(--border))",
                  borderRadius: "1rem"
                }}
                formatter={(value: number) => `R$ ${value.toFixed(2)}`}
              />
              <Legend />
              <Line type="monotone" dataKey="receita" stroke="#10b981" strokeWidth={2} name="Receitas" />
              <Line type="monotone" dataKey="despesas" stroke="#ef4444" strokeWidth={2} name="Despesas" />
              <Line type="monotone" dataKey="lucro" stroke="#3b82f6" strokeWidth={2} name="Lucro" />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-3xl border-0 shadow-sm">
        <CardHeader>
          <CardTitle className="text-lg font-semibold">Por Categoria</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={categoriaData}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                outerRadius={80}
                fill="#8884d8"
                dataKey="value"
              >
                {categoriaData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: "hsl(var(--card))", 
                  border: "1px solid hsl(var(--border))",
                  borderRadius: "1rem"
                }}
                formatter={(value: number) => `R$ ${value.toFixed(2)}`}
              />
            </PieChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-3xl border-0 shadow-sm">
        <CardHeader>
          <CardTitle className="text-lg font-semibold">Status de Pagamento</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={statusData}>
              <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
              <XAxis dataKey="name" className="text-xs" />
              <YAxis className="text-xs" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: "hsl(var(--card))", 
                  border: "1px solid hsl(var(--border))",
                  borderRadius: "1rem"
                }}
                formatter={(value: number) => `R$ ${value.toFixed(2)}`}
              />
              <Bar dataKey="value" radius={[8, 8, 0, 0]}>
                {statusData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
    </div>
  );
}
