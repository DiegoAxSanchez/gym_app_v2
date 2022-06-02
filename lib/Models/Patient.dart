class Patient {
  final String nom, prenom;

  Patient({required this.nom, required this.prenom});

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'nom': nom,
      'prenom': prenom,
    };
  }
}
