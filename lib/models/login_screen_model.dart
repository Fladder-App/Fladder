// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fladder/models/account_model.dart';
import 'package:fladder/models/credentials_model.dart';

class LoginScreenModel {
  final List<AccountModel> accounts;
  final CredentialsModel tempCredentials;
  final bool loading;
  LoginScreenModel({
    required this.accounts,
    required this.tempCredentials,
    required this.loading,
  });

  LoginScreenModel copyWith({
    List<AccountModel>? accounts,
    CredentialsModel? tempCredentials,
    bool? loading,
  }) {
    return LoginScreenModel(
      accounts: accounts ?? this.accounts,
      tempCredentials: tempCredentials ?? this.tempCredentials,
      loading: loading ?? this.loading,
    );
  }
}
