import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:client/features/auth/model/user_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
          Uri.parse(
            '${ServerConstant.serverURL}/auth/signup',
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
            '${ServerConstant.serverURL}/auth/login',
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
