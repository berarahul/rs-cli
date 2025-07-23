import 'dart:io';

void main() async {
  print('\x1B[33m🔧 Rahul Structure CLI Tool (rs)\x1B[0m\n');
  print('📁 Are you creating your project structure?');
  print('  1️⃣  Clean Architecture');
  print('  2️⃣  MVVM Architecture');
  print('  3️⃣  Rahul Architecture (custom)');
  stdout.write('\n👉 Please enter your choice (1/2/3): ');

  final input = stdin.readLineSync();

  switch (input) {
    case '1':
      print('\n⏬ Downloading and generating Clean Architecture...');
      await createCleanArchitecture();
      break;
    case '2':
      print('\n⏬ Downloading and generating MVVM Architecture...');
      await createMVVMArchitecture();
      break;
    case '3':
      print('\n⏬ Downloading and generating Rahul Architecture...');
      await createRahulArchitecture();
      break;
    default:
      print('\n❌ Invalid choice. Please run `rs` again and choose 1, 2, or 3.');
      return;
  }

  print('\n✅ \x1B[32mStructure successfully generated!\x1B[0m');
}

Future<void> createCleanArchitecture() async {
  final paths = [
    'lib/core',
    'lib/features/auth/data',
    'lib/features/auth/domain',
    'lib/features/auth/presentation',
  ];
  for (var path in paths) {
    await Directory(path).create(recursive: true);
    print('📂 Created $path');
  }
}

Future<void> createMVVMArchitecture() async {
  final paths = [
    'lib/models',
    'lib/views',
    'lib/view_models',
    'lib/services',
  ];
  for (var path in paths) {
    await Directory(path).create(recursive: true);
    print('📂 Created $path');
  }
}

Future<void> createRahulArchitecture() async {
  final folders = [
    'lib/core/constants',
    'lib/core/network',
    'lib/core/routes',
    'lib/core/theme',
    'lib/core/utils',
    'lib/core/widgets',
    'lib/features/login/bloc',
    'lib/features/login/models',
    'lib/features/login/repository',
    'lib/features/login/views',
    'lib/features/login/widgets',
  ];

  final files = {
    'lib/features/login/bloc/login_bloc.dart': '',
    'lib/features/login/bloc/login_event.dart': '',
    'lib/features/login/bloc/login_state.dart': '',
    'lib/features/login/models/login_model.dart': '',
    'lib/features/login/models/login_response_model.dart': '',
    'lib/features/login/repository/login_repository.dart': '',
    'lib/features/login/views/login_screen.dart': '',
    'lib/features/login/widgets/login_form.dart': '',
    'lib/core/constants/app_icons.dart': '',
    'lib/core/constants/app_images.dart': '',
    'lib/core/constants/app_strings.dart': '',
    'lib/core/network/api_response.dart': getApiResponseBoilerplate(),
    'lib/core/network/client_api.dart': getApiClient(),
    'lib/core/network/custom_exception.dart': getCustomException(),
    'lib/core/routes/routes.dart': getAppRoutes(),
    'lib/core/theme/app_colors.dart': getAppColors(),
    'lib/core/theme/app_text_styles.dart': getAppTextstyle(),
    'lib/core/theme/app_theme.dart': getAppTheme(),
    'lib/core/utils/sharedpref_helper.dart': getsharedPrefhelper(),
    'lib/core/utils/ui_helper.dart': getUiHelper(),
    'lib/core/utils/update_status_bar.dart': getUpdateStatusbar(),
    'lib/core/widgets/custom_button.dart': getCustombutton(),
    'lib/core/widgets/custom_loading_indicator.dart':
        getCustomLoadingIndicator(),
    'lib/core/widgets/custom_text_field.dart': getCustomTextfiled(),
  };

  for (var folder in folders) {
    await Directory(folder).create(recursive: true);
    print('📁 Created $folder');
  }

  for (var filePath in files.entries) {
    final file = File(filePath.key);
    await file.create(recursive: true);
    await file
        .writeAsString(filePath.value); // You can insert boilerplate text here
    print('📄 Created ${file.path}');
  }
}

String getApiResponseBoilerplate() {
  return '''
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
    };
  }
}
''';
}

String getApiClient() {
  return '''

import 'package:dio/dio.dart';
import 'package:project_shakti/core/utils/sharedpref_helper.dart';
import 'package:project_shakti/core/network/api_response.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://project-shakti-server.onrender.com/',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  factory ApiClient() => _instance;

  ApiClient._internal();

  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  Future<void> _setTokenHeader({bool useToken = true}) async {
    if (useToken) {
      final token = await _prefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer \$token';
      }
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    bool useToken = true,
    T Function(dynamic json)? fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _setTokenHeader(useToken: useToken);

    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String path,
    dynamic data, {
    bool useToken = true,
    T Function(dynamic json)? fromJson,
  }) async {
    await _setTokenHeader(useToken: useToken);

    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String path,
    dynamic data, {
    bool useToken = true,
    T Function(dynamic json)? fromJson,
  }) async {
    await _setTokenHeader(useToken: useToken);

    try {
      final response = await _dio.put(path, data: data);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path,
    dynamic data, {
    bool useToken = true,
    T Function(dynamic json)? fromJson,
  }) async {
    await _setTokenHeader(useToken: useToken);

    try {
      final response = await _dio.patch(path, data: data);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    bool useToken = true,
    T Function(dynamic json)? fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _setTokenHeader(useToken: useToken);

    try {
      final response = await _dio.delete(path, queryParameters: queryParameters);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // ✅ Shared success handler
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic json)? fromJson,
  ) {
    final json = response.data;
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: fromJson != null && json['data'] != null ? fromJson(json['data']) : null,
    );
  }

  // ❌ Shared error handler
  ApiResponse<T> _handleError<T>(Object error) {
    if (error is DioException) {
      final response = error.response;
      final errorMsg = response?.data?['message'] ?? error.message ?? 'An unexpected error occurred.';
      return ApiResponse<T>(
        success: false,
        message: errorMsg,
        data: null,
      );
    }

    return ApiResponse<T>(
      success: false,
      message: 'Unexpected error: \$error',
      data: null,
    );
  }
}


''';
}

String getCustomException() {
  return '''
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}

class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}



''';
}

String getAppRoutes() {
  return '''


class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
     
      signup: (context) => const SignUpScreen(),
  
    };
  }
}


''';
}

String getAppColors() {
  return '''

import 'package:flutter/material.dart';

class AppColors {
  // LIGHT THEME colors
  static const Color primaryLight = Color(0xffFF727B);
  static const Color secondaryLight = Color(0xff006BC7);
  static const Color labelLight = Color(0xffAEACBA);
  static const Color fontLight = Color(0xff151515);
  static const Color primaryContainerLight = Color(0xffF4F4F4);
  static const Color backgroundLight = Color(0xffFFFFFF);

  // DARK THEME colors
  static const Color primaryDark = Color(0xffFF727B);
  static const Color secondaryDark = Color(0xffE59236);
  static const Color labelDark = Color(0xffAEACBA);
  static const Color fontDark = Color(0xffFFFFFF);
  static const Color primaryContainerDark = Color(0xff252324);
  static const Color backgroundDark = Color(0xff18181A);

  // Error Color
  static const Color errorColor = Color(0xffD51111);
  // Success Color
  static const Color successColor = Color(0xff1EC35C);

  // common
  static const Color whiteCommon = Color(0xffFFFFFF);
  static const Color blackCommon = Color(0xff000000);
}



''';
}

String getAppTextstyle() {
  return '''

import 'package:flutter/material.dart';

class AppTextStyles {
  // App Bar Title
  static TextStyle appBarTitle(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    // color: AppColor.primaryText(brightness),
  );

  // Heading 1 (Large titles, e.g., page headers)
  static TextStyle heading1(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    // color: AppColor.primaryText(brightness),
  );

  // Heading 2 (Section headers)
  static TextStyle heading2(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    // color: AppColor.primaryText(brightness),
  );
  // Heading 3 (Subsection headers)
  static TextStyle heading3(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    // color: AppColor.primaryText(brightness),
  );

  // Subheading (Secondary titles)
  static TextStyle subheading(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    // color: AppColor.secondaryText(brightness),
  );

  // Body Text (Regular)
  static TextStyle body(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    // color: AppColor.primaryText(brightness),
  );

  // Body Text Bold
  static TextStyle bodyBold(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    // color: AppColor.primaryText(brightness),
  );

  // Caption (Small text, e.g., for descriptions)
  static TextStyle caption(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize: 12,
    // color: AppColor.secondaryText(brightness),
  );

  // Button Text
  static TextStyle button(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    // color: AppColor.secondaryText(brightness), // Fixed for contrast on buttons
  );

  // Label (e.g., form field labels)
  static TextStyle label(Brightness brightness) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    // color: AppColor.primaryText(brightness),
  );
}


''';
}

String getAppTheme() {
  return '''

import 'package:flutter/material.dart';
import 'package:project_shakti/core/theme/app_colors.dart';

class AppTheme {
  bool isLightTheme = true;
  isDarkTheme() {
    return !isLightTheme;
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      surface: AppColors.backgroundLight,
      onSurface: AppColors.fontLight,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.whiteCommon,
      secondary: AppColors.secondaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      tertiary: AppColors.labelLight,
      error: AppColors.errorColor,
      onPrimaryContainer: AppColors.fontLight,
    ),

    // TEXT THEME
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: AppColors.fontLight,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.fontLight,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: AppColors.fontLight,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.fontLight,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.fontLight,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.labelLight,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.labelLight,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: AppColors.labelLight,
      ),
    ),
  );

  // DARK THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.backgroundDark,
      onSurface: AppColors.fontDark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.whiteCommon,
      secondary: AppColors.secondaryDark,
      primaryContainer: AppColors.primaryContainerDark,
      tertiary: AppColors.labelDark,
      error: AppColors.errorColor,
      onPrimaryContainer: AppColors.fontDark,
    ),

    // TEXT THEME
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: AppColors.fontDark,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColors.fontDark,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.fontDark,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: AppColors.fontDark,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColors.fontDark,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.fontDark,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.labelDark,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.labelDark,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: AppColors.labelDark,
      ),
    ),
  );
}


''';
}

String getsharedPrefhelper() {
  return '''

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _onboardKey = "onboarded";
  static const String _tokenKey = "auth_token";

  Future<void> setOnboarded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardKey, value);
  }

  Future<bool> isOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardKey) ?? false;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

''';
}

String getUiHelper() {
  return '''

import 'package:flutter/material.dart';

class UIHelper {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  UIHelper(pad);

  static EdgeInsets getPadding({
    double horizontal = paddingMedium,
    double vertical = paddingMedium,
  }) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static SizedBox getVerticalSpace(double height) {
    return SizedBox(height: height);
  }

  static SizedBox getHorizontalSpace(double width) {
    return SizedBox(width: width);
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }


static void showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  final backgroundColor = isError ? Colors.redAccent : Colors.green;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}


}



''';
}

String getUpdateStatusbar() {
  return '''


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void updateStatusBar(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: colorScheme.surface,
        statusBarBrightness:
            colorScheme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
    );
  });
}

''';
}

String getCustombutton() {
  return '''


import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading || !isEnabled ? null : onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
        ),
      ),
    );
  }
}

''';
}

String getCustomLoadingIndicator() {
  return '''


import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
        strokeWidth: 4.0,
      ),
    );
  }
}


''';
}

String getCustomTextfiled() {
  return '''

import 'package:flutter/material.dart';
import 'package:project_shakti/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? icon;
  final Color? iconColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;


  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.icon,
    this.iconColor,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return SizedBox(
      height: 64, // fixed height that still shows error below the input
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: textInputAction,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.labelMedium,
          floatingLabelStyle: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          prefixIcon: Icon(
            icon,
            color: iconColor ?? Theme.of(context).colorScheme.primary,
            size: 20,
          ),

          // keep the same inner spacing in every state
          isDense: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 18),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: brightness == Brightness.dark
                  ? AppColors.whiteCommon.withValues(alpha: 0.2)
                  : AppColors.blackCommon.withValues(alpha: 0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}


''';
}
