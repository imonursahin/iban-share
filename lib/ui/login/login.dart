import 'package:flutter/material.dart';
import 'package:ibansfer/ui/panel/panel.dart';
import 'package:ibansfer/util/src/mail_service.dart';
import 'package:ibansfer/util/src/verification_service.dart';
import 'package:ibansfer/util/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({Key? key}) : super(key: key);

  @override
  _MainLoginState createState() => _MainLoginState();
}

var emailController = new TextEditingController();
var auCodeController = new TextEditingController();

String? randomNumber;
String? emailErrorText;
String? auErrorText;

MailService? _mailService;
VerificationService? _verificationService;

class _MainLoginState extends State<MainLogin> {
  void initState() {
    super.initState();

    emailController = new TextEditingController();
    auCodeController = new TextEditingController();
    _mailService = new MailService();
    _verificationService = new VerificationService();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: AppColors.mainColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "IBANsfer",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFFf0b90b),
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(
              height: 10.0,
              color: Color(0xFF323c45),
              indent: 150,
              endIndent: 150,
              thickness: 1.3,
            ),
            Text(
              "Giriş yapmak için mail adresinizi yazın.",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFf1c740),
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(height: 75.0),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: emailController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Mail Adresiniz',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
            SizedBox(height: 75.0),
            Text(
              "$emailErrorText",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFf1c740),
                fontWeight: FontWeight.w100,
              ),
            ),
            MaterialButton(
              height: 40.0,
              minWidth: 150.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {
                randomNumber = _verificationService!.get6DigitNumber();
                _mailService!
                    .sendMail(emailController.text, randomNumber ?? "");
                showVerificationDialog();
                setState(() {});
              },
              padding: EdgeInsets.all(12),
              color: Color(0xFFf17c03),
              child: Text('Giriş Yap', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void showVerificationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color(0xFF29313c),
            elevation: 25,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            actions: <Widget>[
              Container(
                width: 180.0,
                child: TextField(
                  autofocus: true,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      counterStyle: TextStyle(
                        height: double.minPositive,
                      ),
                      labelText: 'Doğrulama Kodu',
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                      )),
                ),
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                height: 40.0,
                minWidth: 100.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  if (auCodeController.text == "") {
                    setState(() {
                      auErrorText = "Lütfen doğrulama kodunu giriniz.";
                    });
                    return;
                  }
                  verifyCode();
                },
                padding: EdgeInsets.all(12),
                color: Color(0xFFf17c03),
                child: Text('Doğrula', style: TextStyle(color: Colors.white)),
              ),
            ]);
      },
    );
  }

  Future<void> verifyCode() async {
    var personMail = emailController.text;
    var isVerified = auCodeController.text;

    if (personMail == emailController.text && isVerified == true) {
      var sharedControl = await SharedPreferences.getInstance();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPanel()));
    } else {
      return;
    }
  }
}
