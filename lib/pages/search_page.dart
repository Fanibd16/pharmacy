import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharmacy/map/map_search_screen.dart';
// import 'package:pharmacy/pages/qr_sacan_page.dart';

const List<String> _medicines = <String>[
  'Paracetamol',
  'Ibuprofen',
  'Aspirin',
  'Amoxicillin',
  'Ciprofloxacin',
  'Metformin',
  'Omeprazole',
  'Atorvastatin',
  'Antibiotic',
  'Painkiller',
  'Antibiotic'
];

class MedicineSelector extends StatefulWidget {
  const MedicineSelector({super.key});

  @override
  MedicineSelectorState createState() => MedicineSelectorState();
}

class MedicineSelectorState extends State<MedicineSelector> {
  final List<String> _selectedMedicines = [];
  List<String> _filteredMedicines = [];

  // Example pharmacy data to simulate the search
  final List<Map<String, dynamic>> pharmacyData = [
    {
      'name': 'Pharmacy A',
      'location': const LatLng(11.0497, 39.7473),
      'medicines': [
        {'medicine': 'Painkiller', 'price': '10 USD'},
        {'medicine': 'Antibiotic', 'price': '20 USD'},
        {'medicine': 'Vitamins', 'price': '5 USD'},
      ],

    },
    {
      'name': 'Pharmacy B',
      'location': const LatLng(11.0477, 39.7489),
      'medicines': [
        {'medicine': 'Paracetamol', 'price': '12 USD'},
        {'medicine': 'Cough Syrup', 'price': '18 USD'},
        {'medicine': 'Antibiotic', 'price': '15 USD'},
      ],

    },
    {
      'name': 'Pharmacy C',
      'location': const LatLng(11.0518, 39.7496),
      'medicines': [
        {'medicine': 'Vitamins', 'price': '8 USD'},
        {'medicine': 'Cough Syrup', 'price': '15 USD'},
      ],

    }
  ];

  List<Map<String, dynamic>> _filteredPharmacies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search for Medicines')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  // Use Expanded to fill the available space
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(IconlyLight.search),
                      hintText: 'Search for medicines',
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                // IconButton(
                //   // Use IconButton for the QR scanner
                //   icon: const Icon(IconlyLight.scan),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             const QRScanner(), // Navigate to QRScanner
                //       ),
                //     );
                //   },
                // ),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: _searchPharmacies,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xff674ff4).withOpacity(0.6),
                    ),
                    child: const Center(
                      child: Icon(
                        IconlyLight.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_filteredMedicines.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredMedicines.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredMedicines[index]),
                      onTap: () => _addMedicine(_filteredMedicines[index]),
                    );
                  },
                ),
              ),
            Wrap(
              children: _selectedMedicines.map((medicine) {
                return InputChip(
                  label: Text(medicine),
                  onDeleted: () => _removeMedicine(medicine),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredMedicines = _medicines
          .where((medicine) =>
              medicine.toLowerCase().contains(value.toLowerCase()) &&
              !_selectedMedicines.contains(medicine))
          .toList();
    });
  }

  void _addMedicine(String medicine) {
    setState(() {
      _selectedMedicines.add(medicine);
      _filteredMedicines.clear();
    });
  }

  void _removeMedicine(String medicine) {
    setState(() {
      _selectedMedicines.remove(medicine);
    });
  }

  void _searchPharmacies() {
    // Filter pharmacies that have all selected medicines
    _filteredPharmacies = pharmacyData.where((pharmacy) {
      final pharmacyMedicines = pharmacy['medicines'] as List<dynamic>;
      final medicineNames =
          pharmacyMedicines.map((m) => m['medicine']).toList();
      return _selectedMedicines
          .every((medicine) => medicineNames.contains(medicine));
    }).toList();

    // Navigate to MapScreen and pass filtered pharmacies and selected medicines
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          filteredPharmacies: _filteredPharmacies, // Pass filtered pharmacies
          searchedMedicines: _selectedMedicines, // Pass selected medicines
        ),
      ),
    );
  }
}



