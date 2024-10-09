import 'package:flutter/material.dart';

typedef OnRemoveConfirmed = void Function();

void showRemoveFavoriteDialog({
  required BuildContext context,
  required String title,
  required OnRemoveConfirmed onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Supprimer des favoris"),
        content: Text("Voulez-vous retirer $title de vos favoris ?"),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Supprimer"),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
