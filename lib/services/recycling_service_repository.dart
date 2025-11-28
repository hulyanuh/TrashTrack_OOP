import '../models/recycling_service.dart';

class RecyclingServiceRepository {
  // Simulate a database or API call
  Future<List<RecyclingService>> getRecommendedServices() async {
    // In a real app, this would fetch from an API
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    return [
      RecyclingService(
        id: '1',
        name: 'Junkify',
        status: 'open',
        distance: 10,
        serviceTypes: ['Metal', 'Paper', 'Plastic', 'Cardboard'],
        imageUrl: 'assets/images/Junkify.png',
        address: '123 Green Street',
        rating: 4.5,
      ),
      RecyclingService(
        id: '2',
        name: 'ReClaim',
        status: 'open',
        distance: 7,
        serviceTypes: ['Electronics', 'Battery', 'Metal'],
        imageUrl: 'assets/images/Junkify.png',
        address: '456 Eco Avenue',
        rating: 4.2,
      ),
      RecyclingService(
        id: '3',
        name: 'CardBox Recyclers',
        status: 'open',
        distance: 5,
        serviceTypes: ['Cardboard', 'Paper', 'Plastic'],
        imageUrl: 'assets/images/Junkify.png',
        address: '789 Box Street',
        rating: 4.8,
      ),
    ];
  }

  Future<List<RecyclingService>> getNearestServices() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      RecyclingService(
        id: '3',
        name: 'Earthy',
        status: 'open',
        distance: 3,
        serviceTypes: ['Pick up', 'Drop off'],
        imageUrl: 'assets/images/Junkify.png',
        address: '789 Recycle Road',
        rating: 4.3,
      ),
      RecyclingService(
        id: '4',
        name: 'EcoHub',
        status: 'closed',
        distance: 5,
        serviceTypes: ['Drop off'],
        imageUrl: 'assets/images/ecohub.jpg',
        address: '321 Sustainable Street',
        rating: 3.9,
      ),
    ];
  }

  // Simulate a database or API call
  Future<List<RecyclingService>> searchServices(String query) async {
    // Get all services
    final List<RecyclingService> allServices = [
      RecyclingService(
        id: '1',
        name: 'Junkify',
        status: 'open',
        distance: 1.2,
        serviceTypes: ['Metal', 'Paper', 'Plastic', 'Cardboard'],
        imageUrl: 'assets/images/Junkify.png',
        address: 'A.S. Fortuna St, Mandaue City',
        rating: 4.5,
      ),
      RecyclingService(
        id: '2',
        name: 'Green Earth Recycling',
        status: 'open',
        distance: 2.5,
        serviceTypes: ['Electronics', 'Metal', 'Appliances'],
        imageUrl: 'assets/images/Junkify.png',
        address: 'M.C. Briones St, Mandaue City',
        rating: 4.1,
      ),
      RecyclingService(
        id: '3',
        name: 'EcoWaste Solutions',
        status: 'closed',
        distance: 3.8,
        serviceTypes: ['Paper', 'Plastic', 'Glass', 'Cardboard'],
        imageUrl: 'assets/images/Junkify.png',
        address: 'N. Bacalso Ave, Cebu City',
        rating: 3.8,
      ),
      RecyclingService(
        id: '4',
        name: 'Metro Recyclers',
        status: 'open',
        distance: 4.2,
        serviceTypes: ['Metal', 'Battery', 'Electronics'],
        imageUrl: 'assets/images/Junkify.png',
        address: 'Banilad Road, Cebu City',
        rating: 4.0,
      ),
      RecyclingService(
        id: '5',
        name: 'CardBox Recyclers',
        status: 'open',
        distance: 3.0,
        serviceTypes: ['Cardboard', 'Paper', 'Plastic'],
        imageUrl: 'assets/images/Junkify.png',
        address: 'Box Street, Mandaue City',
        rating: 4.7,
      ),
    ];

    if (query.isEmpty) return allServices;

    // Filter services based on search query
    return allServices.where((service) {
      final searchLower = query.toLowerCase();
      return service.name.toLowerCase().contains(searchLower) ||
          service.address.toLowerCase().contains(searchLower) ||
          service.serviceTypes.any(
            (type) => type.toLowerCase().contains(searchLower),
          );
    }).toList();
  }

  Future<List<RecyclingService>> getTopServices() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      RecyclingService(
        id: '4',
        name: 'Earthy',
        status: 'open',
        distance: 3,
        serviceTypes: ['Glass', 'Metal', 'Paper', 'Cardboard'],
        imageUrl: 'assets/images/Junkify.png',
        address: '789 Recycle Road',
        rating: 4.3,
      ),
      RecyclingService(
        id: '5',
        name: 'EcoHub',
        status: 'closed',
        distance: 5,
        serviceTypes: ['Plastic', 'Electronics', 'Battery'],
        imageUrl: 'assets/images/Junkify.png',
        address: '321 Sustainable Street',
        rating: 3.9,
      ),
    ];
  }
}
