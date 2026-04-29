import '../../../core/state/platform_store.dart';

class RegistrationSubmission {
  const RegistrationSubmission({
    required this.fpoName,
    required this.registrationNumber,
    required this.state,
    required this.district,
    required this.address,
    required this.mobileNumber,
    required this.certificateName,
    required this.additionalDocumentName,
  });

  final String fpoName;
  final String registrationNumber;
  final String state;
  final String district;
  final String address;
  final String mobileNumber;
  final String certificateName;
  final String? additionalDocumentName;
}

class RegistrationReceipt {
  const RegistrationReceipt({
    required this.applicationId,
    required this.status,
  });

  final String applicationId;
  final String status;
}

abstract class RegistrationService {
  Future<RegistrationReceipt> submit(RegistrationSubmission submission);
}

class MockRegistrationService implements RegistrationService {
  MockRegistrationService({required this.platformStore});

  final PlatformStore platformStore;

  @override
  Future<RegistrationReceipt> submit(RegistrationSubmission submission) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    final application = platformStore.upsertApplication(
      fpoName: submission.fpoName,
      registrationNumber: submission.registrationNumber,
      state: submission.state,
      district: submission.district,
      address: submission.address,
      mobileNumber: submission.mobileNumber,
      certificateName: submission.certificateName,
      additionalDocumentName: submission.additionalDocumentName,
    );
    return RegistrationReceipt(
      applicationId: application.id,
      status: 'Pending Approval',
    );
  }
}
