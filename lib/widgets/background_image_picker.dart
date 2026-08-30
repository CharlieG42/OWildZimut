import 'package:file_selector/file_selector.dart';

/// Ouvre le selecteur de fichiers du systeme pour choisir une image de fond
/// de carte (jpg, jpeg ou png). Retourne le fichier choisi, ou `null` si
/// l'utilisateur a annule.
Future<XFile?> pickBackgroundImage() async {
  const typeGroup = XTypeGroup(
    label: 'Images (fond de carte)',
    extensions: ['jpg', 'jpeg', 'png'],
  );

  return openFile(acceptedTypeGroups: [typeGroup]);
}
