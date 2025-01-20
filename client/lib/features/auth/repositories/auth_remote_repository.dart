import 'dart:convert';

import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:client/features/auth/model/user_model.dart';

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
          Uri.parse(
            'http://127.0.0.1:8000/auth/signup',
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            {
              'name': name,
              'email': email,
              'password': password,
            },
          ));
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        // handle the error
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
          Uri.parse(
            'http://127.0.0.1:8000/auth/login',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
            {
              'email': email,
              'password': password,
            },
          ));
          final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
        if (response.statusCode!= 200) {
          return Left(AppFailure(resBodyMap['detail']));
        }

        return Right(UserModel.fromMap(resBodyMap));

    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
