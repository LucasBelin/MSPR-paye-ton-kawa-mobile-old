import 'package:flutter/material.dart';
import 'package:paye_ton_kawa/ar_view.dart';
import 'package:paye_ton_kawa/models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails produit"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: Text(
              product.name,
              style:
                  const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.palette,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      product.details.color,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.euro_symbol,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      product.details.price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.inventory_2,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      product.stock.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              product.details.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LocalAndWebObjectsWidget()),
              );
            },
            icon: const Icon(
              Icons.view_in_ar_outlined,
              color: Colors.white,
            ),
            label: const Text(
              'Voir en réalité virtuelle',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
