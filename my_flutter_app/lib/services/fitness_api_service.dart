class FitnessApiService {
  // This service will call backend APIs (REST or Firebase) in the future.
  
  Future<Map<String, dynamic>> fetchUserProfile() async {
    // Simulating API response
    await Future.delayed(const Duration(seconds: 1));
    return {
      'name': 'John Doe',
      'dailyCalorieTarget': 2500,
      'waterTargetMl': 3000,
    };
  }
}
