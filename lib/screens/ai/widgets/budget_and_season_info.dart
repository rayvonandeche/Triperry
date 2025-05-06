import 'package:flutter/material.dart';
import '../models/ai_models.dart';

class BudgetAndSeasonInfo extends StatelessWidget {
  final BudgetRange budgetRange;
  final TravelSeason season;
  final List<TravelDocument> documents;

  const BudgetAndSeasonInfo({
    super.key,
    required this.budgetRange,
    required this.season,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBudgetSection(context),
        const SizedBox(height: 24),
        _buildSeasonSection(context),
        const SizedBox(height: 24),
        _buildDocumentsSection(context),
      ],
    );
  }

  Widget _buildBudgetSection(BuildContext context) {
    final costBreakdown = budgetRange.costBreakdown!;
    final exchangeRates = budgetRange.exchangeRates!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCostItem(context, 'Flights', costBreakdown.flights, exchangeRates),
            _buildCostItem(context, 'Accommodation', costBreakdown.accommodation, exchangeRates),
            _buildCostItem(context, 'Activities', costBreakdown.activities, exchangeRates),
            _buildCostItem(context, 'Food', costBreakdown.food, exchangeRates),
            _buildCostItem(context, 'Transportation', costBreakdown.transportation, exchangeRates),
            _buildCostItem(context, 'Miscellaneous', costBreakdown.miscellaneous, exchangeRates),
            const Divider(),
            _buildCostItem(
              context,
              'Total',
              costBreakdown.total,
              exchangeRates,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostItem(
    BuildContext context,
    String label,
    double amount,
    Map<String, double> exchangeRates, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Row(
            children: [
              Text(
                '${amount.toStringAsFixed(2)} ${budgetRange.currency}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (!isTotal) ...[
                const SizedBox(width: 8),
                Text(
                  '(${(amount * exchangeRates['EUR']!).toStringAsFixed(2)} EUR)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Season Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              season.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSeasonMetric(
                  context,
                  'Temperature',
                  '${season.averageTemperature}°C',
                  Icons.thermostat,
                ),
                const SizedBox(width: 16),
                _buildSeasonMetric(
                  context,
                  'Rainfall',
                  '${season.averageRainfall}mm',
                  Icons.water_drop,
                ),
                const SizedBox(width: 16),
                _buildSeasonMetric(
                  context,
                  'Crowds',
                  '${(season.crowdLevel * 100).toInt()}%',
                  Icons.people,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProsAndCons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProsAndCons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pros',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...season.pros.map((pro) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(pro)),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cons',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...season.cons.map((con) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(con)),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Required Documents',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...documents.map((doc) => _buildDocumentItem(context, doc)),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, TravelDocument doc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                doc.isRequired ? Icons.assignment : Icons.assignment_outlined,
                color: doc.isRequired ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  doc.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (doc.cost != null)
                Text(
                  '${doc.cost} ${budgetRange.currency}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            doc.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (doc.validityPeriod != null) ...[
            const SizedBox(height: 4),
            Text(
              'Validity: ${doc.validityPeriod}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (doc.processingTime != null) ...[
            const SizedBox(height: 4),
            Text(
              'Processing: ${doc.processingTime}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (doc.applicationUrl != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Handle URL opening
              },
              child: const Text('Apply Now'),
            ),
          ],
        ],
      ),
    );
  }
} 