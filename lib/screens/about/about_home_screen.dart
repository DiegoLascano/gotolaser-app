import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/app_images.dart';
import 'package:go_to_laser_store/styles/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutHomeScreen extends StatelessWidget {
  final String instagramUrl = "https://www.instagram.com/gotolaser/";
  final String facebookUrl = "https://www.facebook.com/gotolaser";
  final String siteUrl = "https://www.gotolaser.com/";

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 10.0),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        gradient: LinearGradient(
          colors: [
            AppColors.buttonGradientStart,
            AppColors.buttonGradientEnd,
          ],
        ),
      ),
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Go-To Laser',
              style: Theme.of(context).textTheme.headline2.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tu proveedor de corte \nláser más confiable',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          _buildIntroduction(context),
          _buildLinks(context),
        ],
      ),
    );
  }

  Widget _buildIntroduction(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          TextSpan(
            text:
                'Bienvenidos al catálogo digital interactivo de Go-To Láser.\n',
          ),
          TextSpan(
            text: 'Contamos con una tienda virtual donde podrás encontrar '
                'gran variedad de productos diseñados y fabricados mediante '
                'corte láser.\n\n',
          ),
          TextSpan(
            text: 'Go-To Láser es una iniciativa familiar que busca brindar '
                'nuevas herramientas a las personas emprendedoras, '
                'proveyendo de diseños exclusivos para el sector de '
                'detalles y decoraciones.',
          ),
        ],
      ),
    );
  }

  Widget _buildLinks(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildLink(
          context: context,
          title: 'www.gotolaser.com',
          url: siteUrl,
          icon: FaIcon(
            FontAwesomeIcons.store,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        _buildLink(
          context: context,
          title: '@gotolaser',
          url: instagramUrl,
          icon: FaIcon(
            FontAwesomeIcons.instagram,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        _buildLink(
          context: context,
          title: '@gotolaser',
          url: facebookUrl,
          icon: FaIcon(
            FontAwesomeIcons.facebookSquare,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLink({
    BuildContext context,
    Widget icon,
    String title,
    String url,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: AppColors.primary,
              ),
        ),
        onTap: () => _launchURL(url),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        tileColor: AppColors.secondary,
        dense: true,
      ),
    );
  }
}
