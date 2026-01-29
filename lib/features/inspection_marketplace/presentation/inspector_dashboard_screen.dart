import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/models.dart';
import '../../../core/providers/auth_provider.dart';

/// Inspector Dashboard for inspection service providers
class InspectorDashboardScreen extends ConsumerStatefulWidget {
  const InspectorDashboardScreen({super.key});

  @override
  ConsumerState<InspectorDashboardScreen> createState() =>
      _InspectorDashboardScreenState();
}

class _InspectorDashboardScreenState
    extends ConsumerState<InspectorDashboardScreen> {
  int _selectedIndex = 0;

  // Mock data for demo
  final List<InspectionRequest> _pendingRequests = [
    InspectionRequest(
      id: '1',
      customerId: 'c1',
      customerName: 'Amal Perera',
      customerPhone: '+94 77 123 4567',
      inspectorId: 'i1',
      inspectorName: 'ABC Inspections',
      vehicleInfo: 'Toyota Prius 2018 - CAB-1234',
      location: 'Colombo 05',
      requestedDate: DateTime.now().add(const Duration(days: 2)),
      requestedTime: '10:00 AM',
      notes: 'Pre-purchase inspection before buying',
      status: InspectionRequestStatus.pending,
      createdAt: DateTime.now(),
    ),
    InspectionRequest(
      id: '2',
      customerId: 'c2',
      customerName: 'Nimal Silva',
      customerPhone: '+94 71 234 5678',
      inspectorId: 'i1',
      inspectorName: 'ABC Inspections',
      vehicleInfo: 'Honda Fit 2019 - WP-5678',
      location: 'Nugegoda',
      requestedDate: DateTime.now().add(const Duration(days: 3)),
      requestedTime: '2:00 PM',
      status: InspectionRequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  final List<InspectionRequest> _completedRequests = [
    InspectionRequest(
      id: '3',
      customerId: 'c3',
      customerName: 'Kumari Fernando',
      customerPhone: '+94 76 345 6789',
      inspectorId: 'i1',
      inspectorName: 'ABC Inspections',
      vehicleInfo: 'Suzuki Swift 2020 - WP-9012',
      location: 'Maharagama',
      requestedDate: DateTime.now().subtract(const Duration(days: 1)),
      requestedTime: '11:00 AM',
      status: InspectionRequestStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final List<Review> _reviews = [
    Review(
      id: 'r1',
      inspectorId: 'i1',
      customerId: 'c3',
      customerName: 'Kumari Fernando',
      rating: 5.0,
      comment: 'Excellent inspection! Very thorough and professional.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Review(
      id: 'r2',
      inspectorId: 'i1',
      customerId: 'c4',
      customerName: 'Saman Jayawardena',
      rating: 4.5,
      comment: 'Good service, found issues I would have missed.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final inspectorProfile = ref.watch(inspectorProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspector Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: _buildBody(inspectorProfile.value),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.inbox_outlined),
            ),
            selectedIcon: Icon(Icons.inbox),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(InspectorProfile? profile) {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview(profile);
      case 1:
        return _buildRequests();
      case 2:
        return _buildHistory();
      case 3:
        return _buildProfile(profile);
      default:
        return _buildOverview(profile);
    }
  }

  Widget _buildOverview(InspectorProfile? profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          if (profile?.status == InspectorStatus.pendingVerification)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.hourglass_empty, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Pending',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        Text(
                          'Your profile is under review. You\'ll be notified once approved.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inbox,
                  value: '${_pendingRequests.length}',
                  label: 'Pending',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  value: '${_completedRequests.length}',
                  label: 'Completed',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.star,
                  value: profile?.rating.toStringAsFixed(1) ?? '4.8',
                  label: 'Rating',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.reviews,
                  value: '${_reviews.length}',
                  label: 'Reviews',
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent requests
          SectionHeader(
            title: 'Pending Requests',
            actionText: 'View All',
            onAction: () => setState(() => _selectedIndex = 1),
          ),
          const SizedBox(height: 12),
          if (_pendingRequests.isEmpty)
            const EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: 'No pending requests',
              description: 'New inspection requests will appear here',
            )
          else
            ...(_pendingRequests.take(2).map((request) => _RequestCard(
                  request: request,
                  onAccept: () => _handleRequest(request, true),
                  onReject: () => _handleRequest(request, false),
                ))),

          const SizedBox(height: 24),

          // Recent reviews
          SectionHeader(
            title: 'Recent Reviews',
            actionText: 'View All',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          ...(_reviews.take(2).map((review) => _ReviewCard(review: review))),
        ],
      ),
    );
  }

  Widget _buildRequests() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Pending tab
                _pendingRequests.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.inbox_outlined,
                        title: 'No pending requests',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _pendingRequests.length,
                        itemBuilder: (context, index) {
                          return _RequestCard(
                            request: _pendingRequests[index],
                            onAccept: () =>
                                _handleRequest(_pendingRequests[index], true),
                            onReject: () =>
                                _handleRequest(_pendingRequests[index], false),
                          );
                        },
                      ),
                // Accepted tab
                const EmptyStateWidget(
                  icon: Icons.check_circle_outline,
                  title: 'No accepted requests',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    if (_completedRequests.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history,
        title: 'No completed inspections',
        description: 'Your inspection history will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _completedRequests.length,
      itemBuilder: (context, index) {
        final request = _completedRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.check, color: Colors.green),
            ),
            title: Text(request.vehicleInfo ?? 'Vehicle'),
            subtitle: Text(
              '${request.customerName} • ${_formatDate(request.requestedDate)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // View details
            },
          ),
        );
      },
    );
  }

  Widget _buildProfile(InspectorProfile? profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile header
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.business,
              size: 50,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile?.businessName ?? 'Your Business',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatusChip(profile?.status ?? InspectorStatus.pendingVerification),
            ],
          ),
          const SizedBox(height: 24),

          // Profile completion
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile Completion',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '80%',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add certifications to complete your profile',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Settings list
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.schedule,
                  title: 'Update Availability',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.attach_money,
                  title: 'Update Pricing',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.notifications,
                  title: 'Notification Settings',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout
          Card(
            child: _SettingsTile(
              icon: Icons.logout,
              title: 'Sign Out',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () async {
                final authService = ref.read(authServiceProvider);
                if (authService == null) return;

                await authService.signOut();

                if (mounted) {
                  context.go('/login');
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildStatusChip(InspectorStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case InspectorStatus.active:
        color = Colors.green;
        text = 'Active';
        icon = Icons.check_circle;
        break;
      case InspectorStatus.pendingVerification:
        color = Colors.orange;
        text = 'Pending Verification';
        icon = Icons.hourglass_empty;
        break;
      case InspectorStatus.suspended:
        color = Colors.red;
        text = 'Suspended';
        icon = Icons.block;
        break;
      case InspectorStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _handleRequest(InspectionRequest request, bool accept) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(accept ? 'Accept Request' : 'Reject Request'),
        content: Text(
          accept
              ? 'Accept inspection request from ${request.customerName}?'
              : 'Reject inspection request from ${request.customerName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accept ? Colors.green : Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    accept ? 'Request accepted!' : 'Request rejected',
                  ),
                ),
              );
              setState(() {
                _pendingRequests.remove(request);
              });
            },
            child: Text(accept ? 'Accept' : 'Reject'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final InspectionRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    request.customerName[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        request.customerPhone,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'New',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (request.vehicleInfo != null) ...[
              Row(
                children: [
                  const Icon(Icons.directions_car, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(request.vehicleInfo!)),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${request.requestedDate.day}/${request.requestedDate.month}/${request.requestedDate.year}',
                ),
                if (request.requestedTime != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 8),
                  Text(request.requestedTime!),
                ],
              ],
            ),
            if (request.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(request.location!)),
                ],
              ),
            ],
            if (request.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                request.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    review.customerName[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(review.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (review.comment != null) ...[
              const SizedBox(height: 12),
              Text(
                review.comment!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}';
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

}
