﻿option explicit

' timeago
' Author: qiuqiu

' This is a script for Directory Opus.
' See https://www.gpsoft.com.au/DScripts/redirect.asp?page=scripts for development information.



' Called by Directory Opus to initialize the script
Function OnInit(initData)
	with initData
		.name           = "Displays the age of the file"
		.version        = "1.0"
		.copyright      = "qiuqiu"
		.desc           = DOpus.Strings.Get("desc")
		.url            = "http://script.dopus.net/"
		.default_enable = True
		.min_version    = "12.0"
		.Config.Decimal = 0

		with .AddColumn
			.name        = "Create_At"
			.method      = "On_timeago"
			.label       = DOpus.Strings.Get("CreateAt")
			.justify     = "right"
			.type        = "text"
			.multicol    = True
			.autogroup   = True
			.autorefresh = True
		end with

		with .AddColumn
			.name        = "Modify_At"
			.method      = "On_timeago"
			.label       = DOpus.Strings.Get("ModifyAt")
			.justify     = "right"
			.type        = "text"
			.multicol    = True
			.autogroup   = True
			.autorefresh = True
		end with
	end with
End Function

Function IIf(ByVal Expression, ByVal TruePart, ByVal FalsePart)
    If Expression Then
		If IsObject(TruePart)  Then Set IIf = TruePart  Else IIf = TruePart
	Else
		If IsObject(FalsePart) Then Set IIf = FalsePart Else IIf = FalsePart
	End If
End Function

sub ShowMessageDialog(ByVal message, ByVal buttons,ByVal title, Byval window,  ByVal icon)
    with DOpus.Dlg
        .window  = window
        .message = message
        .title   = title
        .buttons = buttons
        .icon    = icon 'warning, error, info and question
        .Show
    end with
end sub

'PHP Time Ago Function
'https://phppot.com/php/php-time-ago-function/
'https://css-tricks.com/snippets/php/time-ago-function/

Function TimeAgo(Byval Ddate)
	Dim Periods, Lengths, Diff, Ago, AgoMap, Index, Recent
	
	Recent  = Split(Dopus.Strings.Get("Recent"), ",")
	Periods = Split(Dopus.Strings.Get("Periods"), ",")
	Agomap  = Split(Dopus.Strings.Get("At"), ",")
	Lengths = Array(60, 60, 24, 7, 365.25/7/12, 12)
	
	Diff = Abs(Datediff("S", Ddate, Now()))
	If Ddate > Now() Then Ago = 1 Else Ago = 0
	
	For Index = 0 To Ubound(Lengths)
		If Diff >= Lengths(Index) Then
			Diff = Diff / Lengths(Index)
		Else
			Exit For
		End If
	Next
	If Index > 1 Then Diff = Round(Diff, Script.Config.Decimal) Else Diff = Int(Diff)
	If Index Then TimeAgo = Diff & Periods(Index) & AgoMap(Ago) Else TimeAgo = Recent(Ago)
End Function

' Implement the timeago column
Function On_timeago(ColData)
	dim CreateDate, ModifyDate, CreateDiff, ModifyDiff
	On Error Resume Next 
	CreateDate = ColData.item.Create
	ModifyDate = ColData.item.Modify
	
	CreateDiff = DateDiff("s", CreateDate, Now())
	ModifyDiff = DateDiff("s", ModifyDate, Now())

	ColData.Columns("Create_At").Value = timeAgo(CreateDate)
	ColData.Columns("Create_At").Sort  = CreateDiff

	ColData.Columns("Modify_At").Value = timeAgo(ModifyDate)
	ColData.Columns("Modify_At").Sort  = ModifyDiff
End Function

' Called to display an About dialog for this script
Function OnAboutScript(aboutData)
    'Dopus.Dlg.Request DOpus.Strings.Get("desc"), "OK", "About", aboutData.window
    ShowMessageDialog DOpus.Strings.Get("desc"), "OK", "About", aboutData.window, "info"
End Function

==SCRIPT RESOURCES
<resources>
    <resource type = "Strings">
        <Strings lang = "english">
            <string id = "CreateAt" text = "Create At" />
            <string id = "ModifyAt" text = "Modify At" />
            <string id = "Recent"   text = "just now, right now" />
            <string id = "at"       text = " Ago, Later" />
            <string id = "periods"  text = " second, minute, hour, day, week, month, year" />
            <string id = "desc"     text = "format file create(modify) date with '*** time ago' statement. eg: '3 hours ago'." />
		</Strings>
		<Strings lang = "chs">
			<string id = "CreateAt" text = "创建于" />
            <string id = "ModifyAt" text = "修改于" />
            <string id = "Recent"   text = "刚刚, 片刻后" />
            <string id = "at"       text = "前,后" />
            <string id = "periods"  text = " 秒, 分钟, 小时, 天, 周, 月, 年" />
            <string id = "desc"     text = "格式化文件创建 (修改) 日期 '** 时间前' 例如:3小时前。" />
        </Strings>
    </resource>
</resources>

