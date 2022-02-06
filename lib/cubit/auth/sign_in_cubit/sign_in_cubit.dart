import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isTrue = false;

  void onChanged(bool? v) {
    _isTrue = v!;
    emit(SignInInitial());
  }

  void onPressed() {
    if (_formKey.currentState!.validate()) {
      // Button bosilganida shu funksiya ishga tushadi
    }
  }

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get loginController => _loginController;

  TextEditingController get passwordController => _passwordController;
  bool get isTrue => _isTrue;
}
