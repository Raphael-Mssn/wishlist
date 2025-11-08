import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/repositories/wishlist/wishlist_streams_providers.dart';
import 'package:wishlist/shared/infra/wish_mutations_provider.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/theme/utils/get_wishlist_theme.dart';
import 'package:wishlist/shared/theme/widgets/app_wave_pattern.dart';
import 'package:wishlist/shared/theme/widgets/buttons.dart';
import 'package:wishlist/shared/utils/app_snackbar.dart';
import 'package:wishlist/shared/widgets/text_form_fields/validators/not_null_validator.dart';

/// Formatter qui permet la saisie avec virgule ou point
/// pour les nombres décimaux
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Permet uniquement les chiffres, point et virgule
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    // Vérifie que le texte ne contient que des chiffres, point ou virgule
    if (!RegExp(r'^[0-9.,]*$').hasMatch(text)) {
      return oldValue;
    }

    // Permet un seul séparateur décimal (point ou virgule)
    final commaCount = ','.allMatches(text).length;
    final dotCount = '.'.allMatches(text).length;
    if (commaCount + dotCount > 1) {
      return oldValue;
    }

    return newValue;
  }
}

class CreateWishScreen extends ConsumerStatefulWidget {
  const CreateWishScreen({
    super.key,
    required this.wishlistId,
  });

  final int wishlistId;

  @override
  ConsumerState<CreateWishScreen> createState() => _CreateWishScreenState();
}

class _CreateWishScreenState extends ConsumerState<CreateWishScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameInputController = TextEditingController();
  final _priceInputController = TextEditingController();
  final _quantityInputController = TextEditingController(text: '1');
  final _linkInputController = TextEditingController();
  final _descriptionInputController = TextEditingController();

  bool _isFavourite = false;
  bool _isLoading = false;

  Future<void> onCreateWish() async {
    if (!_formKey.currentState!.validate()) {
      showAppSnackBar(
        context,
        context.l10n.wishNameError,
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final wishlistAsync =
        ref.read(watchWishlistByIdProvider(widget.wishlistId));

    wishlistAsync.whenData((wishlist) async {
      final name = _nameInputController.text;
      final price = _priceInputController.text.replaceAll(',', '.');
      final quantity = _quantityInputController.text;
      final link = _linkInputController.text;
      final description = _descriptionInputController.text;

      final wish = WishCreateRequest(
        name: name,
        price: double.tryParse(price),
        quantity: int.tryParse(quantity),
        description: description,
        wishlistId: widget.wishlistId,
        updatedBy: wishlist.idOwner,
        linkUrl: link,
        isFavourite: _isFavourite,
      );

      try {
        await ref.read(wishMutationsProvider.notifier).create(wish);

        if (mounted) {
          showAppSnackBar(
            context,
            context.l10n.createWishSuccess,
            type: SnackBarType.success,
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          showGenericError(context);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _pasteLink() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      setState(() {
        _linkInputController.text = clipboardData!.text!;
      });
    }
  }

  Future<void> _openLink() async {
    final link = _linkInputController.text.trim();
    if (link.isEmpty) {
      showAppSnackBar(
        context,
        context.l10n.linkNotValid,
        type: SnackBarType.error,
      );
      return;
    }

    try {
      final uri = Uri.parse(link);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        showAppSnackBar(
          context,
          context.l10n.linkNotValid,
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameInputController.dispose();
    _priceInputController.dispose();
    _quantityInputController.dispose();
    _linkInputController.dispose();
    _descriptionInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wishlistAsync =
        ref.watch(watchWishlistByIdProvider(widget.wishlistId));

    return wishlistAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
        ),
        body: Center(
          child: Text(l10n.genericError),
        ),
      ),
      data: (wishlist) {
        final wishlistTheme = getWishlistTheme(context, wishlist);

        return Theme(
          data: wishlistTheme,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                child: AppWavePattern(
                  backgroundColor: wishlistTheme.primaryColor,
                  preset: WavePreset.appBar,
                  rotationType: WaveRotationType.fixed,
                  rotationAngle: 45,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        l10n.createWishBottomSheetTitle,
                        style: AppTextStyles.medium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: LikeButton(
                          isLiked: _isFavourite,
                          size: 32,
                          likeBuilder: (isLiked) {
                            return Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: AppColors.background,
                              size: 32,
                            );
                          },
                          onTap: (isLiked) async {
                            setState(() {
                              _isFavourite = !isLiked;
                            });
                            return !isLiked;
                          },
                        ),
                      ),
                    ],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Gap(8),
                            _buildModernTextField(
                              controller: _nameInputController,
                              label: l10n.wishNameLabel,
                              icon: Icons.sell_outlined,
                              validator: (value) =>
                                  notNullValidator(value, l10n),
                            ),
                            const Gap(16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildModernTextField(
                                    controller: _priceInputController,
                                    label: l10n.wishPriceLabel,
                                    icon: Icons.attach_money,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    inputFormatters: [
                                      DecimalTextInputFormatter(),
                                    ],
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: _buildModernTextField(
                                    controller: _quantityInputController,
                                    label: l10n.wishQuantityLabel,
                                    icon: Icons.one_x_mobiledata,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            _buildModernTextField(
                              controller: _linkInputController,
                              label: l10n.wishLinkLabel,
                              icon: Icons.link,
                              keyboardType: TextInputType.url,
                              suffixButtons: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.content_paste,
                                      size: 20,
                                    ),
                                    onPressed: _pasteLink,
                                    tooltip: 'Coller',
                                    color: AppColors.makara,
                                  ),
                                ),
                                const Gap(8),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.open_in_new,
                                      size: 20,
                                    ),
                                    onPressed: _openLink,
                                    tooltip: 'Ouvrir',
                                    color: AppColors.makara,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            _buildModernTextField(
                              controller: _descriptionInputController,
                              label: l10n.wishDescriptionLabel,
                              icon: Icons.description_outlined,
                              maxLines: 4,
                              minLines: 4,
                            ),
                            const Gap(16),
                            _buildImageUploadField(l10n),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PrimaryButton(
                      text: l10n.createButton,
                      onPressed: _isLoading ? null : onCreateWish,
                      style: BaseButtonStyle.large,
                      isStretched: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
    int? minLines,
    List<Widget>? suffixButtons,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: maxLines != null && maxLines > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: maxLines != null && maxLines > 1 ? 12 : 0,
              ),
              child: Icon(
                icon,
                color: AppColors.makara,
                size: 24,
              ),
            ),
            const Gap(12),
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                maxLines: maxLines ?? 1,
                minLines: minLines ?? 1,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.darkGrey,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppTextStyles.small.copyWith(
                    color: AppColors.makara,
                  ),
                  alignLabelWithHint: maxLines != null && maxLines > 1,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    right: suffixButtons != null && suffixButtons.isNotEmpty
                        ? 8
                        : 0,
                  ),
                ),
              ),
            ),
            if (suffixButtons != null && suffixButtons.isNotEmpty) ...[
              ...suffixButtons,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadField(AppLocalizations l10n) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.gainsboro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Implémenter l'upload d'image
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: AppColors.makara.withValues(alpha: 0.6),
              ),
              const Gap(12),
              Text(
                l10n.uploadImage,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.makara,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
