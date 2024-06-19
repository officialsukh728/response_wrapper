part of 'privacy_policy_bloc.dart';

class PrivacyPolicyState extends Equatable {
  final CommonAuthModel? modelPrivacyPolicy;
  final CommonAuthModel? modelTermsOfUse;
  final CommonAuthModel? modelAboutUs;
  final bool loadingPrivacyPolicy;
  final bool loadingTermsOfUse;
  final bool loadingAboutUs;

  const PrivacyPolicyState({
    this.modelPrivacyPolicy,
    this.modelTermsOfUse,
    this.modelAboutUs,
    this.loadingPrivacyPolicy = false,
    this.loadingTermsOfUse = false,
    this.loadingAboutUs = false,
  });

  PrivacyPolicyState copyWith({
    CommonAuthModel? modelPrivacyPolicy,
    CommonAuthModel? modelTermsOfUse,
    CommonAuthModel? modelAboutUs,
    bool? loadingPrivacyPolicy,
    bool? loadingTermsOfUse,
    bool? loadingAboutUs,
  }) {
    return PrivacyPolicyState(
      modelPrivacyPolicy: modelPrivacyPolicy ?? this.modelPrivacyPolicy,
      modelTermsOfUse: modelTermsOfUse ?? this.modelTermsOfUse,
      modelAboutUs: modelAboutUs ?? this.modelAboutUs,
      loadingPrivacyPolicy: loadingPrivacyPolicy ?? this.loadingPrivacyPolicy,
      loadingTermsOfUse: loadingTermsOfUse ?? this.loadingTermsOfUse,
      loadingAboutUs: loadingAboutUs ?? this.loadingAboutUs,
    );
  }

  @override
  List<Object?> get props => [
    modelPrivacyPolicy,
    modelTermsOfUse,
    modelAboutUs,
    loadingPrivacyPolicy,
    loadingTermsOfUse,
    loadingAboutUs,
  ];
}

