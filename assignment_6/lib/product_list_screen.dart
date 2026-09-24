import 'package:flutter/material.dart';
import 'product_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Master list of products
  final List<Product> _allProducts = const [
    Product(name: 'Laptop', category: 'Electronics', price: 999.99),
    Product(name: 'Smartphone', category: 'Electronics', price: 699.99),
    Product(name: 'Headphones', category: 'Audio', price: 149.99),
    Product(name: 'Desk Chair', category: 'Furniture', price: 199.99),
    Product(name: 'Coffee Mug', category: 'Kitchen', price: 12.50),
    Product(name: 'Backpack', category: 'Accessories', price: 49.99),
    Product(name: 'Running Shoes', category: 'Footwear', price: 89.99),
    Product(name: 'Water Bottle', category: 'Fitness', price: 19.99),
    Product(name: 'Wireless Mouse', category: 'Electronics', price: 29.99),
    Product(name: 'Notebook', category: 'Stationery', price: 5.99),
  ];

  // List holding filtered products for display
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter products using setState
  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Listing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search by name or category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProducts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          // Dynamic Product List using ListView.builder
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductTile(product: _filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
