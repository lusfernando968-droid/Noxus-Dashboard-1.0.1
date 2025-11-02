import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts";
import { format, startOfMonth, endOfMonth, eachMonthOfInterval, subMonths } from "date-fns";
import { ptBR } from "date-fns/locale";

interface ClientsTabProps {
  clientes: any[];
}

export function ClientsTab({ clientes }: ClientsTabProps) {
  const last6Months = eachMonthOfInterval({
    start: subMonths(new Date(), 5),
    end: new Date(),
  });

  const clientGrowth = last6Months.map(month => {
    const monthEnd = endOfMonth(month);
    
    const total = clientes.filter(c => new Date(c.created_at) <= monthEnd).length;
    const novos = clientes.filter(c => {
      const date = new Date(c.created_at);
      return date >= startOfMonth(month) && date <= monthEnd;
    }).length;

    return {
      mes: format(month, "MMM", { locale: ptBR }),
      total,
      novos,
    };
  });

  return (
    <div className="grid gap-4">
      <Card className="rounded-3xl border-0 shadow-sm">
        <CardHeader>
          <CardTitle className="text-lg font-semibold">Crescimento de Clientes</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={200}>
            <LineChart data={clientGrowth}>
              <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
              <XAxis dataKey="mes" className="text-xs" />
              <YAxis className="text-xs" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: "hsl(var(--card))", 
                  border: "1px solid hsl(var(--border))",
                  borderRadius: "1rem"
                }} 
              />
              <Legend />
              <Line type="monotone" dataKey="total" stroke="#3b82f6" strokeWidth={2} name="Total de Clientes" />
              <Line type="monotone" dataKey="novos" stroke="#10b981" strokeWidth={2} name="Novos Clientes" />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <div className="grid gap-4 md:grid-cols-3">
        <Card className="rounded-3xl border-0 shadow-sm">
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">Total de Clientes</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">{clientes.length}</div>
          </CardContent>
        </Card>

        <Card className="rounded-3xl border-0 shadow-sm">
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">Novos (30 dias)</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">
              {clientes.filter(c => new Date(c.created_at) >= subMonths(new Date(), 1)).length}
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-3xl border-0 shadow-sm">
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">Com Email</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">
              {clientes.filter(c => c.email).length}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
