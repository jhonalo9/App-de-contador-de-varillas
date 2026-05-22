import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/report_bloc.dart';
import '../../../../core/utils/date_formatter.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Reportes'),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportExported) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF generado con éxito'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is ReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReportLoading || state is ReportExporting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generando reporte...'),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seleccionar período',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          title: const Text('Fecha inicio'),
                          subtitle: Text(DateFormatter.formatDate(_startDate)),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context, true),
                        ),
                        ListTile(
                          title: const Text('Fecha fin'),
                          subtitle: Text(DateFormatter.formatDate(_endDate)),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context, false),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ReportBloc>().add(
                                  GenerateReportEvent(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  ),
                                );
                          },
                          child: const Text('Generar Reporte'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state is ReportGenerated) ...[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resumen del período',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          _buildSummaryItem(
                            'Período:',
                            state.period,
                            Icons.date_range,
                          ),
                          _buildSummaryItem(
                            'Total de conteos:',
                            '${state.counts.length}',
                            Icons.history,
                          ),
                          _buildSummaryItem(
                            'Total de varillas:',
                            '${state.totalRebars}',
                            Icons.construction,
                          ),
                          _buildSummaryItem(
                            'Promedio por conteo:',
                            state.averagePerCount.toStringAsFixed(1),
                            Icons.trending_up,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ReportBloc>().add(
                                    ExportPDFEvent(
                                      counts: state.counts,
                                      totalRebars: state.totalRebars,
                                      averagePerCount: state.averagePerCount,
                                      period: state.period,
                                    ),
                                  );
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Exportar a PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Detalle de conteos:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.counts.length,
                    itemBuilder: (context, index) {
                      final count = state.counts[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF1B5E20),
                            child: Text(
                              '${count.verifiedCount}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(DateFormatter.formatDateTime(count.date)),
                          subtitle: Text('Varillas: ${count.verifiedCount}'),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1B5E20)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}