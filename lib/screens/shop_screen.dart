import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // Keeping for distance calculation
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../theme/app_colors.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String _mapTilerApiKey = 'lHexwJZXxcXlK7A0DtHo';
  final StreamController<List<Map<String, dynamic>>> _storeStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Timer? _timer;
  int _selectedStoreIndex = 0;
  // Hardcoded location: Mumbai (19.0760° N, 72.8777° E)
  final double _hardcodedLat = 19.0760;
  final double _hardcodedLon = 72.8777;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startDataStream();
    setState(() {
      _isLoading = false; // No location fetch, so loading is instant
    });
  }

  @override
  void dispose() {
    _storeStreamController.close();
    _timer?.cancel();
    super.dispose();
  }

  void _startDataStream() {
    // Simulate MapTiler API response with nearby stores based on hardcoded location
    List<Map<String, dynamic>> initialStores = [
      {
        'name': 'Mahima Medical Store',
        'address': 'Anurag Chowk, Gorakhpur-273001',
        'lat': 26.7606,
        'lon': 83.3732,
        'distance': Geolocator.distanceBetween(_hardcodedLat, _hardcodedLon, 26.7606, 83.3732) / 1000,
        'items': [
          {'name': 'Stayfree Secure Pads', 'price': 189.0, 'tags': ['Sanitary Pads'], 'stock': 50},
          {'name': 'Ibuprofen (Pain Relief)', 'price': 120.0, 'tags': ['Menstrual Relief'], 'stock': 30},
        ],
      },
      {
        'name': 'Priya Women’s Clinic Store',
        'address': 'Powai, Mumbai-100075',
        'lat': 19.1155,
        'lon': 72.9089,
        'distance': Geolocator.distanceBetween(_hardcodedLat, _hardcodedLon, 19.1155, 72.9089) / 1000,
        'items': [
          {'name': 'Sofy Antibacterial Pads', 'price': 250.0, 'tags': ['Sanitary Pads'], 'stock': 25},
          {'name': 'Heat Patch (Cramps)', 'price': 150.0, 'tags': ['Menstrual Relief'], 'stock': 20},
        ],
      },
      {
        'name': 'Gupta Health Hub',
        'address': 'Shubhash Nagar, Kota-324001',
        'lat': 25.2138,
        'lon': 75.8643,
        'distance': Geolocator.distanceBetween(_hardcodedLat, _hardcodedLon, 25.2138, 75.8643) / 1000,
        'items': [
          {'name': 'Stayfree Overnight Pads', 'price': 199.0, 'tags': ['Sanitary Pads'], 'stock': 35},
          {'name': 'Menstrual Cup (Medium)', 'price': 300.0, 'tags': ['Menstrual Products'], 'stock': 15},
        ],
      },
    ];

    initialStores.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    _storeStreamController.add(initialStores);

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_storeStreamController.isClosed) {
        final updatedStores = List<Map<String, dynamic>>.from(initialStores);
        for (var store in updatedStores) {
          for (var item in store['items']) {
            item['stock'] = (item['stock'] as int) - (1 + (DateTime.now().second % 3));
            if (item['stock'] < 0) item['stock'] = 0;
          }
        }
        _storeStreamController.add(updatedStores);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop for Women’s Needs'),
        backgroundColor: AppColors.blushRose,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: AppColors.deepPlum),
                const SizedBox(width: 4),
                Text(
                  '${user.cartTotal.toStringAsFixed(0)} INR',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: AppColors.deepPlum,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _storeStreamController.stream,
              initialData: [],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No stores available'));
                }

                final stores = snapshot.data!;
                final selectedStore = stores[_selectedStoreIndex];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Nearby Stores',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.deepPlum,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          final store = stores[index];
                          final isSelected = index == _selectedStoreIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStoreIndex = index;
                              });
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.blushRose : Colors.grey[300]!,
                                  ),
                                ),
                                elevation: isSelected ? 4 : 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: AppColors.blushRose,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                store['name'][0].toUpperCase(),
                                                style: const TextStyle(
                                                  color: AppColors.deepPlum,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              store['name'],
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: AppColors.deepPlum,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${store['address']} (${store['distance'].toStringAsFixed(1)} km)',
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 10,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Available Items at ${selectedStore['name']}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.deepPlum,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: selectedStore['items'].length,
                        itemBuilder: (context, index) {
                          final item = selectedStore['items'][index];
                          final itemName = item['name'] as String;
                          final itemPrice = item['price'] as double;
                          final itemTags = item['tags'] as List<String>;
                          final itemStock = item['stock'] as int;
                          final cartQuantity = user.cartItems[itemName] ?? 0;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          itemName,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                color: AppColors.deepPlum,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '${itemPrice.toStringAsFixed(0)} INR',
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: AppColors.deepPlum,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stock: $itemStock',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: itemStock > 0 ? Colors.green : Colors.red,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  ExpansionTile(
                                    title: Text(
                                      'Item Detail',
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          '#${itemTags.join(', #')}',
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: itemStock > 0
                                            ? () {
                                                user.addToCart(itemName);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('$itemName added to cart!'),
                                                    duration: const Duration(seconds: 1),
                                                  ),
                                                );
                                              }
                                            : null,
                                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                                        label: const Text('Add to cart'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.blushRose,
                                          foregroundColor: AppColors.deepPlum,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                      ),
                                      if (cartQuantity > 0)
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                user.removeFromCart(itemName);
                                              },
                                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                                              iconSize: 24,
                                            ),
                                            Text(
                                              '$cartQuantity Added',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: AppColors.deepPlum,
                                                  ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${(itemPrice * cartQuantity).toStringAsFixed(0)} INR',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: AppColors.deepPlum,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: user.cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proceeding to checkout...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: AppColors.deepPlum,
              label: Text(
                'Checkout (${user.cartTotal.toStringAsFixed(0)} INR)',
                style: const TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.check, color: Colors.white),
            )
          : null,
    );
  }
}