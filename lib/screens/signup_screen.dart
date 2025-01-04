import 'package:bookshop/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

enum Role {
  student('Học sinh'),
  admin('Quản lý'),
  ;

  final String title;
  const Role(this.title);
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController();

  final mailController = TextEditingController();

  final passwordController = TextEditingController();

  final classController = TextEditingController();

  final _form = GlobalKey<FormState>();
  Role dropdownValue = Role.student;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Register Form',
                  style: TextStyle(
                      fontSize: 20, letterSpacing: 2, color: Colors.blueGrey),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: name,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'tên người dùng là bắt buộc';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Tên người dùng'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Email là bắt buộc';
                      }
                      if (!val.contains('@')) {
                        return 'Vui lòng cung cấp địa chỉ email hợp lệ';
                      }
                      return null;
                    },
                    controller: mailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Mật khẩu là bắt buộc';
                    }
                    if (val.length < 6) {
                      return 'Độ dài mật khẩu tối thiểu là 6';
                    }
                    if (val.length > 20) {
                      return 'Độ dài mật khẩu tối đa là 20';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Mật khẩu'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: classController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Vui lòng nhập mã lớp';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Nhập mã lớp vd: 10A1'),
                ),
                SizedBox(
                  height: 8,
                ),
                DropdownButtonHideUnderline(
                    child: DropdownButton<Role>(
                  value: dropdownValue,
                  borderRadius: BorderRadius.circular(8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  hint: Text('Chọn quyền'),
                  items: Role.values.map((value) {
                    return DropdownMenuItem<Role>(
                      value: value,
                      child: Text(value.title),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                )),
                SizedBox(
                  height: 8,
                ),
                FilledButton(
                  onPressed: () => _register(context),
                  child: Text('Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register(BuildContext context) async {
    _form.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_form.currentState!.validate()) {
      final success = await Get.showOverlay(
          asyncFunction: () => context.read<AuthProvider>().signUp(
                name: name.text.trim(),
                email: mailController.text.trim(),
                password: passwordController.text.trim(),
                role: dropdownValue.name.toString(),
                atClass: classController.text.trim(),
              ),
          loadingWidget: Center(child: CircularProgressIndicator()));

      if (success) {
        Get.back();
        Get.snackbar('Success', 'Account created successfully');
      } else {
        Get.snackbar('Error', 'Something went wrong');
      }
    }
  }
}
