import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZiftMoveApp());
}

class ZiftMoveApp extends StatelessWidget {
  const ZiftMoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZiftMove',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isDriverOnline = true;
  int _timerSeconds = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ZiftMove Mobility',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(
                _isDriverOnline ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                  color: _isDriverOnline ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Switch(
                value: _isDriverOnline,
                activeColor: Colors.greenAccent,
                onChanged: (val) {
                  setState(() {
                    _isDriverOnline = val;
                  });
                },
              ),
            ],
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCustomerBookingView(),
          _buildDriverPartnerView(),
          _buildSubscriptionsView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2563EB),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi),
            label: 'Book Ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.two_wheeler),
            label: 'Driver Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Subscription',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerBookingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.my_location, color: Colors.blue),
                      labelText: 'Pickup Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      labelText: 'Drop Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Searching nearby drivers...')),
                      );
                    },
                    child: const Text('Book Ride / Parcel', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Fare Structure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _fareTile('Bike / Scooty', '₹12/km (Normal) | ₹10/km (Long Route)'),
          _fareTile('Three-Wheeler', 'Short: ₹24/km | Long: ₹20/km + Toll'),
          _fareTile('Truck / Cargo', 'Capacity & Distance Based Rate'),
        ],
      ),
    );
  }

  Widget _fareTile(String vehicle, String rate) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.directions_bike, color: Color(0xFF2563EB)),
        title: Text(vehicle, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(rate),
      ),
    );
  }

  Widget _buildDriverPartnerView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.amber, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('NEW ORDER REQUEST', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                        child: Text('$_timerSeconds sec', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Connaught Place -> Karol Bagh (5.2 km)'),
                    subtitle: Text('Fare: ₹62 | Cargo Weight: 15kg'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order Rejected!')),
                            );
                          },
                          child: const Text('REJECT'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order Accepted!')),
                            );
                          },
                          child: const Text('ACCEPT', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Zero Commission Plans',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _subCard('Bike / Scooty Plan', '₹899', 'per month', Colors.blue),
        _subCard('Three-Wheeler Plan', '₹1,399', 'per month', Colors.green),
        _subCard('Four-Wheeler Cargo', '₹1,799', 'per month', Colors.orange),
        _subCard('Large Truck Plan', '₹2,399', 'per month', Colors.purple),
      ],
    );
  }

  Widget _subCard(String title, String price, String period, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.check, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('7-Day Free Trial Included'),
        trailing: Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}
