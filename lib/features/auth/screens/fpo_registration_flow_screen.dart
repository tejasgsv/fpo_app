import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../services/registration_service.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/status_chip.dart';
import '../widgets/stepper_header.dart';
import '../widgets/upload_card.dart';
import '../widgets/section_header.dart';

class FpoRegistrationFlowScreen extends StatefulWidget {
  const FpoRegistrationFlowScreen({
    super.key,
    required this.registrationService,
    this.initialStep = 0,
  });

  final RegistrationService registrationService;
  final int initialStep;

  @override
  State<FpoRegistrationFlowScreen> createState() => _FpoRegistrationFlowScreenState();
}

class _FpoRegistrationFlowScreenState extends State<FpoRegistrationFlowScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _basicInfoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _contactKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _reviewKey = GlobalKey<FormState>();

  final TextEditingController _fpoNameController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final List<String> _states = const [
    AppStrings.statePunjab,
    AppStrings.stateSindh,
    AppStrings.stateKpk,
    AppStrings.stateBalochistan,
    AppStrings.stateIslamabad,
  ];

  final Map<String, List<String>> _districtsByState = const {
    AppStrings.statePunjab: ['Lahore', 'Multan', 'Faisalabad'],
    AppStrings.stateSindh: ['Karachi', 'Hyderabad', 'Sukkur'],
    AppStrings.stateKpk: ['Peshawar', 'Mardan', 'Swat'],
    AppStrings.stateBalochistan: ['Quetta', 'Khuzdar', 'Gwadar'],
    AppStrings.stateIslamabad: ['Islamabad'],
  };

  int _currentStep = 0;
  String? _selectedState;
  String? _selectedDistrict;
  String? _certificateFileName;
  String? _additionalDocumentFileName;
  bool _otpSending = false;
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _confirmDetails = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(0, 3);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentStep);
    });
    _fpoNameController.addListener(_refreshUi);
    _registrationNumberController.addListener(_refreshUi);
    _addressController.addListener(_refreshUi);
    _mobileController.addListener(_refreshUi);
    _otpController.addListener(_refreshUi);
  }

  @override
  void dispose() {
    _fpoNameController.removeListener(_refreshUi);
    _registrationNumberController.removeListener(_refreshUi);
    _addressController.removeListener(_refreshUi);
    _mobileController.removeListener(_refreshUi);
    _otpController.removeListener(_refreshUi);
    _fpoNameController.dispose();
    _registrationNumberController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _refreshUi() {
    if (mounted) {
      setState(() {});
    }
  }

  List<String> get _districtOptions {
    return _districtsByState[_selectedState] ?? const [];
  }

  bool get _step1Ready {
    return _fpoNameController.text.trim().isNotEmpty &&
        _registrationNumberController.text.trim().isNotEmpty &&
        _selectedState != null &&
        _selectedDistrict != null &&
        _addressController.text.trim().isNotEmpty;
  }

  bool get _step2Ready {
    return AppValidators.mobile(_mobileController.text) == null &&
        _otpSent &&
        _otpVerified;
  }

  bool get _step3Ready {
    return _certificateFileName != null;
  }

  bool get _step4Ready {
    return _confirmDetails && _certificateFileName != null;
  }

  Future<void> _goToStep(int step) async {
    setState(() {
      _currentStep = step.clamp(0, 3);
    });
    await _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendOtp() async {
    if (AppValidators.mobile(_mobileController.text) != null) {
      _contactKey.currentState?.validate();
      return;
    }

    setState(() {
      _otpSending = true;
      _otpSent = false;
      _otpVerified = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _otpSending = false;
      _otpSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.otpSent)),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.trim().length != AppConstants.otpLength) {
      _contactKey.currentState?.validate();
      return;
    }

    setState(() {
      _otpVerified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.verified)),
    );
  }

  Future<void> _pickMockFile({required bool isPrimary}) async {
    final selectedFile = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text(AppStrings.chooseMockCertificate),
                onTap: () => Navigator.of(context).pop(AppStrings.chooseMockCertificate),
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text(AppStrings.chooseMockDocument),
                onTap: () => Navigator.of(context).pop(AppStrings.chooseMockDocument),
              ),
            ],
          ),
        );
      },
    );

    if (selectedFile == null || !mounted) {
      return;
    }

    setState(() {
      if (isPrimary) {
        _certificateFileName = selectedFile;
      } else {
        _additionalDocumentFileName = selectedFile;
      }
    });
  }

  Future<void> _submit() async {
    if (!_reviewKey.currentState!.validate() || !_confirmDetails) {
      setState(() {});
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final receipt = await widget.registrationService.submit(
        RegistrationSubmission(
          fpoName: _fpoNameController.text.trim(),
          registrationNumber: _registrationNumberController.text.trim(),
          state: _selectedState ?? '',
          district: _selectedDistrict ?? '',
          address: _addressController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          certificateName: _certificateFileName ?? '',
          additionalDocumentName: _additionalDocumentFileName,
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.registrationSubmitted} • ${receipt.applicationId}')),
      );

      Navigator.of(context).pushReplacementNamed(AppRoutes.success);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.submitFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerFpo),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.registerFpo,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            const Text(AppStrings.registrationIntro),
                            const SizedBox(height: 20),
                            StepperHeader(
                              currentStep: _currentStep,
                              labels: const [
                                AppStrings.basicInfoStep,
                                AppStrings.contactOtpStep,
                                AppStrings.documentsStep,
                                AppStrings.reviewStep,
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: constraints.maxHeight > 0 ? constraints.maxHeight - 140 : 760,
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStepOne(context),
                            _buildStepTwo(context),
                            _buildStepThree(context),
                            _buildStepFour(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepOne(BuildContext context) {
    return Form(
      key: _basicInfoKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: AppStrings.basicInfoStep,
              subtitle: AppStrings.basicInfoSubtitle,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _fpoNameController,
              labelText: AppStrings.fpoNameLabel,
              hintText: AppStrings.fpoNameHint,
              validator: AppValidators.requiredValue,
              prefixIcon: Icons.apartment_outlined,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _registrationNumberController,
              labelText: AppStrings.registrationNumberLabel,
              hintText: AppStrings.registrationNumberHint,
              validator: AppValidators.requiredValue,
              prefixIcon: Icons.confirmation_number_outlined,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: const InputDecoration(labelText: AppStrings.stateLabel),
              items: _states
                  .map((state) => DropdownMenuItem<String>(value: state, child: Text(state)))
                  .toList(),
              validator: (value) => value == null ? AppStrings.requiredFieldError : null,
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedDistrict = null;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: const InputDecoration(labelText: AppStrings.districtLabel),
              items: _districtOptions
                  .map((district) => DropdownMenuItem<String>(value: district, child: Text(district)))
                  .toList(),
              validator: (value) => value == null ? AppStrings.requiredFieldError : null,
              onChanged: _selectedState == null
                  ? null
                  : (value) {
                      setState(() {
                        _selectedDistrict = value;
                      });
                    },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _addressController,
              labelText: AppStrings.addressLabel,
              hintText: AppStrings.addressHint,
              validator: AppValidators.requiredValue,
              prefixIcon: Icons.location_on_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: AppStrings.next,
                    onPressed: _step1Ready
                        ? () {
                            if (_basicInfoKey.currentState!.validate()) {
                              _goToStep(1);
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTwo(BuildContext context) {
    return Form(
      key: _contactKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: AppStrings.contactOtpStep,
              subtitle: AppStrings.contactSubtitle,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                StatusChip(label: _otpSending ? AppStrings.sendingOtp : AppStrings.otpSent, isActive: _otpSent),
                const SizedBox(width: 8),
                StatusChip(label: AppStrings.verified, isActive: _otpVerified),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _mobileController,
              labelText: AppStrings.mobileLabel,
              hintText: AppStrings.mobileHint,
              validator: AppValidators.mobile,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: _otpSending ? AppStrings.sendingOtp : AppStrings.sendOtp,
              isBusy: _otpSending,
              onPressed: _otpSending || _otpVerified ? null : _sendOtp,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _otpController,
              labelText: AppStrings.otpLabel,
              hintText: AppStrings.otpHint,
              validator: AppValidators.otp,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.pin_outlined,
            ),
            const SizedBox(height: 8),
            const Text(AppStrings.otpVerificationHint),
            const SizedBox(height: 12),
            PrimaryButton(
              label: AppStrings.verifyOtp,
              onPressed: _otpSent && !_otpVerified ? _verifyOtp : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: AppStrings.previous,
                    onPressed: () => _goToStep(0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: AppStrings.next,
                    onPressed: _step2Ready
                        ? () {
                            _goToStep(2);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepThree(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: AppStrings.documentsStep,
              subtitle: AppStrings.documentsSubtitle,
          ),
          const SizedBox(height: 16),
          UploadCard(
            title: AppStrings.uploadCertificate,
            description: AppStrings.uploadHint,
            fileName: _certificateFileName,
            onPressed: () => _pickMockFile(isPrimary: true),
          ),
          const SizedBox(height: 12),
          UploadCard(
            title: AppStrings.additionalDocument,
            description: AppStrings.additionalDocumentOptional,
            fileName: _additionalDocumentFileName,
            onPressed: () => _pickMockFile(isPrimary: false),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: AppStrings.previous,
                  onPressed: () => _goToStep(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: AppStrings.next,
                  onPressed: _step3Ready
                      ? () {
                          _goToStep(3);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepFour(BuildContext context) {
    return Form(
      key: _reviewKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: AppStrings.reviewTitle,
              subtitle: AppStrings.reviewSubtitle,
            ),
            const SizedBox(height: 16),
            AppCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryRow(label: AppStrings.fpoNameLabel, value: _fpoNameController.text.trim()),
                  _SummaryRow(label: AppStrings.registrationNumberLabel, value: _registrationNumberController.text.trim()),
                  _SummaryRow(label: AppStrings.stateLabel, value: _selectedState ?? '-'),
                  _SummaryRow(label: AppStrings.districtLabel, value: _selectedDistrict ?? '-'),
                  _SummaryRow(label: AppStrings.addressLabel, value: _addressController.text.trim()),
                  _SummaryRow(label: AppStrings.mobileLabel, value: _mobileController.text.trim()),
                  _SummaryRow(label: AppStrings.uploadCertificate, value: _certificateFileName ?? '-'),
                  _SummaryRow(label: AppStrings.additionalDocument, value: _additionalDocumentFileName ?? 'Not added'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _confirmDetails,
              onChanged: (value) {
                setState(() {
                  _confirmDetails = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text(AppStrings.confirmCorrect),
            ),
            const SizedBox(height: 12),
            StatusChip(label: AppStrings.pendingApproval, isActive: true),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: AppStrings.previous,
                    onPressed: () => _goToStep(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: AppStrings.submit,
                    isLoading: _submitting,
                    onPressed: _step4Ready && !_submitting ? _submit : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? '-' : value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
