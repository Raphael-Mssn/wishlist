# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

## [0.2.2] - 2026-02-05

### Nouvelles fonctionnalités

- **Déplacement de souhaits** : Possibilité de déplacer des souhaits entre wishlists avec tri alphabétique et présélection de la wishlist récente
- **Avatars sur les cartes de souhaits** : Affichage des avatars des utilisateurs ayant réservé un souhait
- **Badge de notifications** : Indicateur visuel pour les demandes d'amis en attente sur la barre de navigation
- **Tri alphabétique des amis**

### CI/CD

- Mise en place de l'intégration continue (CI) GitHub Actions
- Mise en place du déploiement continu (CD) vers Google Play et TestFlight
- Ajout de golden tests pour tous les écrans

### Corrections de bugs

- Gestion améliorée du SafeArea et du padding bottom sur iOS
- Correction du padding dans FriendDetailsScreen
- Tri des souhaits réservés par favoris puis alphabétiquement
- Suppression du snackbar de confirmation à la création de souhait
- Amélioration du padding sur les titres des cartes de souhaits