import 'package:flutter/material.dart';

/// Dialog "À propos" pour afficher les informations sur l'application
class AboutDialog extends StatelessWidget {
  final String appVersion;

  const AboutDialog({super.key, required this.appVersion});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('À propos de OWildZimut'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo/Icône (à remplacer par une vraie icône plus tard)
            const Icon(
              Icons.map,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            
            // Nom de l'application
            const Text(
              'OWildZimut',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Version
            Text(
              'Version: $appVersion',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Outil de création de cartes de Course d\'Orientation avec gestion avancée de calques.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Auteur
            const Text(
              'Auteur: Charlie Gentil',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Text(
              'Organisation: WildZimut',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
