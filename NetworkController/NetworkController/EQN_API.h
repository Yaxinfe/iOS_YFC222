//
//  EQN_API.h
//  LyChee
//
//  Created by Superman on 12/19/14.
//  Copyright (c) 2014 LyChee. All rights reserved.
//

#ifndef RPG_EQN_API_h
#define RPG_EQN_API_h

//#define SERVER                      @"http://192.168.2.44/yuyufifa/index.php/mobile"
#define SERVER                      @"http://123.57.173.92/backend/index.php/mobile"

//Online State
#define LC_ONLINE_STATE              [NSString stringWithFormat: @"%@/user/online_status", SERVER]

//ADS
#define LC_FIRST_ADSLIST             [NSString stringWithFormat: @"%@/user/firstrun_ad", SERVER]
#define LC_DAILY_ADSLIST             [NSString stringWithFormat: @"%@/user/dailyrun_ad", SERVER]

//LogIn and SignUp, Signout
#define LC_SIGNUP_CHECKNAME          [NSString stringWithFormat: @"%@/user/check_username", SERVER]
#define LC_CHECKNICKNAME             [NSString stringWithFormat: @"%@/user/check_nickname", SERVER]
#define LC_SIGNUP                    [NSString stringWithFormat: @"%@/user/check_phonenumber_for_signup", SERVER]
#define LC_LOGIN                     [NSString stringWithFormat: @"%@/user/signin", SERVER]
#define LC_USERVERIFY                [NSString stringWithFormat: @"%@/user/verify_user", SERVER]
#define LC_SIGNOUT                   [NSString stringWithFormat: @"%@/user/signout", SERVER]
#define LC_SEND_VERIFY               [NSString stringWithFormat: @"%@/user/send_verifycode", SERVER]

//Social Login
#define LC_QQ_LOGIN                  [NSString stringWithFormat: @"%@/user/signin_qq", SERVER]
#define LC_WEIBO_LOGIN               [NSString stringWithFormat: @"%@/user/signin_weibo", SERVER]
#define LC_WECHAT_LOGIN              [NSString stringWithFormat: @"%@/user/signin_wechat", SERVER]
#define LC_SOCIAL_SIGNUP             [NSString stringWithFormat: @"%@/user/singup_social", SERVER]

//NEWS
#define LC_NEWS                      [NSString stringWithFormat: @"%@/news/news_home", SERVER]
#define LC_NEWS_COMMENTS             [NSString stringWithFormat: @"%@/news/news_comment_list", SERVER]
#define LC_NEWS_LOADMORE             [NSString stringWithFormat: @"%@/news/news_home", SERVER]
#define LC_NEWS_DETAIL               [NSString stringWithFormat: @"%@/news/news_detail", SERVER]
#define LC_NEWS_LIKE                 [NSString stringWithFormat: @"%@/news/news_like", SERVER]
#define LC_NEWS_UNLIKE               [NSString stringWithFormat: @"%@/news/news_unlike", SERVER]
#define LC_NEWS_LEAVE_COMMENT        [NSString stringWithFormat: @"%@/news/news_leave_comment", SERVER]
#define LC_NEWS_LEAVE_REPLY          [NSString stringWithFormat: @"%@/news/news_leave_reply", SERVER]
#define LC_NEWS_LOAD_MORE_COMMENT    [NSString stringWithFormat: @"%@/news/news_comment_list", SERVER]

//Member List
#define LC_MEMBER_LIST               [NSString stringWithFormat: @"%@/club/player_list", SERVER]

//BroadCast
#define LC_BroadCast_LIST            [NSString stringWithFormat: @"%@/voice/live_broadcast", SERVER]
#define LC_BroadCast_GIGUM           [NSString stringWithFormat: @"%@/gigum/live_gigum", SERVER]

#define LC_BroadCast_LEAVE_MESSAGE   [NSString stringWithFormat: @"%@/voice/leave_message", SERVER]
#define LC_BroadCast_LOAD_MESSAGE    [NSString stringWithFormat: @"%@/voice/load_newmessage", SERVER]
#define LC_BroadCast_ALLMESSAGE      [NSString stringWithFormat: @"%@/voice/load_lastmessages", SERVER]
#define LC_BroadCast_JOIN_LIVE       [NSString stringWithFormat: @"%@/voice/join_livevideo", SERVER]
#define LC_BroadCast_EXIT_LIVE       [NSString stringWithFormat: @"%@/voice/exit_livevideo", SERVER]

//Fan Voice
#define LC_FANVOICE_LIST             [NSString stringWithFormat: @"%@/voice/fan_voice_list", SERVER]
#define LC_FANVOICE_SEND_VIDEO       [NSString stringWithFormat: @"%@/voice/upload_video", SERVER]

//Game
#define LC_GAME_GAMERESULT           [NSString stringWithFormat: @"%@/game/game_result", SERVER]
#define LC_GAME_GAMERESULT_ROUND     [NSString stringWithFormat: @"%@/game/round_result", SERVER]
#define LC_GAME_GAMEPLAN             [NSString stringWithFormat: @"%@/game/game_plan", SERVER]
#define LC_GAME_POINTORDER           [NSString stringWithFormat: @"%@/game/point_order", SERVER]
#define LC_GAME_TOPPLAYER            [NSString stringWithFormat: @"%@/game/top_player", SERVER]

//Charge
#define LC_CHARGE_BALL               [NSString stringWithFormat: @"%@/user/charge_ball", SERVER]

//GIGUM
#define LC_GENERAL_GIGUM             [NSString stringWithFormat: @"%@/gigum/general_gigum", SERVER]
#define LC_TOPGIGUM_LIST             [NSString stringWithFormat: @"%@/gigum/top_gigum_list", SERVER]
#define LC_GIGUM_HISTORY             [NSString stringWithFormat: @"%@/gigum/gigum_history", SERVER]
#define LC_QUNGJEN_HISTORY           [NSString stringWithFormat: @"%@/gigum/charge_history", SERVER]

//Shopping
#define LC_SHOP_PRODUCTS             [NSString stringWithFormat: @"%@/shop/product_list", SERVER]
#define LC_SHOP_PRODUCTDETAIL        [NSString stringWithFormat: @"%@/shop/product_detail", SERVER]
#define LC_SHOP_ADDBASKET            [NSString stringWithFormat: @"%@/shop/product_addcart", SERVER]
#define LC_SHOP_BASKETLIST           [NSString stringWithFormat: @"%@/shop/product_cartlist", SERVER]
#define LC_SHOP_DELETEBASKET         [NSString stringWithFormat: @"%@/shop/product_deletecart", SERVER]
#define LC_SHOP_BUY_CARTLIST         [NSString stringWithFormat: @"%@/shop/buy_cartitems", SERVER]

#define LC_SHOP_COMPLETE_LIST        [NSString stringWithFormat: @"%@/shop/history_completed", SERVER]
#define LC_SHOP_PROCESS_LIST         [NSString stringWithFormat: @"%@/shop/history_processing", SERVER]
#define LC_SHOP_BUY_ITEM             [NSString stringWithFormat: @"%@/shop/buy_item", SERVER]
#define LC_SHOP_BUY_CART             [NSString stringWithFormat: @"%@/shop/buy_cartitems", SERVER]

#define LC_SHOP_PRODUCT_COMMENT      [NSString stringWithFormat: @"%@/shop/comment_list", SERVER]
#define LC_SHOP_LEAVE_COMMENT        [NSString stringWithFormat: @"%@/shop/leave_comment", SERVER]

#define LC_SHOP_HISTORY_COMPLETE     [NSString stringWithFormat: @"%@/shop/history_completed", SERVER]
#define LC_SHOP_HISTORY_ADDRESS      [NSString stringWithFormat: @"%@/shop/destination_list", SERVER]
#define LC_SHOP_HISTORY_BAEDAL       [NSString stringWithFormat: @"%@/shop/history_processing", SERVER]

#define LC_SHOP_HISTORY_DELETE       [NSString stringWithFormat: @"%@/shop/history_delete", SERVER]
#define LC_SHOP_ADDRESS_DELETE       [NSString stringWithFormat: @"%@/shop/destination_delete", SERVER]

#define LC_SHOP_ADD_ADDRESS          [NSString stringWithFormat: @"%@/shop/destination_add", SERVER]
#define LC_SHOP_GET_ADDRESS          [NSString stringWithFormat: @"%@/other/province_list", SERVER]

//Settings
#define LC_SETTINGS_CHANGEIMAGE      [NSString stringWithFormat: @"%@/user/update_profileimage", SERVER]
#define LC_SETTINGS_UPDATE           [NSString stringWithFormat: @"%@/user/update_profile", SERVER]
#define LC_SETTINGS_CHANGEPASS       [NSString stringWithFormat: @"%@/user/update_password", SERVER]

#endif