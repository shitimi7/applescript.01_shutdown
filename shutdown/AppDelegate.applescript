--
--  AppDelegate.applescript
--  shutdown
--
--  Created by 七味 on 2014/11/01.
--  Copyright (c) 2014 www.e-norichan.net. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
    
    -- github 確認用
    
    -- タイマー関連変数定義
    property NSTimer : class "NSTimer"
    property updateInterval : 1 --チェック間隔　単位：秒
    property updateTimer : missing value
	
	-- IBOutlets
	property window : missing value
	property int_shutdownhour : missing value -- タイマー時間コントロール
    property int_remainhours : missing value -- 残り時間
	property int_remainseconds : missing value -- 残り秒数
    property date_shutdowndate : missing value -- 残り時間日付形式
	property bool_f : false -- セット判定
	
	property set_button : missing value -- セットボタンコントロール
    property txt_remaintime : missing value -- 残り時間表示用コントロール
	
    -- セットボタンクリック処理
	on setShutdownTime_(sender)
		set int_remainhours to stringValue of int_shutdownhour as integer
		
        --設定値（時間）を秒へ変換
        set int_remainseconds to 60 * 60 * int_remainhours
        --デバッグ用に設定値を分単位に仮定する
        --set int_remainseconds to 60 * int_remainhours
        
        set date_shutdowndate to current date + int_remainseconds
		
		if (bool_f) then
			set_button's setTitle_("セット")
            set stringValue of txt_remaintime to ""
			set bool_f to false
		else
			set_button's setTitle_("キャンセル")
			set bool_f to true
		end if
        
        if(bool_f) then
            set updateTimer to NSTimer's scheduledTimerWithTimeInterval_target_selector_userInfo_repeats_(updateInterval, me, "checkShutdownTime_", missing value, true)
        else
            stopShutdownTime_()
        end if
		
	end setShutdownTime_
    
    --タイマーをセットした際の時間チェック&シャットダウン関数
    on checkShutdownTime_()
        if(current date > date_shutdowndate) then
            stopShutdownTime_()
            tell application "System Events"
              shut down
            end tell
        else
            --残り時間の表示設定
            set int_remainseconds to date_shutdowndate - (current date)
            set txt_remainhours to text -2 thru -1 of ("0" & int_remainseconds/(60*60) div 1)
            set txt_remainminutes to text -2 thru -1 of ("0" & (int_remainseconds mod (60*60))/60 div 1)
            set txt_remainseconds to text -2 thru -1 of ("0" & (int_remainseconds mod 60 div 1))
            set stringValue of txt_remaintime to txt_remainhours & ":" & txt_remainminutes & ":" & txt_remainseconds
        end if
    end checkShutdownTime_
    
    --キャンセル処理関数
    on stopShutdownTime_()
        tell updateTimer to invalidate()
        set updateTimer to missing value
    end stopShutdownTime_
	
    
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened
		set stringValue of int_shutdownhour to "1"
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
end script