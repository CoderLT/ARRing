//
//  ATApi_h
//  AT
//
//  Created by CoderLT on 16/2/23.
//  Copyright © 2016年 AT. All rights reserved.
//

#ifndef ATApi_h
#define ATApi_h
#import "ATOnline.h"

#define APP_ID          @"1170995046"//https://itunes.apple.com/cn/app/idxxxs?mt=8



#define ATBaseURL               [ATOnline baseURL]
#define ATAPI_BASEURL_ONLINE    @"https://app.roopto.com/"
#define ATAPI_BASEURL_DEBUG     @"https://app.roopto.com/"
#define AT_UPDATE               @"https://app.roopto.com/home/app-download"

#define AT_HTML_AGREEMENT       @"https://app.roopto.com/home/userTerm"
#define VR_HTML_FAQ             @"xxx"

#define VR_SALE_VERSION       @"xxx"



#define TE_CODE_SUCCESS (100) //'101:请先登录'
#define TE_CODE_UNLOGIN (101) //'101:请先登录'

// 登录相关
#define LJ_REGISTER_DEVICE    @"xxx"
#define LJ_GETSMSCODE_LOGIN   @"xxx"
#define LJ_GETVOLCODE_LOGIN   @"xxx"
#define LJ_RENEWAL_TOKEN      @"xxx"
#define LJ_LOGOUT             @"xxx"


#define TE_REGISTER_PHONE     @"api/auth-register"
#define TE_LOGIN_OTHER        @"api/auth-thirdLogin"
#define TE_LOGIN_PWD          @"api/auth-login"
#define TE_GET_SMSCODE        @"api/auth-sendSms"
#define TE_CHECK_SMSCODE      @"api/auth-verifySms"

// 用户相关
#define TE_GET_USERINFO       @"api/user-info"
#define TE_SET_USERINFO       @"api/user-updateInfo"
#define TE_SET_USERAVATAR     @"api/user-setAvatar"
#define TE_SET_PASSWORD       @"api/user-pass"
#define TE_SET_PSW_PHONOE     @"api/auth-findPass"
#define TE_GET_ADDR           @"api/address-all"
#define TE_GET_RYTOKEN        @"api/user-getRyToken"

#define TE_SEARCH_ADDRESS     @"api/address-search"
#define TE_SEARCH_DORTORS     @"api/doctor-search"
#define TE_GET_DORTORS        @"api/doctor-list"
#define TE_GET_DORTORINFO     @"api/doctor-info"
#define TE_GET_TIPS           @"api/tip-list"
#define TE_GET_TIPSLAST       @"api/tip-last"
#define TE_GET_TIPRAND        @"api/tip-rand"
#define TE_GET_ABOUT          @"home/about"

#define LJ_SET_USERSignature  @"xxx"
#define LJ_SET_USERBGIMAGE    @"xxx"
#define LJ_GETSMSCODE_BINDING @"xxx"
#define LJ_GETVOLCODE_BINDING @"xxx"
#define LJ_BINDING_PHONE      @"xxx"

#define APP_NAME ([UIApplication sharedApplication].appBundleName)

#ifdef DEBUG
#define RCIM_APPKEY         @"8brlm7ufrfwm3"//@"8luwapkvuv3al"
#define RCIM_APPSEC         @"yothbC82GKJhnA"//@"JANcOfJ0QqEc"
#else
#define RCIM_APPKEY         @"8brlm7ufrfwm3"
#define RCIM_APPSEC         @"yothbC82GKJhnA"
#endif

#define WECHAT_APPID        @"wx7236fc4970f275ae"
#define WECHAT_APPSEC       @"1a83fd9c71ac984bc596554a3b637ed8"

#define QQ_APPID            @"1106097548"// QQ41EDB58C
#define QQ_APP_KEY          @"QoMU4XWvsJ1oJoVk"
#define QQ_APP_URL          @"https://www.roopto.com"


#define AMAP_KEY            @"7aa90d7bf35eb2c9995a958bac9d12bb"

#define SINA_APPID          @"1271012320"
#define SINA_APP_SEC        @"153d6dc7f156002b487908b63be7b95a"
#define SINA_APP_CALLBACK   @"http://sns.whalecloud.com/sina2/callback"

#define UMAppKey            @"58d20d68c89576775300040f"
#define UMAppSec            @"xxx"

#define APP_UPDATE          @"https://app.roopto.com/home/app-download"

#endif /* CFQApi_h */
