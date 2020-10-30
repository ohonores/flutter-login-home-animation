import 'package:flutter/material.dart';
import '../../../helper/theme.dart';
import '../../../model/user.dart';
import '../../../page/settings/widgets/headerWidget.dart';
import '../../../page/settings/widgets/settingsAppbar.dart';
import '../../../page/settings/widgets/settingsRowWidget.dart';
import '../../../state/authState.dart';
import '../../../widgets/customAppBar.dart';
import '../../../widgets/customWidgets.dart';
import '../../../widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel ?? User();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Account',
        subtitle: user?.userName,
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget('Login and security'),
          SettingRowWidget(
            "Username",
            subtitle: user?.userName,
            // navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
          SettingRowWidget(
            "Phone",
            subtitle: user?.contact,
          ),
          SettingRowWidget(
            "Email address",
            subtitle: user?.email,
            navigateTo: 'VerifyEmailPage',
          ),
          SettingRowWidget("Password"),
          SettingRowWidget("Security"),
          HeaderWidget(
            'Data and Permission',
            secondHeader: true,
          ),
          SettingRowWidget("Country"),
          SettingRowWidget("Your Fwitter data"),
          SettingRowWidget("Apps and sessions"),
          SettingRowWidget(
            "Log out",
            textColor: TwitterColor.ceriseRed,
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              final state = Provider.of<AuthState>(context);
              state.logoutCallback();
            },
          ),
        ],
      ),
    );
  }
}
