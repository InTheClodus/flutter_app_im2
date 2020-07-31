import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_im_plugin/enums/log_print_level.dart';

import 'page/home.dart';

void main() {
  // 运行程序
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 初始化SDK(每次仅调用一次)
    TencentImPlugin.init(
        appid: "1400403111", logPrintLevel: LogPrintLevel.info);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _userName = TextEditingController(text:"user4"); //用户名
  final _userPwd = TextEditingController(text: "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwqXFqUUmUInilOzEgoLMFCUrQxMDAxMDY0NDQ4hMakVBZlEqUNzU1NTIwMAAIlqSmQsWszS1NDIxNzSDmpKZDjTXJ6wyPEa-wCPRNzwjJN-SNyCo2CW0yiLZMr0iu8zJPMfEIiWpIMLD1TUi2NVWqRYAUHUxtA__"); //密码

  GlobalKey _globalKey = new GlobalKey<FormState>(); //用于检查输入框是否为空
  /// 登录
  onLogin() async {
    await TencentImPlugin.initStorage(identifier: _userName.text);

    await TencentImPlugin.login(
      identifier: _userName.text,
      userSig:_userPwd.text,
    );

    // 初始化推送通道
//    bindXiaoMiPush();
//    bindHuaWeiPush();

    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
    );
  }

  /// 退出登录
  onLogout() {
    TencentImPlugin.logout();
  }

  /// 绑定小米推送
//  bindXiaoMiPush() {
//    XiaoMiPushPlugin.addListener((type, params) {
//      if (type == XiaoMiPushListenerTypeEnum.ReceiveRegisterResult) {
//        TencentImPlugin.setOfflinePushToken(
//            token: params.commandArguments[0], bussid: 10301);
//      }
//    });
//    XiaoMiPushPlugin.init(
//        appId: "2882303761518400514", appKey: "5241840023514");
//  }

  /// 绑定华为推送
//  bindHuaWeiPush() {
//    HuaWeiPushPlugin.getToken().then((token) {
//      TencentImPlugin.setOfflinePushToken(token: token, bussid: 10524);
//    }).catchError((e) {
//      print("华为离线推送绑定失败!");
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Center(
        child: Form(
          key: _globalKey,
          autovalidate: true, //自动校验
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _userName,
                decoration: InputDecoration(
                    labelText: "账号",
                    hintText: "输入你的账号",
                    icon: Icon(Icons.person)),
                validator: (v) {
                  return v.trim().length > 0 ? null : "用户名不能为空";
                },
              ),
              TextFormField(
                controller: _userPwd,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "输入你的密码",
                  icon: Icon(Icons.lock),
                ),
                validator: (v) {
                  return v.trim().length > 5 ? null : "密码不低于6位";
                },
                obscureText: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              SizedBox(
                width: 120.0,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    onLogin();
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(color: Colors.white), //字体白色
                  ),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
