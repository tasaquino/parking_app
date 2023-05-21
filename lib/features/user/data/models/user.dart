class AppUser {
  const AppUser(
      {required this.id,
      required this.name,
      required this.email,
      this.photoUrl});
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
}
