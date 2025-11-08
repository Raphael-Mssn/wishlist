import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Wishlist'**
  String get appTitle;

  /// No description provided for @emailField.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailField;

  /// No description provided for @validEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir une adresse e-mail valide'**
  String get validEmailError;

  /// No description provided for @passwordField.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordField;

  /// No description provided for @passwordLengthError.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get passwordLengthError;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas de compte ?\nCréez-en un !'**
  String get dontHaveAccount;

  /// No description provided for @haveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà un compte ?\nConnectez-vous !'**
  String get haveAccount;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In fr, this message translates to:
  /// **'Identifiants de connexion invalides'**
  String get invalidLoginCredentials;

  /// No description provided for @userAlreadyRegistered.
  ///
  /// In fr, this message translates to:
  /// **'Cet email est déjà enregistré'**
  String get userAlreadyRegistered;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue, veuillez réessayer'**
  String get genericError;

  /// No description provided for @pseudoField.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get pseudoField;

  /// No description provided for @validPseudoError.
  ///
  /// In fr, this message translates to:
  /// **'Le pseudo ne peut pas être vide'**
  String get validPseudoError;

  /// No description provided for @pseudoAlreadyExists.
  ///
  /// In fr, this message translates to:
  /// **'Ce pseudo est déjà utilisé'**
  String get pseudoAlreadyExists;

  /// No description provided for @savePseudo.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get savePseudo;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsScreenTitle;

  /// No description provided for @settingsScreenEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get settingsScreenEmail;

  /// No description provided for @settingsScreenEmailModify.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get settingsScreenEmailModify;

  /// No description provided for @settingsScreenDisconnect.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get settingsScreenDisconnect;

  /// No description provided for @settingsScreenDisconnectDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get settingsScreenDisconnectDialogTitle;

  /// No description provided for @settingsScreenDisconnectDialogExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get settingsScreenDisconnectDialogExplanation;

  /// No description provided for @settingsScreenPasswordModify.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon mot de passe'**
  String get settingsScreenPasswordModify;

  /// No description provided for @settingsScreenPseudoModify.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon pseudo'**
  String get settingsScreenPseudoModify;

  /// No description provided for @changePasswordScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get changePasswordScreenTitle;

  /// No description provided for @oldPasswordField.
  ///
  /// In fr, this message translates to:
  /// **'Ancien mot de passe'**
  String get oldPasswordField;

  /// No description provided for @newPasswordField.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordField;

  /// No description provided for @confirmNewPasswordField.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le nouveau mot de passe'**
  String get confirmNewPasswordField;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDoNotMatch;

  /// No description provided for @oldPasswordIncorrect.
  ///
  /// In fr, this message translates to:
  /// **'Ancien mot de passe incorrect'**
  String get oldPasswordIncorrect;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get changePasswordConfirm;

  /// No description provided for @newPasswordShouldBeDifferent.
  ///
  /// In fr, this message translates to:
  /// **'Le nouveau mot de passe doit être différent de l\'ancien'**
  String get newPasswordShouldBeDifferent;

  /// No description provided for @changePseudoScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get changePseudoScreenTitle;

  /// No description provided for @newPseudoField.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau pseudo'**
  String get newPseudoField;

  /// No description provided for @changePseudoConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get changePseudoConfirm;

  /// No description provided for @changePseudoSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo modifié avec succès'**
  String get changePseudoSuccess;

  /// No description provided for @settingsScreenDeleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get settingsScreenDeleteAccount;

  /// No description provided for @confirmDialogConfirmButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get confirmDialogConfirmButtonLabel;

  /// No description provided for @noWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Aucune wishlist'**
  String get noWishlist;

  /// No description provided for @createButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get createButton;

  /// No description provided for @createWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Créer une wishlist'**
  String get createWishlist;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @cancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelButton;

  /// No description provided for @closeDialog.
  ///
  /// In fr, this message translates to:
  /// **'Fermer la fenêtre contextuelle'**
  String get closeDialog;

  /// No description provided for @fiendsScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Amis'**
  String get fiendsScreenTitle;

  /// No description provided for @noFriend.
  ///
  /// In fr, this message translates to:
  /// **'Aucun ami'**
  String get noFriend;

  /// No description provided for @addButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addButton;

  /// No description provided for @emailOrPseudoHint.
  ///
  /// In fr, this message translates to:
  /// **'Email ou pseudo'**
  String get emailOrPseudoHint;

  /// No description provided for @noUserFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur trouvé'**
  String get noUserFound;

  /// No description provided for @friendDetailsRemove.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get friendDetailsRemove;

  /// No description provided for @removeFriendConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Es-tu sûr(e) de vouloir supprimer cet ami ?'**
  String get removeFriendConfirmation;

  /// No description provided for @removeFriendSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Ami supprimé avec succès'**
  String get removeFriendSuccess;

  /// No description provided for @numberOfWishlists.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0 {0 wishlist} =1 {1 wishlist} other {{count} wishlists}}'**
  String numberOfWishlists(num count);

  /// No description provided for @numberOfWishs.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0 {0 wish} =1 {1 wish} other {{count} wishs}}'**
  String numberOfWishs(num count);

  /// No description provided for @friendDetailsMutualFriendsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Amis en commun'**
  String get friendDetailsMutualFriendsTitle;

  /// No description provided for @friendDetailsNoMutualFriends.
  ///
  /// In fr, this message translates to:
  /// **'Aucun ami en commun'**
  String get friendDetailsNoMutualFriends;

  /// No description provided for @friendDetailsWishlistsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Wishlists publiques'**
  String get friendDetailsWishlistsTitle;

  /// No description provided for @myWishlists.
  ///
  /// In fr, this message translates to:
  /// **'Mes wishlists'**
  String get myWishlists;

  /// No description provided for @wishlistStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get wishlistStatusPending;

  /// No description provided for @wishlistStatusBooked.
  ///
  /// In fr, this message translates to:
  /// **'Réservés'**
  String get wishlistStatusBooked;

  /// No description provided for @wishlistSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un wish...'**
  String get wishlistSearchHint;

  /// No description provided for @wishlistNoWish.
  ///
  /// In fr, this message translates to:
  /// **'Aucun wish'**
  String get wishlistNoWish;

  /// No description provided for @wishlistNoWishBooked.
  ///
  /// In fr, this message translates to:
  /// **'Aucun wish réservé'**
  String get wishlistNoWishBooked;

  /// No description provided for @wishlistNoWishBookedDisplayed.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez choisi de ne pas afficher les wishs réservés'**
  String get wishlistNoWishBookedDisplayed;

  /// No description provided for @wishlistAddWish.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un wish'**
  String get wishlistAddWish;

  /// No description provided for @createWishBottomSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un wish'**
  String get createWishBottomSheetTitle;

  /// No description provided for @createWishSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Wish créé avec succès'**
  String get createWishSuccess;

  /// No description provided for @editWishBottomSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier un wish'**
  String get editWishBottomSheetTitle;

  /// No description provided for @deleteWish.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le wish'**
  String get deleteWish;

  /// No description provided for @deleteWishConfirmationMessage.
  ///
  /// In fr, this message translates to:
  /// **'Es-tu sûr(e) de vouloir supprimer ce wish ?'**
  String get deleteWishConfirmationMessage;

  /// No description provided for @deleteWishSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Wish supprimé avec succès'**
  String get deleteWishSuccess;

  /// No description provided for @editButton.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editButton;

  /// No description provided for @wishNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get wishNameLabel;

  /// No description provided for @wishPriceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get wishPriceLabel;

  /// No description provided for @wishQuantityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get wishQuantityLabel;

  /// No description provided for @wishLinkLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lien'**
  String get wishLinkLabel;

  /// No description provided for @wishDescriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get wishDescriptionLabel;

  /// No description provided for @wishImageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Image du wish'**
  String get wishImageLabel;

  /// No description provided for @uploadImage.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une image'**
  String get uploadImage;

  /// No description provided for @wishNameError.
  ///
  /// In fr, this message translates to:
  /// **'Le nom du wish est requis'**
  String get wishNameError;

  /// No description provided for @notNullError.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est requis'**
  String get notNullError;

  /// No description provided for @invalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get invalidNumber;

  /// No description provided for @numberRangeError.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez un nombre entre {min} et {max}'**
  String numberRangeError(Object max, Object min);

  /// No description provided for @openLink.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le lien'**
  String get openLink;

  /// No description provided for @linkNotValid.
  ///
  /// In fr, this message translates to:
  /// **'Le lien n\'est pas valide'**
  String get linkNotValid;

  /// No description provided for @iWantToGiveIt.
  ///
  /// In fr, this message translates to:
  /// **'Je veux l\'offrir'**
  String get iWantToGiveIt;

  /// No description provided for @cancelBooking.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelBooking;

  /// No description provided for @wishlistVisibility.
  ///
  /// In fr, this message translates to:
  /// **'Visibilité de la wishlist'**
  String get wishlistVisibility;

  /// No description provided for @private.
  ///
  /// In fr, this message translates to:
  /// **'Privée'**
  String get private;

  /// No description provided for @public.
  ///
  /// In fr, this message translates to:
  /// **'Publique'**
  String get public;

  /// No description provided for @seeTakenWishs.
  ///
  /// In fr, this message translates to:
  /// **'Voir les wishs réservés'**
  String get seeTakenWishs;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @wishlistSharedWith.
  ///
  /// In fr, this message translates to:
  /// **'Wishlist partagée avec'**
  String get wishlistSharedWith;

  /// No description provided for @addCollaborator.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un collaborateur'**
  String get addCollaborator;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @updateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour effectuée avec succès'**
  String get updateSuccess;

  /// No description provided for @deleteWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ma wishlist'**
  String get deleteWishlist;

  /// No description provided for @deleteWishlistConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Es-tu sûr(e) de vouloir supprimer cette wishlist ?'**
  String get deleteWishlistConfirmation;

  /// No description provided for @deleteWishlistWishesWarning.
  ///
  /// In fr, this message translates to:
  /// **'Les wishs seront également supprimés.'**
  String get deleteWishlistWishesWarning;

  /// No description provided for @deleteWishlistSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Wishlist supprimée avec succès'**
  String get deleteWishlistSuccess;

  /// No description provided for @wishlistColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur de la wishlist'**
  String get wishlistColor;

  /// No description provided for @sortWishs.
  ///
  /// In fr, this message translates to:
  /// **'Trier les wishs'**
  String get sortWishs;

  /// No description provided for @sortByFavorite.
  ///
  /// In fr, this message translates to:
  /// **'Par favoris'**
  String get sortByFavorite;

  /// No description provided for @sortByAlphabetical.
  ///
  /// In fr, this message translates to:
  /// **'Par ordre alphabétique'**
  String get sortByAlphabetical;

  /// No description provided for @sortByPrice.
  ///
  /// In fr, this message translates to:
  /// **'Par prix'**
  String get sortByPrice;

  /// No description provided for @sortByDate.
  ///
  /// In fr, this message translates to:
  /// **'Par date de création'**
  String get sortByDate;

  /// No description provided for @selectQuantityToGive.
  ///
  /// In fr, this message translates to:
  /// **'Quelle quantité souhaitez-vous offrir ?'**
  String get selectQuantityToGive;

  /// No description provided for @wishReservedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Wish réservé avec succès !'**
  String get wishReservedSuccess;

  /// No description provided for @quantityCannotBeLowerThanBooked.
  ///
  /// In fr, this message translates to:
  /// **'La quantité ne peut pas être inférieure à {bookedQuantity} (quantité déjà réservée)'**
  String quantityCannotBeLowerThanBooked(Object bookedQuantity);

  /// No description provided for @avatarOptions.
  ///
  /// In fr, this message translates to:
  /// **'Modification de l\'avatar'**
  String get avatarOptions;

  /// No description provided for @chooseFromGallery.
  ///
  /// In fr, this message translates to:
  /// **'Choisir depuis la galerie'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une photo'**
  String get takePhoto;

  /// No description provided for @imageOptions.
  ///
  /// In fr, this message translates to:
  /// **'Ajout de l\'image'**
  String get imageOptions;

  /// No description provided for @removeImage.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'image'**
  String get removeImage;

  /// No description provided for @removeImageConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cette image ?'**
  String get removeImageConfirmation;

  /// No description provided for @avatarLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement de l\'image'**
  String get avatarLoadError;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir votre adresse e-mail afin de recevoir le lien de réinitialisation de votre mot de passe.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordSendButton.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get forgotPasswordSendButton;

  /// No description provided for @forgotPasswordEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Un e-mail de réinitialisation a été envoyé !'**
  String get forgotPasswordEmailSent;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre nouveau mot de passe.'**
  String get resetPasswordDescription;

  /// No description provided for @resetPasswordConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetPasswordConfirm;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe réinitialisé avec succès ! Reconnectez-vous avec votre nouveau mot de passe.'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordLinkExpired.
  ///
  /// In fr, this message translates to:
  /// **'Le lien de réinitialisation a expiré. Veuillez en demander un nouveau.'**
  String get resetPasswordLinkExpired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
