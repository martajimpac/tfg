// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Application`
  String get appTitle {
    return Intl.message(
      'My Application',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get pressAgainToExit {
    return Intl.message(
      'Press again to exit',
      name: 'pressAgainToExit',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred`
  String get defaultError {
    return Intl.message(
      'An error has occurred',
      name: 'defaultError',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get exito {
    return Intl.message(
      'Success',
      name: 'exito',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continuee {
    return Intl.message(
      'Continue',
      name: 'continuee',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Modify`
  String get modify {
    return Intl.message(
      'Modify',
      name: 'modify',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message(
      'Discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Show results`
  String get show_results {
    return Intl.message(
      'Show results',
      name: 'show_results',
      desc: '',
      args: [],
    );
  }

  /// `No results`
  String get no_results {
    return Intl.message(
      'No results',
      name: 'no_results',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `How would you like to complete the action?`
  String get photoDesc {
    return Intl.message(
      'How would you like to complete the action?',
      name: 'photoDesc',
      desc: '',
      args: [],
    );
  }

  /// `No evaluations`
  String get noEvaluations {
    return Intl.message(
      'No evaluations',
      name: 'noEvaluations',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to try again?`
  String get retryText {
    return Intl.message(
      'Would you like to try again?',
      name: 'retryText',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryTitle {
    return Intl.message(
      'Retry',
      name: 'retryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Observations`
  String get observationsTitle {
    return Intl.message(
      'Observations',
      name: 'observationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Category Observations`
  String get observationsCateogoryTitle {
    return Intl.message(
      'Category Observations',
      name: 'observationsCateogoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Write your observations here...`
  String get observationsDesc {
    return Intl.message(
      'Write your observations here...',
      name: 'observationsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error.`
  String get unknownError {
    return Intl.message(
      'Unknown error.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection, you will only be able to access the application to view the PDFs stored on your device.`
  String get noInternetConexion {
    return Intl.message(
      'No internet connection, you will only be able to access the application to view the PDFs stored on your device.',
      name: 'noInternetConexion',
      desc: '',
      args: [],
    );
  }

  /// `There are no PDFs available`
  String get noPdfAvaliable {
    return Intl.message(
      'There are no PDFs available',
      name: 'noPdfAvaliable',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginTitle {
    return Intl.message(
      'Login',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `user@gmail.com`
  String get hintEmail {
    return Intl.message(
      'user@gmail.com',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `***********`
  String get hintPassword {
    return Intl.message(
      '***********',
      name: 'hintPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgetPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get loginButton {
    return Intl.message(
      'Log in',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `There was an authentication error.`
  String get errorAuthentication {
    return Intl.message(
      'There was an authentication error.',
      name: 'errorAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Invalid login credentials.`
  String get errorAuthenticationCredentials {
    return Intl.message(
      'Invalid login credentials.',
      name: 'errorAuthenticationCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Email not confirmed.`
  String get errorAuthenticationNotConfirmed {
    return Intl.message(
      'Email not confirmed.',
      name: 'errorAuthenticationNotConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerButton {
    return Intl.message(
      'Register',
      name: 'registerButton',
      desc: '',
      args: [],
    );
  }

  /// `Resend email`
  String get resentEmail {
    return Intl.message(
      'Resend email',
      name: 'resentEmail',
      desc: '',
      args: [],
    );
  }

  /// `There was an error during registration.\nA user with this email already exists.`
  String get emailAlredyRegistered {
    return Intl.message(
      'There was an error during registration.\nA user with this email already exists.',
      name: 'emailAlredyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Email resent`
  String get emailResent {
    return Intl.message(
      'Email resent',
      name: 'emailResent',
      desc: '',
      args: [],
    );
  }

  /// `The email has been resent successfully.\nCheck your inbox.`
  String get emailResentDesc {
    return Intl.message(
      'The email has been resent successfully.\nCheck your inbox.',
      name: 'emailResentDesc',
      desc: '',
      args: [],
    );
  }

  /// `There was an error resending the email.`
  String get errorEmailResent {
    return Intl.message(
      'There was an error resending the email.',
      name: 'errorEmailResent',
      desc: '',
      args: [],
    );
  }

  /// `Save session`
  String get saveSessionTitle {
    return Intl.message(
      'Save session',
      name: 'saveSessionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log in automatically with this user?`
  String get saveSessionDesc {
    return Intl.message(
      'Do you want to log in automatically with this user?',
      name: 'saveSessionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Recover password`
  String get recoverPasswordTitle {
    return Intl.message(
      'Recover password',
      name: 'recoverPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `The attempt limit for this email has been exceeded.`
  String get errorRecoverPasswordLimit {
    return Intl.message(
      'The attempt limit for this email has been exceeded.',
      name: 'errorRecoverPasswordLimit',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred.\nCheck that the email is correct.`
  String get errorRecoverPasswordEmail {
    return Intl.message(
      'An error occurred.\nCheck that the email is correct.',
      name: 'errorRecoverPasswordEmail',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while sending the recovery email.`
  String get errorRecoverPassword {
    return Intl.message(
      'An error occurred while sending the recovery email.',
      name: 'errorRecoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send email`
  String get sendEmail {
    return Intl.message(
      'Send email',
      name: 'sendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email sent`
  String get emailSent {
    return Intl.message(
      'Email sent',
      name: 'emailSent',
      desc: '',
      args: [],
    );
  }

  /// `The recovery email has been sent successfully.\nCheck your email inbox.`
  String get emailSentDesc {
    return Intl.message(
      'The recovery email has been sent successfully.\nCheck your email inbox.',
      name: 'emailSentDesc',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerTitle {
    return Intl.message(
      'Register',
      name: 'registerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get hintName {
    return Intl.message(
      'name',
      name: 'hintName',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get repeatPassword {
    return Intl.message(
      'Repeat password',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get errorPasswordsDontMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'errorPasswordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `The email is not valid`
  String get errorEmailNotValid {
    return Intl.message(
      'The email is not valid',
      name: 'errorEmailNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Fill in all the fields to continue`
  String get errorEmpty {
    return Intl.message(
      'Fill in all the fields to continue',
      name: 'errorEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Registered!`
  String get registerSuccessTitle {
    return Intl.message(
      'Registered!',
      name: 'registerSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `User registered successfully. Check your inbox to validate your registration.`
  String get registerSuccessDesc {
    return Intl.message(
      'User registered successfully. Check your inbox to validate your registration.',
      name: 'registerSuccessDesc',
      desc: '',
      args: [],
    );
  }

  /// `There was an error during registration.`
  String get errorRegister {
    return Intl.message(
      'There was an error during registration.',
      name: 'errorRegister',
      desc: '',
      args: [],
    );
  }

  /// `The registration attempt limit for this email has been exceeded.`
  String get errorRegisterLimit {
    return Intl.message(
      'The registration attempt limit for this email has been exceeded.',
      name: 'errorRegisterLimit',
      desc: '',
      args: [],
    );
  }

  /// `The password must have at least 6 characters.`
  String get errorRegisterPasswordMin {
    return Intl.message(
      'The password must have at least 6 characters.',
      name: 'errorRegisterPasswordMin',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerAndLoginButton {
    return Intl.message(
      'Register',
      name: 'registerAndLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePasswordTitle {
    return Intl.message(
      'Change password',
      name: 'changePasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get currentPassword {
    return Intl.message(
      'Current password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `There was an error changing the password.`
  String get errorChangePassword {
    return Intl.message(
      'There was an error changing the password.',
      name: 'errorChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `The current password is incorrect.`
  String get errorChangePasswordIncorrect {
    return Intl.message(
      'The current password is incorrect.',
      name: 'errorChangePasswordIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get errorChangePasswordNoMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'errorChangePasswordNoMatch',
      desc: '',
      args: [],
    );
  }

  /// `The password must have at least 6 characters.`
  String get errorChangePasswordLength {
    return Intl.message(
      'The password must have at least 6 characters.',
      name: 'errorChangePasswordLength',
      desc: '',
      args: [],
    );
  }

  /// `The new password cannot be the same as the current password.`
  String get errorChangePasswordNoChange {
    return Intl.message(
      'The new password cannot be the same as the current password.',
      name: 'errorChangePasswordNoChange',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get changePasswordSuccess {
    return Intl.message(
      'Password changed successfully',
      name: 'changePasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePasswordButton {
    return Intl.message(
      'Change password',
      name: 'changePasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while changing the user data.`
  String get errorChangeUserData {
    return Intl.message(
      'An error occurred while changing the user data.',
      name: 'errorChangeUserData',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address, and we will send you a link to reset your password`
  String get forgotPasswordDesc {
    return Intl.message(
      'Enter your email address, and we will send you a link to reset your password',
      name: 'forgotPasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPasswordTitle {
    return Intl.message(
      'Reset password',
      name: 'resetPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get resetPasswordButton {
    return Intl.message(
      'Change password',
      name: 'resetPasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `The password has been successfully changed. You can now log in.`
  String get passwordReseted {
    return Intl.message(
      'The password has been successfully changed. You can now log in.',
      name: 'passwordReseted',
      desc: '',
      args: [],
    );
  }

  /// `My evaluations`
  String get myEvaluationsTitle {
    return Intl.message(
      'My evaluations',
      name: 'myEvaluationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Evaluations sorted by machine name`
  String get evaluationsSortedName {
    return Intl.message(
      'Evaluations sorted by machine name',
      name: 'evaluationsSortedName',
      desc: '',
      args: [],
    );
  }

  /// `Evaluations sorted by machine name in descending order`
  String get evaluationsSortedNameDescendant {
    return Intl.message(
      'Evaluations sorted by machine name in descending order',
      name: 'evaluationsSortedNameDescendant',
      desc: '',
      args: [],
    );
  }

  /// `Evaluations sorted by completion date`
  String get evaluationsSortedDate {
    return Intl.message(
      'Evaluations sorted by completion date',
      name: 'evaluationsSortedDate',
      desc: '',
      args: [],
    );
  }

  /// `Evaluations sorted by completion date in descending order`
  String get evaluationsSortedDateDescendant {
    return Intl.message(
      'Evaluations sorted by completion date in descending order',
      name: 'evaluationsSortedDateDescendant',
      desc: '',
      args: [],
    );
  }

  /// `Delete evaluations`
  String get deleteEvaluations {
    return Intl.message(
      'Delete evaluations',
      name: 'deleteEvaluations',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the evaluation?`
  String get deleteEvaluationsTitle {
    return Intl.message(
      'Are you sure you want to delete the evaluation?',
      name: 'deleteEvaluationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Once deleted, the data cannot be recovered`
  String get deleteEvaluationsDesc {
    return Intl.message(
      'Once deleted, the data cannot be recovered',
      name: 'deleteEvaluationsDesc',
      desc: '',
      args: [],
    );
  }

  /// `The evaluation has expired`
  String get evaluationHasExpired {
    return Intl.message(
      'The evaluation has expired',
      name: 'evaluationHasExpired',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation deleted!`
  String get evaluationDeleted {
    return Intl.message(
      'Evaluation deleted!',
      name: 'evaluationDeleted',
      desc: '',
      args: [],
    );
  }

  /// `The evaluation has been successfully deleted`
  String get evaluationDeletedDesc {
    return Intl.message(
      'The evaluation has been successfully deleted',
      name: 'evaluationDeletedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Deleting evaluation...`
  String get deletingEvaluation {
    return Intl.message(
      'Deleting evaluation...',
      name: 'deletingEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Create new evaluation`
  String get newEvaluationTitle {
    return Intl.message(
      'Create new evaluation',
      name: 'newEvaluationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit?\nThe evaluation data will not be saved.`
  String get exitEvaluation {
    return Intl.message(
      'Are you sure you want to exit?\nThe evaluation data will not be saved.',
      name: 'exitEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit?\nChanges will not be saved.`
  String get exitEvaluationChanges {
    return Intl.message(
      'Are you sure you want to exit?\nChanges will not be saved.',
      name: 'exitEvaluationChanges',
      desc: '',
      args: [],
    );
  }

  /// `Modify evaluation`
  String get modifyEvaluationTitle {
    return Intl.message(
      'Modify evaluation',
      name: 'modifyEvaluationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation data`
  String get evaluationData {
    return Intl.message(
      'Evaluation data',
      name: 'evaluationData',
      desc: '',
      args: [],
    );
  }

  /// `Center`
  String get center {
    return Intl.message(
      'Center',
      name: 'center',
      desc: '',
      args: [],
    );
  }

  /// `*Center`
  String get centerAsterisk {
    return Intl.message(
      '*Center',
      name: 'centerAsterisk',
      desc: '',
      args: [],
    );
  }

  /// `Center name`
  String get hintCenter {
    return Intl.message(
      'Center name',
      name: 'hintCenter',
      desc: '',
      args: [],
    );
  }

  /// `Expiration date`
  String get expirationDate {
    return Intl.message(
      'Expiration date',
      name: 'expirationDate',
      desc: '',
      args: [],
    );
  }

  /// `*Expiration date`
  String get expirationDateAsterisk {
    return Intl.message(
      '*Expiration date',
      name: 'expirationDateAsterisk',
      desc: '',
      args: [],
    );
  }

  /// `Machine data`
  String get machineData {
    return Intl.message(
      'Machine data',
      name: 'machineData',
      desc: '',
      args: [],
    );
  }

  /// `Denomination`
  String get denomination {
    return Intl.message(
      'Denomination',
      name: 'denomination',
      desc: '',
      args: [],
    );
  }

  /// `*Denomination`
  String get denominationAsterisk {
    return Intl.message(
      '*Denomination',
      name: 'denominationAsterisk',
      desc: '',
      args: [],
    );
  }

  /// `Machine name`
  String get hintDenomination {
    return Intl.message(
      'Machine name',
      name: 'hintDenomination',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get manufacturer {
    return Intl.message(
      'Manufacturer',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer name`
  String get hintManufacturer {
    return Intl.message(
      'Manufacturer name',
      name: 'hintManufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer No. / Serial No.`
  String get serialNumber {
    return Intl.message(
      'Manufacturer No. / Serial No.',
      name: 'serialNumber',
      desc: '',
      args: [],
    );
  }

  /// `*Manufacturer No. / Serial No.`
  String get serialNumberAsterisk {
    return Intl.message(
      '*Manufacturer No. / Serial No.',
      name: 'serialNumberAsterisk',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get hintSerialNumber {
    return Intl.message(
      'Number',
      name: 'hintSerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Manufacture date`
  String get manufacturedDate {
    return Intl.message(
      'Manufacture date',
      name: 'manufacturedDate',
      desc: '',
      args: [],
    );
  }

  /// `*Manufacture date`
  String get manufacturedDateAsterisk {
    return Intl.message(
      '*Manufacture date',
      name: 'manufacturedDateAsterisk',
      desc: '',
      args: [],
    );
  }

  /// `Commissioning date`
  String get comissioningDate {
    return Intl.message(
      'Commissioning date',
      name: 'comissioningDate',
      desc: '',
      args: [],
    );
  }

  /// `*Commissioning date`
  String get comissioningDateAsterisk {
    return Intl.message(
      '*Commissioning date',
      name: 'comissioningDateAsterisk',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message(
      'Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `Add image`
  String get addImage {
    return Intl.message(
      'Add image',
      name: 'addImage',
      desc: '',
      args: [],
    );
  }

  /// `Image limit reached`
  String get errorLimitImageTitle {
    return Intl.message(
      'Image limit reached',
      name: 'errorLimitImageTitle',
      desc: '',
      args: [],
    );
  }

  /// `You cannot upload more than three images.`
  String get errorLimitImageDesc {
    return Intl.message(
      'You cannot upload more than three images.',
      name: 'errorLimitImageDesc',
      desc: '',
      args: [],
    );
  }

  /// `The following fields are mandatory and cannot be empty:\n\n`
  String get errorMandatoryFields {
    return Intl.message(
      'The following fields are mandatory and cannot be empty:\n\n',
      name: 'errorMandatoryFields',
      desc: '',
      args: [],
    );
  }

  /// `The entered center must match one from the available centers list`
  String get errorCenterDoesntMatch {
    return Intl.message(
      'The entered center must match one from the available centers list',
      name: 'errorCenterDoesntMatch',
      desc: '',
      args: [],
    );
  }

  /// `The commissioning date cannot be earlier than the manufacture date`
  String get errorComissioningDate {
    return Intl.message(
      'The commissioning date cannot be earlier than the manufacture date',
      name: 'errorComissioningDate',
      desc: '',
      args: [],
    );
  }

  /// `Modify checklist`
  String get modifyChecklistTitle {
    return Intl.message(
      'Modify checklist',
      name: 'modifyChecklistTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uploading image...`
  String get uploadingImage {
    return Intl.message(
      'Uploading image...',
      name: 'uploadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading image`
  String get errorUploadingImage {
    return Intl.message(
      'Error uploading image',
      name: 'errorUploadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Saving evaluation data...`
  String get savingEvaluation {
    return Intl.message(
      'Saving evaluation data...',
      name: 'savingEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Checklist`
  String get checklistTitle {
    return Intl.message(
      'Checklist',
      name: 'checklistTitle',
      desc: '',
      args: [],
    );
  }

  /// `There was an error generating the PDF`
  String get errorPdf {
    return Intl.message(
      'There was an error generating the PDF',
      name: 'errorPdf',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation details`
  String get evaluationsDetailsTitle {
    return Intl.message(
      'Evaluation details',
      name: 'evaluationsDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unknown date`
  String get unknownDate {
    return Intl.message(
      'Unknown date',
      name: 'unknownDate',
      desc: '',
      args: [],
    );
  }

  /// `Unknown manufacturer`
  String get unknownManufacterer {
    return Intl.message(
      'Unknown manufacturer',
      name: 'unknownManufacterer',
      desc: '',
      args: [],
    );
  }

  /// `Completion date`
  String get completionDate {
    return Intl.message(
      'Completion date',
      name: 'completionDate',
      desc: '',
      args: [],
    );
  }

  /// `Generating PDF...`
  String get generatingPdf {
    return Intl.message(
      'Generating PDF...',
      name: 'generatingPdf',
      desc: '',
      args: [],
    );
  }

  /// `The PDF has not yet been generated on this device.`
  String get notGenerated {
    return Intl.message(
      'The PDF has not yet been generated on this device.',
      name: 'notGenerated',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
      desc: '',
      args: [],
    );
  }

  /// `There was an error loading the PDF`
  String get errorChargingPdf {
    return Intl.message(
      'There was an error loading the PDF',
      name: 'errorChargingPdf',
      desc: '',
      args: [],
    );
  }

  /// `Unknown name`
  String get unknownName {
    return Intl.message(
      'Unknown name',
      name: 'unknownName',
      desc: '',
      args: [],
    );
  }

  /// `Number of evaluations:`
  String get numEvaluations {
    return Intl.message(
      'Number of evaluations:',
      name: 'numEvaluations',
      desc: '',
      args: [],
    );
  }

  /// `Session successfully closed.`
  String get sessionClosedSuccess {
    return Intl.message(
      'Session successfully closed.',
      name: 'sessionClosedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while closing the session.`
  String get sessionCloseError {
    return Intl.message(
      'An error occurred while closing the session.',
      name: 'sessionCloseError',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message(
      'Dark mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: '',
      args: [],
    );
  }

  /// `The completion date must be after...`
  String get completionDateMustBeAfter {
    return Intl.message(
      'The completion date must be after...',
      name: 'completionDateMustBeAfter',
      desc: '',
      args: [],
    );
  }

  /// `The expiration date must be before...`
  String get expirationDateMustBeBefore {
    return Intl.message(
      'The expiration date must be before...',
      name: 'expirationDateMustBeBefore',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation finished`
  String get evaluationFinished {
    return Intl.message(
      'Evaluation finished',
      name: 'evaluationFinished',
      desc: '',
      args: [],
    );
  }

  /// `PDF`
  String get pdf {
    return Intl.message(
      'PDF',
      name: 'pdf',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while sharing the PDF`
  String get errorSharingPdf {
    return Intl.message(
      'An error occurred while sharing the PDF',
      name: 'errorSharingPdf',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching centers`
  String get cubitCentersError {
    return Intl.message(
      'Error fetching centers',
      name: 'cubitCentersError',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching evaluation details`
  String get cubitEvaluationDetailsError {
    return Intl.message(
      'Error fetching evaluation details',
      name: 'cubitEvaluationDetailsError',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting evaluation`
  String get cubitDeleteEvaluationError {
    return Intl.message(
      'Error deleting evaluation',
      name: 'cubitDeleteEvaluationError',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching evaluations`
  String get cubitEvaluationsError {
    return Intl.message(
      'Error fetching evaluations',
      name: 'cubitEvaluationsError',
      desc: '',
      args: [],
    );
  }

  /// `Error inserting evaluation`
  String get cubitInsertEvaluationsError {
    return Intl.message(
      'Error inserting evaluation',
      name: 'cubitInsertEvaluationsError',
      desc: '',
      args: [],
    );
  }

  /// `Error modifying evaluation`
  String get cubitInsertEvaluationsModifyError {
    return Intl.message(
      'Error modifying evaluation',
      name: 'cubitInsertEvaluationsModifyError',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching questions`
  String get cubitQuestionsError {
    return Intl.message(
      'Error fetching questions',
      name: 'cubitQuestionsError',
      desc: '',
      args: [],
    );
  }

  /// `Loading the questions...`
  String get cubitQuestionsLoading {
    return Intl.message(
      'Loading the questions...',
      name: 'cubitQuestionsLoading',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while updating user data`
  String get errorUpdatingUser {
    return Intl.message(
      'An error occurred while updating user data',
      name: 'errorUpdatingUser',
      desc: '',
      args: [],
    );
  }

  /// `User data updated successfully`
  String get successUpdatingUser {
    return Intl.message(
      'User data updated successfully',
      name: 'successUpdatingUser',
      desc: '',
      args: [],
    );
  }

  /// `Expiry warning`
  String get semanticlabelExpiryWarning {
    return Intl.message(
      'Expiry warning',
      name: 'semanticlabelExpiryWarning',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get semanticlabelNoData {
    return Intl.message(
      'No data',
      name: 'semanticlabelNoData',
      desc: '',
      args: [],
    );
  }

  /// `Show observations`
  String get semanticlabelShowObservations {
    return Intl.message(
      'Show observations',
      name: 'semanticlabelShowObservations',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get semanticlabelShare {
    return Intl.message(
      'Share',
      name: 'semanticlabelShare',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get semanticlabelDownload {
    return Intl.message(
      'Download',
      name: 'semanticlabelDownload',
      desc: '',
      args: [],
    );
  }

  /// `Generate QR`
  String get semanticlabelGenerateQR {
    return Intl.message(
      'Generate QR',
      name: 'semanticlabelGenerateQR',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get semanticlabelClose {
    return Intl.message(
      'Close',
      name: 'semanticlabelClose',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get semanticlabelQRCode {
    return Intl.message(
      'QR Code',
      name: 'semanticlabelQRCode',
      desc: '',
      args: [],
    );
  }

  /// `Add from gallery`
  String get semanticlabelAddFromGallery {
    return Intl.message(
      'Add from gallery',
      name: 'semanticlabelAddFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Open camera`
  String get semanticlabelOpenCamera {
    return Intl.message(
      'Open camera',
      name: 'semanticlabelOpenCamera',
      desc: '',
      args: [],
    );
  }

  /// `Expand`
  String get semanticlabelExpand {
    return Intl.message(
      'Expand',
      name: 'semanticlabelExpand',
      desc: '',
      args: [],
    );
  }

  /// `Show centers`
  String get semanticlabelShowCenters {
    return Intl.message(
      'Show centers',
      name: 'semanticlabelShowCenters',
      desc: '',
      args: [],
    );
  }

  /// `Show password`
  String get semanticlabelShowPassword {
    return Intl.message(
      'Show password',
      name: 'semanticlabelShowPassword',
      desc: '',
      args: [],
    );
  }

  /// `Clear text`
  String get semanticlabelClearText {
    return Intl.message(
      'Clear text',
      name: 'semanticlabelClearText',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get semanticlabelBack {
    return Intl.message(
      'Back',
      name: 'semanticlabelBack',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get semanticlabelWarning {
    return Intl.message(
      'Warning',
      name: 'semanticlabelWarning',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get semanticlabelFilters {
    return Intl.message(
      'Filters',
      name: 'semanticlabelFilters',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get semanticlabelDelete {
    return Intl.message(
      'Delete',
      name: 'semanticlabelDelete',
      desc: '',
      args: [],
    );
  }

  /// `Sort alphabetically in ascending order`
  String get semanticlabelSortAlphabeticallyAsc {
    return Intl.message(
      'Sort alphabetically in ascending order',
      name: 'semanticlabelSortAlphabeticallyAsc',
      desc: '',
      args: [],
    );
  }

  /// `Sort alphabetically in descending order`
  String get semanticlabelSortAlphabeticallyDesc {
    return Intl.message(
      'Sort alphabetically in descending order',
      name: 'semanticlabelSortAlphabeticallyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sort by creation date in ascending order`
  String get semanticlabelSortByCreationDateAsc {
    return Intl.message(
      'Sort by creation date in ascending order',
      name: 'semanticlabelSortByCreationDateAsc',
      desc: '',
      args: [],
    );
  }

  /// `Sort by creation date in descending order`
  String get semanticlabelSortByCreationDateDesc {
    return Intl.message(
      'Sort by creation date in descending order',
      name: 'semanticlabelSortByCreationDateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Homepage`
  String get semanticlabelHomepage {
    return Intl.message(
      'Homepage',
      name: 'semanticlabelHomepage',
      desc: '',
      args: [],
    );
  }

  /// `New evaluation`
  String get semanticlabelNewEvaluation {
    return Intl.message(
      'New evaluation',
      name: 'semanticlabelNewEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get semanticlabelProfile {
    return Intl.message(
      'Profile',
      name: 'semanticlabelProfile',
      desc: '',
      args: [],
    );
  }

  /// `Add image`
  String get semanticlabelAddImage {
    return Intl.message(
      'Add image',
      name: 'semanticlabelAddImage',
      desc: '',
      args: [],
    );
  }

  /// `Add new image`
  String get semanticlabelAddNewImage {
    return Intl.message(
      'Add new image',
      name: 'semanticlabelAddNewImage',
      desc: '',
      args: [],
    );
  }

  /// `Delete image`
  String get semanticlabelDeleteImage {
    return Intl.message(
      'Delete image',
      name: 'semanticlabelDeleteImage',
      desc: '',
      args: [],
    );
  }

  /// `Profile picture`
  String get semanticlabelProfilePicture {
    return Intl.message(
      'Profile picture',
      name: 'semanticlabelProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get semanticlabelChangePassword {
    return Intl.message(
      'Change password',
      name: 'semanticlabelChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get semanticlabelLogout {
    return Intl.message(
      'Log out',
      name: 'semanticlabelLogout',
      desc: '',
      args: [],
    );
  }

  /// `Welcome screen`
  String get semanticlabelWelcomeScreen {
    return Intl.message(
      'Welcome screen',
      name: 'semanticlabelWelcomeScreen',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ca'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'eu'),
      Locale.fromSubtags(languageCode: 'gl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
