part of 'auth_screen.dart';

class ConnectToStripeScreen extends StatelessWidget {
  ConnectToStripeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldStateKey,
      appBar: DashboardAppBar(
        scaffoldStateKey: scaffoldStateKey,
      ),
      drawer: DashboardDrawer(
        scaffoldStateKey: scaffoldStateKey,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: AppColors.oceanBlue,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "Connect to Stripe",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ).paddingOnly(bottom: 5.h),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "Connect and set up a payment method in Stripe.",
                      fontSize: 12.sp,
                      color: AppColors.oceanBlue,
                    ),
                  ],
                ).paddingOnly(bottom: 20.h),
                AppCommonImage(
                  width: 100.h,
                  height: 100.h,
                  imagePath: AppImagesPath.connectToStripe,
                ).paddingOnly(bottom: 20.h),
              ],
            ),
          ).paddingOnly(
            bottom: 20.h,
            top: AppConfig.height * 0.2,
          ),
          AppCommonButton(
            context: context,
            title: "Connect",
            width: AppConfig.width * 0.8,
            onTap: () {
                context.push(const ConnectToStripeContent());
            },
          )
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}

class ConnectToStripeContent extends StatefulWidget {
  const ConnectToStripeContent({super.key});

  @override
  ConnectToStripeContentState createState() =>
      ConnectToStripeContentState();
}

class ConnectToStripeContentState extends State<ConnectToStripeContent> {
  final GlobalKey webViewKey = GlobalKey();

  web.InAppWebViewController? webViewController;
  web.InAppWebViewSettings settings = web.InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  web.PullToRefreshController? pullToRefreshController;

  late web.ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = web.ContextMenu(
        menuItems: [
          web.ContextMenuItem(
              id: 1,
              title: "Special",
              action: () async {
                infoLog("Menu item Special clicked!");
                infoLog(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        settings:
        web.ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          infoLog("onCreateContextMenu");
          infoLog(hitTestResult.extra);
          infoLog(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          infoLog("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.id;
          infoLog("$id ${contextMenuItemClicked.title}",
              fun: "onContextMenuActionItemClicked:");
        });

    pullToRefreshController = kIsWeb ||
        ![TargetPlatform.iOS, TargetPlatform.android]
            .contains(defaultTargetPlatform)
        ? null
        : web.PullToRefreshController(
      settings: web.PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS) {
          webViewController?.loadUrl(
              urlRequest:
              web.URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    webViewController?.loadUrl(
        urlRequest: web.URLRequest(url: web.WebUri(/*StripeKeys.connectUrl*/"www.google.com")));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            web.InAppWebView(
              key: webViewKey,
              initialUrlRequest:
              web.URLRequest(url: web.WebUri(/*StripeKeys.connectUrl*/"www.google.com")),
              initialUserScripts: UnmodifiableListView<web.UserScript>([]),
              initialSettings: settings,
              contextMenu: contextMenu,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) async {
                webViewController = controller;
              },
              onLoadStart: (controller, url) async {
                printLog('allowing navigation to ${url?.host}');
                final code = url?.queryParameters['code'];
                errorLog('Code :::::::::::::: >>>> $code');
                if (code != null && code.isNotEmpty) {
                  // context.read<StripeConnectionBloc>().editStripeDetail(
                  //     FormData.fromMap({"stripe_response": code}));
                }
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onPermissionRequest: (controller, request) async {
                return web.PermissionResponse(
                    resources: request.resources,
                    action: web.PermissionResponseAction.GRANT);
              },
              shouldOverrideUrlLoading:
                  (controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  errorLog(uri.host, fun: "Host >>>>>>>");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                    );
                    // and cancel the request
                    return web.NavigationActionPolicy.CANCEL;
                  }
                }

                return web.NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, isReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                infoLog(consoleMessage);
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}
