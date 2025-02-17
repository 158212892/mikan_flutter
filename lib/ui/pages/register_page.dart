import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mikan_flutter/internal/extension.dart';
import 'package:mikan_flutter/mikan_flutter_routes.dart';
import 'package:mikan_flutter/providers/index_model.dart';
import 'package:mikan_flutter/providers/register_model.dart';
import 'package:mikan_flutter/providers/subscribed_model.dart';
import 'package:mikan_flutter/topvars.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "register",
  routeName: "/register",
)
@immutable
class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnnotatedRegion(
      value: context.fitSystemUiOverlayStyle,
      child: ChangeNotifierProvider<RegisterModel>(
        create: (_) => RegisterModel(),
        child: Builder(builder: (context) {
          final registerModel =
              Provider.of<RegisterModel>(context, listen: false);
          return Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: edgeH24V36WithStatusBar,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          normalFormHeader,
                          sizedBoxH16,
                          _buildUserNameField(theme, registerModel),
                          sizedBoxH16,
                          _buildPasswordField(theme, registerModel),
                          sizedBoxH16,
                          _buildConfirmPasswordField(theme, registerModel),
                          sizedBoxH16,
                          _buildEmailField(theme, registerModel),
                          sizedBoxH16,
                          _buildQQField(theme, registerModel),
                          sizedBoxH56,
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                minWidth: 0.0,
                                padding: edge16,
                                shape: circleShape,
                                color: theme.backgroundColor,
                                child: const Icon(
                                  FluentIcons.chevron_left_24_regular,
                                  size: 16.0,
                                ),
                              ),
                              sizedBoxW16,
                              Expanded(
                                child: _buildRegisterButton(theme),
                              )
                            ],
                          ),
                          sizedBoxH56,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRegisterButton(final ThemeData theme) {
    return Selector<RegisterModel, bool>(
      selector: (_, model) => model.loading,
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, loading, __) {
        final Color btnColor = loading ? theme.primary : theme.secondary;
        final Color iconColor = btnColor.isDark ? Colors.white : Colors.black;
        return ElevatedButton(
          onPressed: () {
            if (loading) return;
            if (_formKey.currentState!.validate()) {
              context.read<RegisterModel>().submit(() {
                context.read<IndexModel>().refresh();
                context.read<SubscribedModel>().refresh();
                Navigator.popUntil(
                  context,
                  (route) => route.settings.name == Routes.home.name,
                );
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SpinKitWave(
                  size: 20.0,
                  type: SpinKitWaveType.center,
                  color: iconColor,
                ),
              sizedBoxW12,
              Text(
                loading ? "注册中" : "注册",
                style: TextStyle(
                  color: iconColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizedBoxW12,
              if (loading)
                SpinKitWave(
                  size: 20.0,
                  type: SpinKitWaveType.center,
                  color: iconColor,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserNameField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return TextFormField(
      controller: registerModel.userNameController,
      cursorColor: theme.secondary,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: '用户名',
        hintText: '请输入用户名',
        hintStyle: const TextStyle(fontSize: 14.0),
        prefixIcon: Icon(
          FluentIcons.person_24_regular,
          color: theme.secondary,
        ),
      ),
      validator: (value) {
        return value.isNullOrBlank ? "用户名不能为空" : null;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildEmailField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return TextFormField(
      controller: registerModel.emailController,
      cursorColor: theme.secondary,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: '邮箱',
        hintText: '请输入邮箱',
        hintStyle: const TextStyle(fontSize: 14.0),
        prefixIcon: Icon(
          FluentIcons.mail_24_regular,
          color: theme.secondary,
        ),
      ),
      validator: (value) {
        if (value.isNullOrBlank) return "邮箱不能为空";
        if (!RegExp(r".+@.+\..+").hasMatch(value!)) return "邮箱格式不正确";
        return null;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildQQField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return TextFormField(
      controller: registerModel.qqController,
      cursorColor: theme.secondary,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: 'QQ',
        hintText: '请输入QQ号码',
        hintStyle: const TextStyle(fontSize: 14.0),
        prefixIcon: Icon(
          FluentIcons.emoji_surprise_24_regular,
          color: theme.secondary,
        ),
      ),
      validator: (value) {
        if (value.isNotBlank) {
          if (!RegExp(r"\d+").hasMatch(value!)) return "QQ号码应为数字";
          if (value.length < 5) {
            return "QQ号码最少为5位";
          }
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPasswordField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return Selector<RegisterModel, bool>(
      selector: (_, model) => model.showPassword,
      shouldRebuild: (pre, next) => pre != next,
      builder: (_, showPassword, __) {
        return TextFormField(
          obscureText: !showPassword,
          cursorColor: theme.secondary,
          controller: registerModel.passwordController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            labelText: '密码',
            hintText: '请输入密码',
            hintStyle: const TextStyle(fontSize: 14.0, letterSpacing: 0.0),
            prefixIcon: Icon(
              FluentIcons.password_24_regular,
              color: theme.secondary,
            ),
            suffixIcon: IconButton(
              icon: showPassword
                  ? Icon(
                      FluentIcons.eye_24_regular,
                      color: theme.secondary,
                    )
                  : Icon(
                      FluentIcons.eye_off_24_regular,
                      color: theme.secondary,
                    ),
              onPressed: () {
                registerModel.showPassword = !showPassword;
              },
            ),
          ),
          validator: (value) {
            if (value.isNullOrBlank) return "密码不能为空";
            if (value!.length < 6) return "密码最少6位";
            return null;
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }

  Widget _buildConfirmPasswordField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return Selector<RegisterModel, bool>(
      selector: (_, model) => model.showPassword,
      shouldRebuild: (pre, next) => pre != next,
      builder: (_, showPassword, __) {
        return TextFormField(
          obscureText: !showPassword,
          cursorColor: theme.secondary,
          controller: registerModel.confirmPasswordController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            labelText: '确认密码',
            hintText: '请输入确认密码',
            hintStyle: const TextStyle(fontSize: 14.0, letterSpacing: 0.0),
            prefixIcon: Icon(
              FluentIcons.key_multiple_20_regular,
              color: theme.secondary,
            ),
            suffixIcon: IconButton(
              icon: showPassword
                  ? Icon(
                      FluentIcons.eye_24_regular,
                      color: theme.secondary,
                    )
                  : Icon(
                      FluentIcons.eye_off_24_regular,
                      color: theme.secondary,
                    ),
              onPressed: () {
                registerModel.showPassword = !showPassword;
              },
            ),
          ),
          validator: (value) {
            if (value.isNullOrBlank) return "确认密码不能为空";
            if (value != registerModel.passwordController.text) {
              return "确认密码与密码不一致，请重新输入";
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }
}
