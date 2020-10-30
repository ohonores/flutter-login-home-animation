import 'package:flutter/material.dart';
import '../../helper/constant.dart';
import '../../helper/enum.dart';
import '../../helper/theme.dart';
import '../../model/feedModel.dart';
import '../../state/authState.dart';
import '../../state/feedState.dart';
import '../../widgets/customWidgets.dart';
import '../../widgets/newWidget/customLoader.dart';
import '../../widgets/newWidget/emptyList.dart';
import '../../widgets/tweet/tweet.dart';
import '../../widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
      },
      /*child: customIcon(
        context,
        icon: AppIcon.fabTweet,
        istwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),*/
      label: Text('Publicar!'),
      icon: Icon(
        Icons.chat,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      //backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      tooltip: 'Publicar!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(context),
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: Container(
          height: fullHeight(context),
          width: fullWidth(context),
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              /// refresh home page feed
              var feedState = Provider.of<FeedState>(context, listen: false);
              feedState.getDataFromDatabase();
              return Future.value(true);
            },
            child: _FeedPageBody(
              refreshIndicatorKey: refreshIndicatorKey,
              scaffoldKey: scaffoldKey,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedPageBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const _FeedPageBody({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);
  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: customInkWell(
        context: context,
        onPressed: () {
          /// Open up sidebaar drawer on user avatar tap
          scaffoldKey.currentState.openDrawer();
        },
        child:
            customImage(context, authState.userModel?.profilePic, height: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Consumer<FeedState>(
      builder: (context, state, child) {
        final List<FeedModel> list = state.getTweetList(authstate.userModel);
        return CustomScrollView(
          slivers: <Widget>[
            child,
            state.isBusy && list == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: fullHeight(context) - 135,
                      child: CustomScreenLoader(
                        height: double.infinity,
                        width: fullWidth(context),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : !state.isBusy && list == null
                    ? SliverToBoxAdapter(
                        child: EmptyList(
                          'Aun no ha comentado',
                          subTitle:
                              'Cuando un nuevo comentario es agregado, Aqui lo veran \n Click sobre Comenta! para que puedas opinar',
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          list.map(
                            (model) {
                              return Container(
                                color: Colors.white,
                                child: Tweet(
                                  model: model,
                                  trailing: TweetBottomSheet().tweetOptionIcon(
                                    context,
                                    model,
                                    TweetType.Tweet,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
          ],
        );
      },
      child: SliverAppBar(
        floating: true,
        elevation: 10,
        expandedHeight: 50.0,
        leading: _getUserAvatar(context),
        pinned: true,
        snap: true,
        //    title: customTitleText('HOME'),
        flexibleSpace: Stack(
          children: <Widget>[
            /*Container(
              height: 140,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.lightGreenAccent, Colors.green],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
              padding: EdgeInsets.all(15),
              constraints: BoxConstraints(maxHeight: 150),
              child: Image.asset(
                "assets/logo_rcpng.png",
                // height: 50,
                //fit: BoxFit.cover,
              ),
            )*/
            Container(
                alignment: FractionalOffset(0.5, 0.5),
                padding: EdgeInsets.all(1),
                child: Image.asset(
                  "assets/logo_rcpng.png",
                  height: 30,
                  fit: BoxFit.contain,
                ))
          ],
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).appBarTheme.color,

        bottom: PreferredSize(
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(0.0),
        ),
      ),
    );
  }
}
