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
  @override
  Future<RegistrationReceipt> submit(RegistrationSubmission submission) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    return RegistrationReceipt(
      applicationId: 'APP-${DateTime.now().millisecondsSinceEpoch}',
      status: 'Pending Approval',
    );
  }
}
