// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Wishlist';

  @override
  String get emailField => 'Email';

  @override
  String get validEmailError => 'Veuillez saisir une adresse e-mail valide';

  @override
  String get passwordField => 'Mot de passe';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?\nCréez-en un !';

  @override
  String get haveAccount => 'Vous avez déjà un compte ?\nConnectez-vous !';

  @override
  String get invalidLoginCredentials => 'Identifiants de connexion invalides';

  @override
  String get userAlreadyRegistered => 'Cet email est déjà enregistré';

  @override
  String get genericError => 'Une erreur est survenue, veuillez réessayer';

  @override
  String get pseudoField => 'Pseudo';

  @override
  String get validPseudoError => 'Le pseudo ne peut pas être vide';

  @override
  String get pseudoAlreadyExists => 'Ce pseudo est déjà utilisé';

  @override
  String get savePseudo => 'Sauvegarder';

  @override
  String get settingsScreenTitle => 'Paramètres';

  @override
  String get settingsScreenEmail => 'Email';

  @override
  String get settingsScreenEmailModify => 'Modifier';

  @override
  String get settingsScreenDisconnect => 'Se déconnecter';

  @override
  String get settingsScreenDisconnectDialogTitle => 'Se déconnecter';

  @override
  String get settingsScreenDisconnectDialogExplanation =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get settingsScreenPasswordModify => 'Modifier mon mot de passe';

  @override
  String get settingsScreenPseudoModify => 'Modifier mon pseudo';

  @override
  String get changePasswordScreenTitle => 'Mot de passe';

  @override
  String get oldPasswordField => 'Ancien mot de passe';

  @override
  String get newPasswordField => 'Nouveau mot de passe';

  @override
  String get confirmNewPasswordField => 'Confirmer le nouveau mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get oldPasswordIncorrect => 'Ancien mot de passe incorrect';

  @override
  String get changePasswordConfirm => 'Modifier';

  @override
  String get newPasswordShouldBeDifferent =>
      'Le nouveau mot de passe doit être différent de l\'ancien';

  @override
  String get changePseudoScreenTitle => 'Pseudo';

  @override
  String get newPseudoField => 'Nouveau pseudo';

  @override
  String get changePseudoConfirm => 'Modifier';

  @override
  String get changePseudoSuccess => 'Pseudo modifié avec succès';

  @override
  String get settingsScreenDeleteAccount => 'Supprimer mon compte';

  @override
  String get confirmDialogConfirmButtonLabel => 'OK';

  @override
  String get noWishlist => 'Aucune wishlist';

  @override
  String get createButton => 'Créer';

  @override
  String get createWishlist => 'Créer une wishlist';

  @override
  String get name => 'Nom';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get closeDialog => 'Fermer la fenêtre contextuelle';

  @override
  String get fiendsScreenTitle => 'Amis';

  @override
  String get noFriend => 'Aucun ami';

  @override
  String get addButton => 'Ajouter';

  @override
  String get emailOrPseudoHint => 'Email ou pseudo';

  @override
  String get noUserFound => 'Aucun utilisateur trouvé';

  @override
  String get friendDetailsRemove => 'Supprimer';

  @override
  String get removeFriendConfirmation =>
      'Es-tu sûr(e) de vouloir supprimer cet ami ?';

  @override
  String get removeFriendSuccess => 'Ami supprimé avec succès';

  @override
  String numberOfWishlists(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wishlists',
      one: '1 wishlist',
      zero: '0 wishlist',
    );
    return '$_temp0';
  }

  @override
  String numberOfWishs(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wishs',
      one: '1 wish',
      zero: '0 wish',
    );
    return '$_temp0';
  }

  @override
  String get friendDetailsMutualFriendsTitle => 'Amis en commun';

  @override
  String get friendDetailsNoMutualFriends => 'Aucun ami en commun';

  @override
  String get friendDetailsWishlistsTitle => 'Wishlists publiques';

  @override
  String get myWishlists => 'Mes wishlists';

  @override
  String get wishlistStatusPending => 'En attente';

  @override
  String get wishlistStatusBooked => 'Réservés';

  @override
  String get wishlistSearchHint => 'Rechercher un wish...';

  @override
  String get wishlistNoWish => 'Aucun wish';

  @override
  String get wishlistNoWishBooked => 'Aucun wish réservé';

  @override
  String get wishlistNoWishBookedDisplayed =>
      'Vous avez choisi de ne pas afficher les wishs réservés';

  @override
  String get wishlistAddWish => 'Ajouter un wish';

  @override
  String get createWishBottomSheetTitle => 'Créer un wish';

  @override
  String get createWishSuccess => 'Wish créé avec succès';

  @override
  String get editWishBottomSheetTitle => 'Modifier un wish';

  @override
  String get deleteWish => 'Supprimer le wish';

  @override
  String get deleteWishConfirmationMessage =>
      'Es-tu sûr(e) de vouloir supprimer ce wish ?';

  @override
  String get deleteWishSuccess => 'Wish supprimé avec succès';

  @override
  String get editButton => 'Modifier';

  @override
  String get wishNameLabel => 'Nom';

  @override
  String get wishPriceLabel => 'Prix';

  @override
  String get wishQuantityLabel => 'Quantité';

  @override
  String get wishLinkLabel => 'Lien';

  @override
  String get wishDescriptionLabel => 'Description';

  @override
  String get wishImageLabel => 'Image du wish';

  @override
  String get uploadImage => 'Ajouter une image';

  @override
  String get wishNameError => 'Le nom du wish est requis';

  @override
  String get notNullError => 'Ce champ est requis';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String numberRangeError(Object max, Object min) {
    return 'Saisissez un nombre entre $min et $max';
  }

  @override
  String get openLink => 'Ouvrir le lien';

  @override
  String get linkNotValid => 'Le lien n\'est pas valide';

  @override
  String get iWantToGiveIt => 'Je veux l\'offrir';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get wishlistVisibility => 'Visibilité de la wishlist';

  @override
  String get private => 'Privée';

  @override
  String get public => 'Publique';

  @override
  String get seeTakenWishs => 'Voir les wishs réservés';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get wishlistSharedWith => 'Wishlist partagée avec';

  @override
  String get addCollaborator => 'Ajouter un collaborateur';

  @override
  String get save => 'Enregistrer';

  @override
  String get updateSuccess => 'Mise à jour effectuée avec succès';

  @override
  String get deleteWishlist => 'Supprimer ma wishlist';

  @override
  String get deleteWishlistConfirmation =>
      'Es-tu sûr(e) de vouloir supprimer cette wishlist ?';

  @override
  String get deleteWishlistWishesWarning =>
      'Les wishs seront également supprimés.';

  @override
  String get deleteWishlistSuccess => 'Wishlist supprimée avec succès';

  @override
  String get wishlistColor => 'Couleur de la wishlist';

  @override
  String get sortWishs => 'Trier les wishs';

  @override
  String get sortByFavorite => 'Par favoris';

  @override
  String get sortByAlphabetical => 'Par ordre alphabétique';

  @override
  String get sortByPrice => 'Par prix';

  @override
  String get sortByDate => 'Par date de création';

  @override
  String get selectQuantityToGive => 'Quelle quantité souhaitez-vous offrir ?';

  @override
  String get wishReservedSuccess => 'Wish réservé avec succès !';

  @override
  String quantityCannotBeLowerThanBooked(Object bookedQuantity) {
    return 'La quantité ne peut pas être inférieure à $bookedQuantity (quantité déjà réservée)';
  }

  @override
  String get avatarOptions => 'Modification de l\'avatar';

  @override
  String get chooseFromGallery => 'Choisir depuis la galerie';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get imageOptions => 'Modification de l\'image';

  @override
  String get removeImage => 'Supprimer l\'image';

  @override
  String get removeImageConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette image ?';

  @override
  String get avatarLoadError => 'Erreur lors du chargement de l\'image';

  @override
  String get forgotPasswordButton => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordDescription =>
      'Veuillez saisir votre adresse e-mail afin de recevoir le lien de réinitialisation de votre mot de passe.';

  @override
  String get forgotPasswordSendButton => 'Envoyer';

  @override
  String get forgotPasswordEmailSent =>
      'Un e-mail de réinitialisation a été envoyé !';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordDescription =>
      'Saisissez votre nouveau mot de passe.';

  @override
  String get resetPasswordConfirm => 'Réinitialiser';

  @override
  String get resetPasswordSuccess =>
      'Mot de passe réinitialisé avec succès ! Reconnectez-vous avec votre nouveau mot de passe.';

  @override
  String get resetPasswordLinkExpired =>
      'Le lien de réinitialisation a expiré. Veuillez en demander un nouveau.';
}
