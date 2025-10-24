// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wishlist';

  @override
  String get emailField => 'Email';

  @override
  String get validEmailError => 'Please enter a valid email address';

  @override
  String get passwordField => 'Password';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get dontHaveAccount => 'Don\'t have an account ?\nCreate one !';

  @override
  String get haveAccount => 'Already have an account ?\nSign in !';

  @override
  String get invalidLoginCredentials => 'Invalid login credentials';

  @override
  String get userAlreadyRegistered => 'This email is already registered';

  @override
  String get genericError => 'An error occurred, please try again';

  @override
  String get pseudoField => 'Pseudo';

  @override
  String get validPseudoError => 'Pseudo cannot be empty';

  @override
  String get pseudoAlreadyExists => 'This pseudo is already used';

  @override
  String get savePseudo => 'Save';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsScreenEmail => 'Email';

  @override
  String get settingsScreenEmailModify => 'Modify';

  @override
  String get settingsScreenDisconnect => 'Disconnect';

  @override
  String get settingsScreenDisconnectDialogTitle => 'Disconnect';

  @override
  String get settingsScreenDisconnectDialogExplanation =>
      'Are you sure you want to disconnect ?';

  @override
  String get settingsScreenPasswordModify => 'Change my password';

  @override
  String get changePasswordScreenTitle => 'Password';

  @override
  String get oldPasswordField => 'Old password';

  @override
  String get newPasswordField => 'New password';

  @override
  String get confirmNewPasswordField => 'Confirm new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get oldPasswordIncorrect => 'Incorrect old password';

  @override
  String get changePasswordConfirm => 'Change';

  @override
  String get newPasswordShouldBeDifferent =>
      'New password should be different from the old one';

  @override
  String get settingsScreenDeleteAccount => 'Delete my account';

  @override
  String get confirmDialogConfirmButtonLabel => 'OK';

  @override
  String get noWishlist => 'No wishlist';

  @override
  String get createButton => 'Create';

  @override
  String get createWishlist => 'Create a wishlist';

  @override
  String get name => 'Name';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get closeDialog => 'Dismiss the contextual window';

  @override
  String get fiendsScreenTitle => 'Friends';

  @override
  String get noFriend => 'No friend';

  @override
  String get addButton => 'Add';

  @override
  String get emailOrPseudoHint => 'Email or pseudo';

  @override
  String get noUserFound => 'No user found';

  @override
  String get friendDetailsRemove => 'Remove';

  @override
  String get removeFriendConfirmation =>
      'Are you sure you want to remove this friend?';

  @override
  String get removeFriendSuccess => 'Friend removed successfully';

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
  String get friendDetailsMutualFriendsTitle => 'Mutual friends';

  @override
  String get friendDetailsNoMutualFriends => 'No mutual friends';

  @override
  String get friendDetailsWishlistsTitle => 'Public wishlists';

  @override
  String get myWishlists => 'My wishlists';

  @override
  String get wishlistStatusPending => 'Pending';

  @override
  String get wishlistStatusBooked => 'Booked';

  @override
  String get wishlistSearchHint => 'Search for a wish...';

  @override
  String get wishlistNoWish => 'No wish';

  @override
  String get wishlistNoWishBooked => 'No wish booked';

  @override
  String get wishlistNoWishBookedDisplayed =>
      'You chose not to display booked wishes';

  @override
  String get wishlistAddWish => 'Add a wish';

  @override
  String get createWishBottomSheetTitle => 'Create a wish';

  @override
  String get createWishSuccess => 'Wish created successfully';

  @override
  String get editWishBottomSheetTitle => 'Edit a wish';

  @override
  String get deleteWish => 'Delete wish';

  @override
  String get deleteWishConfirmationMessage =>
      'Are you sure you want to delete this wish?';

  @override
  String get deleteWishSuccess => 'Wish deleted successfully';

  @override
  String get editButton => 'Edit';

  @override
  String get wishNameLabel => 'Name';

  @override
  String get wishPriceLabel => 'Price';

  @override
  String get wishQuantityLabel => 'Quantity';

  @override
  String get wishLinkLabel => 'Link';

  @override
  String get wishDescriptionLabel => 'Description';

  @override
  String get wishNameError => 'Wish name is required';

  @override
  String get notNullError => 'This field is required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String numberRangeError(Object max, Object min) {
    return 'Enter a number between $min and $max';
  }

  @override
  String get openLink => 'Open link';

  @override
  String get linkNotValid => 'The link is not valid';

  @override
  String get iWantToGiveIt => 'I want to give it';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get wishlistVisibility => 'Wishlist visibility';

  @override
  String get private => 'Private';

  @override
  String get public => 'Public';

  @override
  String get seeTakenWishs => 'See taken wishes';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get wishlistSharedWith => 'Wishlist shared with';

  @override
  String get addCollaborator => 'Add a collaborator';

  @override
  String get save => 'Save';

  @override
  String get updateSuccess => 'Update successfully completed';

  @override
  String get deleteWishlist => 'Delete my wishlist';

  @override
  String get deleteWishlistConfirmation =>
      'Are you sure you want to delete this wishlist?';

  @override
  String get deleteWishlistWishesWarning => 'Wishes will also be deleted.';

  @override
  String get deleteWishlistSuccess => 'Wishlist successfully deleted';

  @override
  String get wishlistColor => 'Wishlist color';

  @override
  String get sortWishs => 'Sort wishes';

  @override
  String get sortByFavorite => 'By favorites';

  @override
  String get sortByAlphabetical => 'By alphabetical order';

  @override
  String get sortByPrice => 'By price';

  @override
  String get sortByDate => 'By creation date';

  @override
  String get selectQuantityToGive => 'How much would you like to offer?';

  @override
  String get wishReservedSuccess => 'Wish reserved successfully!';

  @override
  String quantityCannotBeLowerThanBooked(Object bookedQuantity) {
    return 'Quantity cannot be lower than $bookedQuantity (already booked quantity)';
  }

  @override
  String get avatarOptions => 'Avatar modification';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get removeAvatar => 'Remove avatar';

  @override
  String get removeAvatarConfirmation =>
      'Are you sure you want to remove your avatar?';

  @override
  String get avatarLoadError => 'Error loading image';
}
