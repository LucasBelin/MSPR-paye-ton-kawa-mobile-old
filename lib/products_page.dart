import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paye_ton_kawa/components/confirmation_dialog.dart';
import 'package:paye_ton_kawa/models/boxes.dart';
import 'package:paye_ton_kawa/models/product.dart';
import 'package:paye_ton_kawa/product_details_page.dart';

import 'login_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  bool isLoading = false;
  bool isError = false;

  final int itemsPerPage = 4;
  final PageController pageController = PageController(initialPage: 0);

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse(
        'https://615f5fb4f7254d0017068109.mockapi.io/api/v1/products'));
    if (response.statusCode == 200) {
      final jsonData = utf8.decode(response.bodyBytes);
      setState(() {
        isLoading = false;
        products = jsonDecode(jsonData)
            .map((productJson) => Product.fromJson(productJson))
            .toList()
            .cast<Product>();
      });
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('Error: ${response.statusCode}');
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else {
      setState(() {
        isLoading = false;
        isError = true;
      });
      debugPrint('Error: ${response.statusCode}');
    }
  }

  void logout() {
    box.delete("jwt_token");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onConfirm: (bool confirmed) {
            logout();
          },
          onCancel: (bool confirmed) {
            // Handle cancellation
            debugPrint('Cancelled: $confirmed');
          },
        );
      },
    );
  }

  List<Product> getDisplayedProducts() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, products.length);
    return products.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.blue[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentPage = 0;
                });
              },
              icon: const Icon(Icons.first_page, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                if (currentPage > 0) {
                  setState(() {
                    currentPage--;
                  });
                }
              },
              icon: const Icon(Icons.navigate_before, color: Colors.white),
            ),
            Text('Page ${currentPage + 1}',
                style: const TextStyle(color: Colors.white)),
            IconButton(
              onPressed: () {
                if (currentPage < (products.length / itemsPerPage).ceil() - 1) {
                  setState(() {
                    currentPage++;
                  });
                }
              },
              icon: const Icon(Icons.navigate_next, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                final lastPage = (products.length / itemsPerPage).ceil() - 1;
                setState(() {
                  currentPage = lastPage;
                });
              },
              icon: const Icon(Icons.last_page, color: Colors.white),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Produits"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _showConfirmationDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: isLoading
              ? const ProgressIndicator()
              : isError
                  ? const RequestErrorMessage()
                  : ListView.builder(
                      itemCount: itemsPerPage,
                      itemBuilder: (context, index) {
                        final displayedProducts = getDisplayedProducts();
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                title: Text(
                                  displayedProducts[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayedProducts[index]
                                          .details
                                          .description,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${displayedProducts[index].details.price}€",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -15,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsPage(
                                                  product: displayedProducts[
                                                      index])),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.chevron_right_outlined,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  label: const Text(""),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      controller: pageController),
        ),
      ),
    );
  }
}

class Products extends StatelessWidget {
  const Products({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  products[index].name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      products[index].details.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${products[index].details.price}€",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: -15,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: products[index])),
                    );
                  },
                  icon: const Icon(
                    Icons.chevron_right_outlined,
                    color: Colors.blue,
                    size: 30,
                  ),
                  label: const Text(""),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RequestErrorMessage extends StatelessWidget {
  const RequestErrorMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.sentiment_dissatisfied_outlined,
            color: Colors.red[700], size: 50),
        const Text(
          "Failed to retrieve products.\n Please check your internet connection and try again later.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.white,
    ));
  }
}
