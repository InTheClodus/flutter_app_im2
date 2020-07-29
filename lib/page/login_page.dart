import 'package:flutter/material.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userName = TextEditingController(); //用户名
  final _userPwd = TextEditingController(); //密码

  GlobalKey _globalKey = new GlobalKey<FormState>(); //用于检查输入框是否为空
  onLogin() async {
    await TencentImPlugin.initStorage(identifier: "user2");

    await TencentImPlugin.login(
      identifier: "user2",
      userSig:
      "eJwtzMEKgkAUheF3mW0h945OqNDKRWnRLIyYlspMdgtrHK2E6N0TdXm*A-*XHfe59zaOxYx7wJbjJm0eHV1o5FdrHJ*PVt8La0mzGAOAAHxEnB7TW3JmcCEEB4BJO6pHi1aA6PvhXKFq6KaJOKO8qn6HyjYZDxbZ7VPlh6aMNtXW1k8VnlxUyFKma-b7AwXBMPw_",
    );

    // 初始化推送通道
//    bindXiaoMiPush();
//    bindHuaWeiPush();

    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
    );
  }

  @override
  void initState(){
    super.initState();
  }
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