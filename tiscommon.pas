unit tiscommon;
{ -----------------------------------------------------------------------
#    This file is part of WAPT
#    Copyright (C) 2013  Tranquil IT Systems http://www.tranquil.it
#    WAPT aims to help Windows systems administrators to deploy
#    setup and update applications on users PC.
#
#    Part of this file is based on JEDI JCL library
#
#    WAPT is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    WAPT is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with WAPT.  If not, see <http://www.gnu.org/licenses/>.
#
# -----------------------------------------------------------------------
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,tisstrings,Process
  {$ifdef windows}, Windows,JwaWindows {$endif}
  ;

Procedure UnzipFile(ZipFilePath,OutputPath:Utf8String);
procedure AddToSystemPath(APath:Utf8String);

procedure UpdateCurrentApplication(fromURL:Utf8String;Restart:Boolean;restartparam:Utf8String);
procedure UpdateApplication(fromURL:Utf8String;SetupExename,SetupParams,ExeName,RestartParam:Utf8String);

function SortableVersion(VersionString:String):String;
function CompareVersion(const v1,v2:String):integer;

function GetComputerName : String;
function GetUserName : String;
function GetWorkgroupName: String;
function GetDomainName: String;
function UserInGroup(Group :DWORD) : Boolean;

{$ifdef windows}
function IsWin64: Boolean;

Procedure AddToUserPath(APath:Utf8String);

function GetComputerNameExString(ANameFormat: COMPUTER_NAME_FORMAT): WideString;
procedure SetComputerName(newname:WideString);
procedure SetComputerNameEx(newname:WideString;ANameFormat: COMPUTER_NAME_FORMAT );

function EnablePrivilege(const Privilege: string; fEnable: Boolean; out PreviousState: Boolean): DWORD;
function AddUser(const Server, User, Password: WideString): NET_API_STATUS;
function DelUser(const Server, User: WideString): NET_API_STATUS;
function RemoveFromGroup(const Server, User, Group: WideString): NET_API_STATUS;
function GetAccountSid(const Server, User: WideString; var Sid: PSID): DWORD;
function GetAccountSidString(const Server, User: WideString):String;
function StrSIDToName(const StrSID: AnsiString; var Name: Ansistring; var SIDType: DWORD): Boolean;
function SIDToStringSID(const aSID:PSID): String;
function AddToGroup(const member, Group: WideString): NET_API_STATUS;
function UserModalsGet(const Server: String): USER_MODALS_INFO_0;

// Return domain name
function DomainGet: String;

// Return current domain sid
function DomainSID: String;

// Return the NetBIOS name of the domain or workgroup to which the computer is joined
function GetJoinInformation:String;

function IsAdmin: LongBool;
function GetAdminSid: PSID;

{$endif}

function CheckOpenPort(dwPort : Word; ipAddressStr:AnsiString;timeout:integer=5000):boolean;
function GetFreeLocalPort( portStart : Word = 5000; portEnd : Word = 10000):Word;
function GetIPFromHost(const HostName: ansistring): ansistring;

function MakePath(const parts:array of Utf8String):Utf8String;
function RunTask(cmd: utf8string;var ExitStatus:integer;WorkingDir:utf8String='';ShowWindow:TShowWindowOptions=swoHIDE): utf8string;

{$ifdef windows}
function GetSystemProductName: String;
function GetSystemManufacturer: String;
function GetBIOSVendor: String;
function GetBIOSVersion: String;
function GetBIOSDate:AnsiString;

procedure SetComputerDescription(desc:String);
function ComputerDescription:String;

function  GetApplicationVersion(FileName:Utf8String=''): Utf8String;

function GetOSVersionInfo: TOSVersionInfoEx;
function IsWinXP:Boolean;


function GetPersonalFolder:Utf8String;
function GetLocalAppdataFolder:Utf8String;
function GetAppdataFolder:Utf8String;

Function GetAppUserFolder:Utf8String;

function GetStartMenuFolder: Utf8String;
function GetCommonStartMenuFolder: Utf8String;
function GetStartupFolder: Utf8String;
function GetCommonStartupFolder: Utf8String;

function GetUniqueTempdir(Prefix: Utf8String): Utf8String;

function Appuserinipath:Utf8String;

const
  NameUnknown       = 0; // Unknown name type.
  NameFullyQualifiedDN = 1; // Fully qualified distinguished name
  NameSamCompatible = 2; // Windows NT® 4.0 account name
  NameDisplay       = 3; // A "friendly" display name
  NameUniqueId      = 6; // GUID string that the IIDFromString function returns
  NameCanonical     = 7; // Complete canonical name
  NameUserPrincipal = 8; // User principal name
  NameCanonicalEx   = 9;
  NameServicePrincipal = 10; // Generalized service principal name
  DNSDomainName     = 11; // DNS domain name, plus the user name

function GetCurrentUserName(fFormat: DWORD=NameSamCompatible) : Ansistring;
function GetCurrentUserSid: Ansistring;

procedure SetUserProfilePath(SID:String;ImagePath:String);
function GetUserProfilePath(SID:String):String;

function UserLogin(user,password,domain:String):THandle;
function UserDomain(htoken:THandle):AnsiString;
function OnSystemAccount: Boolean;

function GetGroups(srvName, usrName: WideString):TDynStringArray;
function GetLocalGroups:TDynStringArray;
function GetLocalGroupMembers(GroupName:WideString):TDynStringArray;

function GetCmdParams(ID:Utf8String;Default:Utf8String=''):Utf8String;

{
Function Wow64DisableWow64FsRedirection(Var Wow64FsEnableRedirection: LongBool): LongBool; StdCall;
  External 'Kernel32.dll' Name 'Wow64DisableWow64FsRedirection';
Function Wow64EnableWow64FsRedirection(Wow64FsEnableRedirection: LongBool): LongBool; StdCall;
  External 'Kernel32.dll' Name 'Wow64EnableWow64FsRedirection';
}

{Const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS     = $00000220;
  DOMAIN_ALIAS_RID_USERS      = $00000221;
  DOMAIN_ALIAS_RID_GUESTS     = $00000222;
  DOMAIN_ALIAS_RID_POWER_USERS= $00000223;
}
const
  CSIDL_LOCAL_APPDATA = $001c;
  strnShellFolders = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';


type
  TServiceState =
   (ssUnknown,         // Just fill the value 0
    ssStopped,         // SERVICE_STOPPED
    ssStartPending,    // SERVICE_START_PENDING
    ssStopPending,     // SERVICE_STOP_PENDING
    ssRunning,         // SERVICE_RUNNING
    ssContinuePending, // SERVICE_CONTINUE_PENDING
    ssPausePending,    // SERVICE_PAUSE_PENDING
    ssPaused);         // SERVICE_PAUSED

  TServiceStates = set of TServiceState;

const
  ssPendingStates = [ssStartPending, ssStopPending, ssContinuePending, ssPausePending];

function IsAdminLoggedOn: Boolean;
function ProcessExists(ExeFileName: string): boolean;
function KillTask(ExeFileName: string): integer;

function GetServiceStatusByName(const AServer,AServiceName:ansistring):TServiceState;
function StartServiceByName(const AServer,AServiceName: AnsiString):Boolean;
function StopServiceByName(const AServer, AServiceName: AnsiString):Boolean;
{$endif}

implementation

uses registry,LazFileUtils,LazUTF8, zipper,tiswinhttp,tislogging
    {$ifdef windows}
    ,shlobj,winsock2
    {$endif}
    {$ifdef unix}
    , baseunix, cnetdb, errors, sockets, unix
    {$endif}
    ;

function MakePath(const parts:array of Utf8String):Utf8String;
var
  i:integer;
begin
  result := '';
  for i:=low(parts) to high(parts) do
  begin
    result := Result+parts[i];
    if (i<High(parts)) and (parts[i][length(parts[i])] <> PathDelim) then
      result := result+PathDelim;
  end;
end;

{$ifdef windows}
function IsAdminLoggedOn: Boolean;
{ Returns True if the logged-on user is a member of the Administrators local
  group. Always returns True on Windows 9x/Me. }
const
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
begin
  Result := UserInGroup(DOMAIN_ALIAS_RID_ADMINS);
end;

function GetSystemProductName: String;
const
  WinNT_REG_PATH = 'HARDWARE\DESCRIPTION\System\BIOS';
  WinNT_REG_KEY  = 'SystemProductName';
var
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey(WinNT_REG_PATH,False) then
       Result := reg.ReadString(WinNT_REG_KEY)
    else
        Result :='';
  finally
    reg.Free;
  end;
end;

function GetSystemManufacturer: String;
const
  WinNT_REG_PATH = 'HARDWARE\DESCRIPTION\System\BIOS';
  WinNT_REG_KEY  = 'SystemManufacturer';
var
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey(WinNT_REG_PATH,False) then
       Result := reg.ReadString(WinNT_REG_KEY)
    else
        Result :='';
  finally
    reg.Free;
  end;
end;

function GetBIOSVendor: String;
const
  WinNT_REG_PATH = 'HARDWARE\DESCRIPTION\System\BIOS';
  WinNT_REG_KEY  = 'BIOSVendor';
var
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey(WinNT_REG_PATH,False) then
       Result := reg.ReadString(WinNT_REG_KEY)
    else
        Result :='';
  finally
    reg.Free;
  end;
end;

function GetBIOSVersion: String;
const
  WinNT_REG_PATH = 'HARDWARE\DESCRIPTION\System\BIOS';
  WinNT_REG_PATH2 = 'HARDWARE\DESCRIPTION\System';
  WinNT_REG_KEY  = 'BIOSVersion';
  WinNT_REG_KEY2  = 'SystemBiosVersion';
var
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey(WinNT_REG_PATH,False) then
       Result := reg.ReadString(WinNT_REG_KEY)
    else
        Result :='';
  finally
    reg.Free;
  end;
end;

function ComputerDescription:String;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('System\CurrentControlSet\Services\lanmanserver\parameters') then
    begin
      Result:=WinCPToUTF8(reg.ReadString('srvcomment'));
    end
    else
      Result :='';
  finally
    reg.Free;
  end;
end;


procedure SetComputerDescription(desc:String);
var
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey('System\CurrentControlSet\Services\lanmanserver\parameters',False) then
      reg.WriteString('srvcomment',UTF8ToWinCP(desc))
  finally
    reg.Free;
  end;
end;
{$endif}


{$ifdef windows}
function GetBIOSDateWindows: AnsiString;
const
  WinNT_REG_PATH = 'HARDWARE\DESCRIPTION\System';
  WinNT_REG_KEY  = 'SystemBiosDate';
  Win9x_REG_PATH = 'Enum\Root\*PNP0C01\0000';
  Win9x_REG_KEY  = 'BiosDate';
var
  R:TRegistry;
begin
  Result := '';
  R :=  TRegistry.Create;
  try
    R.RootKey:=HKEY_LOCAL_MACHINE;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      if R.OpenKey(WinNT_REG_PATH,False) then Result := R.ReadString(WinNT_REG_KEY)
    else
      if R.OpenKey(Win9x_REG_PATH, False) then Result := R.ReadString(Win9x_REG_KEY);
  finally
    R.Free;
  end;
end;
{$endif}

function GetBIOSDate: AnsiString;
begin
  {$ifdef windows}
  Result := GetBIOSDateWindows();
  {$else}
  Result := 'Unknown BIOS version';
  {$endif}
end;

{$ifdef windows}
function UserInGroupWindows(Group :DWORD) : Boolean;
var
  pIdentifierAuthority :TSidIdentifierAuthority;
  apSid : PSID;
  IsMember    : BOOL;
begin
  pIdentifierAuthority := SECURITY_NT_AUTHORITY;
  Result := AllocateAndInitializeSid(@pIdentifierAuthority,2, SECURITY_BUILTIN_DOMAIN_RID, Group, 0, 0, 0, 0, 0, 0, apSid);
  try
    if Result then
      if not CheckTokenMembership(0, apSid, IsMember) then //passing 0 means which the function will be use the token of the calling thread.
         Result:= False
      else
         Result:=IsMember;
  finally
     FreeSid(apSid);
  end;
end;
{$endif}

{$ifdef unix}
function UserInGroupUnix(Group: Integer) : Boolean;
begin
 { TODO }
  Result := False;
end;
{$endif}

function UserInGroup(Group: DWORD): Boolean;
begin
  {$ifdef windows}
  Result := UserInGroupWindows(group);
  {$else}
  Result := UserInGroupUnix(Integer(Group));
  {$endif}
end;

{$ifdef windows}
type
  WinIsWow64 = function( Handle: THandle; var Iret: BOOL ): BOOL; stdcall;
//from http://stackoverflow.com/questions/1436185/how-can-i-tell-if-im-running-on-x64
function IsWin64: Boolean;
var
  HandleTo64BitsProcess: WinIsWow64;
  Iret                 : BOOL;
begin
  Result := False;
  HandleTo64BitsProcess := WinIsWow64(pointer( GetProcAddress(GetModuleHandle('kernel32.dll'), 'IsWow64Process')));
  if Assigned(HandleTo64BitsProcess) then
  begin
    if not HandleTo64BitsProcess(GetCurrentProcess, Iret) then
    Raise Exception.Create('Invalid handle');
    Result := Iret;
  end;
end;

function GetComputerNameExString(ANameFormat: COMPUTER_NAME_FORMAT): WideString;
var
  nSize: DWORD;
begin
  nSize := 1024;
  SetLength(Result, nSize);
  if GetComputerNameExW(ANameFormat, PWideChar(Result), nSize) then
    SetLength(Result, nSize)
  else
    Result := '';
end;

procedure SetComputerNameEx(newname:WideString;ANameFormat: COMPUTER_NAME_FORMAT );
begin
  if not SetComputerNameExW(ANameFormat, PWideChar(newname)) then
    Raise Exception.Create('Unable to set new hostnameEx');
end;

procedure SetComputerName(newname:WideString);
begin
  if not SetComputerNameW(PWideChar(newname)) then
    Raise Exception.Create('Unable to set new hostname');
end;


(*
 * Procedure  : AddUser
 * Author     : MPu
 * Adds a local account
 *)
function AddUser(const Server, User, Password: WideString): NET_API_STATUS;
const
  DOMAIN_GROUP_RID_USERS = $00000201;
var
  ui3               : TUserInfo3;
  NetError          : DWORD;
begin
//  ui3 := nil;
  NetError := 0;
  if User <> '' then
  begin
    ZeroMemory(@ui3, sizeof(TUserInfo3));
    ui3.usri3_name := PWideChar(User);
    ui3.usri3_password := PWideChar(Password);
    ui3.usri3_primary_group_id := DOMAIN_GROUP_RID_USERS;
    NetError := NetUserAdd(PWideChar(Server), 3, @ui3, nil);
  end;
  result := NetError;
end;

(*
 * Procedure  : DelUser
 * Author     : MPu
 * Deletes a local account
 *)
function DelUser(const Server, User: WideString): NET_API_STATUS;
var
  NetError          : DWORD;
begin
  NetError := 0;
  if (User <> '') then
  begin
    NetError := NetUserDel(PWideChar(Server), PWideChar(User));
  end;
  result := NetError;
end;

(*
 * Procedure  : RemoveFromGroup
 * Author     : MPu
 * Removes a local account from a local group
 *)
function RemoveFromGroup(const Server, User, Group: WideString): NET_API_STATUS;
var
  Member            : TLocalGroupMembersInfo3;
  NetError          : DWORD;
begin
  NetError := 0;
  if (User <> '') and (Group <> '') then
  begin
    try
      //Member^.lgrmi3_domainandname := PWideChar(copy(Server, 3, length(Server)) + '\' + User);
      Member.lgrmi3_domainandname := PWideChar(User);
      NetError := NetLocalGroupDelMembers(PWideChar(Server), PWideChar(Group), 3, @Member, 1);
    finally
    end;
  end;
  result := NetError;
end;


function GetAccountSid(const Server, User: WideString; var Sid: PSID): DWORD;
var
  dwDomainSize, dwSidSize: DWord;
  R                 : LongBool;
  wDomain           : WideString;
  Use               : DWord;
begin
  Result := 0;
  SetLastError(0);
  dwSidSize := 0;
  dwDomainSize := 0;
  R := LookupAccountNameW(PWideChar(Server), PWideChar(User), nil, dwSidSize,
    nil, dwDomainSize, Use);
  if (not R) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    SetLength(wDomain, dwDomainSize);
    Sid := GetMemory(dwSidSize);
    R := LookupAccountNameW(PWideChar(Server), PWideChar(User), Sid,
      dwSidSize, PWideChar(wDomain), dwDomainSize, Use);
    if not R then
    begin
      FreeMemory(Sid);
      Sid := nil;
    end;
  end
  else
    Result := GetLastError;
end;


function GetAccountSidString(const Server, User: WideString):String;
var
  ASID:PSid;
begin
  ASID:=Nil;
  try
    if GetAccountSid(Server,User,ASID)=0 then
      Result := SIDToStringSID(ASID)
    else
      Result := '';
  finally
     if ASID<>Nil then
      Freememory(ASID);
  end;
end;

(*
 * Procedure  : StrSIDToName
 * Author     : MPu
 *)
function StrSIDToName(const StrSID: AnsiString; var Name: Ansistring; var SIDType: DWORD): Boolean;
var
  SID               : PSID;
  Buffer            : PAnsiChar;
  NameLen, TempLen  : Cardinal;
  err               : Boolean;
begin
  SID := nil;
  err := ConvertStringSIDToSID(PChar(StrSID), SID);
  if err then
  begin
    NameLen := 0;
    TempLen := 0;
    LookupAccountSidA(nil, SID, nil, NameLen, nil, TempLen, SIDType);
    GetMem(Buffer, NameLen);
    try
      err := LookupAccountSidA(nil, SID, Buffer, NameLen, nil, TempLen, SIDType);
      if err then
        SetString(Name, Buffer, Namelen);
    finally
      FreeMem(Buffer);
    end;
  end;
  if Assigned(SID) then
    LocalFree(Cardinal(SID));
  result := err;
end;

function SIDToStringSID(const aSID:PSID): String;
var
  Buffer            : PAnsiChar;
  err               : Boolean;
begin
  err := ConvertSidToStringSid(aSID,Buffer);
  if err then
  begin
    Result := String(Buffer);
    if Assigned(Buffer) then
      LocalFree(HLocal(Buffer));
  end
  else
    Result :='';
end;



(*
 * Procedure  : AddToGroup
 * Author     : MPu
 * Adds a domain account to a local group
 *)
function AddToGroup(const member, Group: WideString): NET_API_STATUS;
var
  memberInfo             : LOCALGROUP_MEMBERS_INFO_3;
  NetError          : DWORD;

begin
  NetError := 0;
  if (member <> '') and (Group <> '')  then
  begin
    memberInfo.lgrmi3_domainandname:=PWideChar(member);
    NetError := NetLocalGroupAddMembers(Nil, PWideChar(Group), 3, @memberInfo, 1);
    if NetError = 1378 then //Le nom de compte spécifié est déjà membre du groupe"
      NetError := 0;
  end;
  result := NetError;
end;

(*
 * Procedure  : UserModalsGet
 * Author     : MPu
 * Password stuff
 *)
function UserModalsGet(const Server: String): USER_MODALS_INFO_0;
var
  UserModalsInfo    : PUSER_MODALS_INFO_0;
  dwRet             : DWORD;
begin
  UserModalsInfo := nil;
  dwRet := NetUserModalsGet(nil, 0, Pointer(UserModalsInfo));
  if ((dwRet = NERR_Success) and Assigned(UserModalsInfo)) then
  begin
    result.usrmod0_min_passwd_len := UserModalsInfo^.usrmod0_min_passwd_len;
    result.usrmod0_max_passwd_age := UserModalsInfo^.usrmod0_max_passwd_age;
    result.usrmod0_min_passwd_age := UserModalsInfo^.usrmod0_min_passwd_age;
    result.usrmod0_force_logoff := UserModalsInfo^.usrmod0_force_logoff;
    result.usrmod0_password_hist_len := UserModalsInfo^.usrmod0_password_hist_len;
    NetApiBufferFree(UserModalsInfo);
  end;
end;

function DomainGet: String;
var
  UserModalsInfo    : PUSER_MODALS_INFO_2;
  dwRet             : DWORD;
begin
  UserModalsInfo := nil;
  dwRet := NetUserModalsGet(nil, 2, Pointer(UserModalsInfo));
  if ((dwRet = NERR_Success) and Assigned(UserModalsInfo)) then
  begin
    Result := UserModalsInfo^.usrmod2_domain_name;
    //result.usrmod2_domain_id := UserModalsInfo^.usrmod2_domain_id;
    NetApiBufferFree(UserModalsInfo);
  end;
end;


function DomainSID: String;
var
  UserModalsInfo    : PUSER_MODALS_INFO_2;
  dwRet             : DWORD;
  SID               : PSID;
begin
  UserModalsInfo := nil;
  dwRet := NetUserModalsGet(nil, 2, Pointer(UserModalsInfo));
  if ((dwRet = NERR_Success) and Assigned(UserModalsInfo)) then
  begin
    Result := SIDToStringSID(UserModalsInfo^.usrmod2_domain_id);
    //result.usrmod2_domain_id := UserModalsInfo^.usrmod2_domain_id;
    NetApiBufferFree(UserModalsInfo);
  end;
end;


function GetJoinInformation:String;
var
  name: LPWSTR;
  status: NETSETUP_JOIN_STATUS;
begin
  Result := '';
  Name := Nil;
  if NetGetJoinInformation(Nil,name,@status)=NERR_Success then
  begin
    if status=NetSetupDomainName then
      Result := name;
    NetApiBufferFree(name);
  end;
end;

function EnablePrivilege(const Privilege: string; fEnable: Boolean; out PreviousState: Boolean): DWORD;
var
  Token             : THandle;
  NewState          : TTokenPrivileges;
  Luid              : _LUID;
  PrevState         : TTokenPrivileges;
  Return            : DWORD;
begin
  PreviousState := True;
  if (GetVersion() > $80000000) then
    // Win9x
    Result := ERROR_SUCCESS
  else
  begin
    // WinNT
    if not OpenProcessToken(GetCurrentProcess(), MAXIMUM_ALLOWED, Token) then
      Result := GetLastError()
    else
    try
      if not LookupPrivilegeValue(nil, PChar(Privilege), Luid) then
        Result := GetLastError()
      else
      begin
        NewState.PrivilegeCount := 1;
        NewState.Privileges[0].Luid := Luid;
        if fEnable then
          NewState.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
        else
          NewState.Privileges[0].Attributes := 0;
        if not AdjustTokenPrivileges(Token, False, @NewState,
          SizeOf(TTokenPrivileges), @PrevState, @Return) then
          Result := GetLastError()
        else
        begin
          Result := ERROR_SUCCESS;
          PreviousState :=
            (PrevState.Privileges[0].Attributes and SE_PRIVILEGE_ENABLED <> 0);
        end;
      end;
    finally
      CloseHandle(Token);
    end;
  end;
end;


function GetAdminSid: PSID;
// Author       : Nico Bendlin
const
  // bekannte SIDs ... (WinNT.h)
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  // bekannte RIDs ... (WinNT.h)
  SECURITY_BUILTIN_DOMAIN_RID: DWORD = $00000020;
  DOMAIN_ALIAS_RID_ADMINS: DWORD = $00000220;
begin
  Result := nil;
  AllocateAndInitializeSid(@SECURITY_NT_AUTHORITY, 2,
    SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
    0, 0, 0, 0, 0, 0, Result);
end;

function IsAdmin: LongBool;
// Author       : Nico Bendlin
var
  TokenHandle       : THandle;
  ReturnLength      : DWORD;
  TokenInformation  : PTokenGroups;
  AdminSid          : PSID;
  Loop              : Integer;
begin
  Result := False;
  TokenHandle := 0;
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, TokenHandle) then
  try
    ReturnLength := 0;
    GetTokenInformation(TokenHandle, TokenGroups, nil, 0, ReturnLength);
    TokenInformation := GetMemory(ReturnLength);
    if Assigned(TokenInformation) then
    try
      if GetTokenInformation(TokenHandle, TokenGroups, TokenInformation,
        ReturnLength, ReturnLength) then
      begin
        AdminSid := GetAdminSid;
        for Loop := 0 to TokenInformation^.GroupCount - 1 do
        begin
          if EqualSid(TokenInformation^.Groups[Loop].Sid, AdminSid) then
          begin
            Result := True;
            Break;
          end;
        end;
        FreeSid(AdminSid);
      end;
    finally
      FreeMemory(TokenInformation);
    end;
  finally
    CloseHandle(TokenHandle);
  end;
end;


procedure AddToUserPath(APath:Utf8String);
var
  SystemPath : Utf8String;
begin
  with TRegistry.Create do
  try
    //RootKey:=HKEY_LOCAL_MACHINE;
    OpenKey('Environment',False);
    SystemPath:=ReadString('PATH');
    if pos(LowerCase(APath),LowerCase(SystemPath))=0 then
    begin
      if RightStr(SystemPath,1)<>';' then SystemPath:=SystemPath+';';
      SystemPath:=SystemPath+APath;
      if RightStr(SystemPath,1)<>';' then SystemPath:=SystemPath+';';
      WriteString('PATH',SystemPath);
    end;
  finally
    Free;
  end;
end;

procedure AddToSystemPathWindows(APath:Utf8String);
var
  SystemPath : Utf8String;
  aresult:LongWord;
begin
  with TRegistry.Create do
  try
    RootKey:=HKEY_LOCAL_MACHINE;
    OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment',False);
    SystemPath:=ReadString('Path');
    if pos(LowerCase(APath),LowerCase(SystemPath))=0 then
    begin
      if RightStr(SystemPath,1)<>';' then SystemPath:=SystemPath+';';
      SystemPath:=SystemPath+APath;
      if RightStr(SystemPath,1)<>';' then SystemPath:=SystemPath+';';
      WriteExpandString('Path',SystemPath);
      SendMessageTimeout(HWND_BROADCAST,WM_SETTINGCHANGE,0,Longint(PAnsiChar('Environment')),0,1000,aresult);
    end;
  finally
    Free;
  end;
end;
{$endif}


//Unzip file to path, and return list of files as a string
procedure UnzipFile(ZipFilePath, OutputPath: Utf8String);
var
  UnZipper: TUnZipper;
begin
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := ZipFilePath;
    UnZipper.OutputPath := OutputPath;
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;
  finally
    UnZipper.Free;
  end;
end;


{$ifdef unix}
procedure AddToSystemPathUnix(APath: Utf8String);
begin
  { XXX TODO }
end;
{$endif}

procedure AddToSystemPath(APath: Utf8String);
begin
  {$ifdef windows}
  AddToSystemPathWindows(APath);
  {$else}
  AddToSystemPathUnix(APath);
  {$endif}
end;


procedure UpdateCurrentApplication(fromURL: Utf8String; Restart: Boolean;
  restartparam: Utf8String);
var
  bat: TextFile;
  tempdir,tempfn,updateBatch,fn,zipfn,version,destdir : Utf8String;
  files:TStringList;
  UnZipper: TUnZipper;
  i:integer;
  hinstance:Integer;
begin
  {$ifdef windows}
  Files := TStringList.Create;
  try
    Logger('Updating current application in place...');
    tempdir := GetTempFilenameUtf8(GetTempDir,'waptget');
    fn :=ExtractFileName(ParamStrUtf8(0));
    destdir := ExtractFileDir(ParamStrUtf8(0));

    tempfn := AppendPathDelim(tempdir)+fn;
    mkdir(tempdir);
    Logger('Getting new file from: '+fromURL+' into '+tempfn);
    try
      wget(fromURL,tempfn,Nil,Nil,True);
      version := GetApplicationVersion(tempfn);
      if version='' then
        raise Exception.create('no version information in downloaded file.');
      Logger(' got '+fn+' version: '+version);
      Files.Add(fn);
    except
      //trying to get a zip file instead (exe files blocked by proxy ...)
      zipfn:= AppendPathDelim(tempdir)+ChangeFileExt(fn,ansistring('.zip'));
      wget(ChangeFileExt(fromURL,ansistring('.zip')),zipfn);
      Logger('  unzipping file '+zipfn);
      UnZipper := TUnZipper.Create;
      try
        UnZipper.FileName := zipfn;
        UnZipper.OutputPath := tempdir;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
        for i := 0 to UnZipper.Entries.count-1 do
          if not UnZipper.Entries[i].IsDirectory then
            Files.Add(StringReplace(UnZipper.Entries[i].DiskFileName,'/','\',[rfReplaceAll]));
      finally
        UnZipper.Free;
      end;

      version := GetApplicationVersion(tempfn);
      if version='' then
        raise Exception.create('no version information in downloaded exe file.');
      Logger(' got '+fn+' version: '+version);
    end;

    if FileExistsUtf8(tempfn) and (FileSizeUtf8(tempfn)>0) then
    begin
      // small batch to replace current running application
      updatebatch := AppendPathDelim(tempdir) + 'update.bat';
      AssignFile(bat,updateBatch);
      Rewrite(bat);
      try
        Logger(' Creating update batch file '+updateBatch);
        // wait for program to terminate..
        Writeln(bat,'timeout /T 2');
        Writeln(bat,'taskkill /im '+fn+' /f');
        for i:= 0 to files.Count-1 do
        begin
          // be sure to have target directory
          if not DirectoryExists(ExtractFileDir(IncludeTrailingPathDelimiter(destdir)+files[i])) then
            MkDir(ExtractFileDir(IncludeTrailingPathDelimiter(destdir)+files[i]));
          Writeln(bat,'copy "'+IncludeTrailingPathDelimiter(tempdir)+files[i]+'" "'+IncludeTrailingPathDelimiter(destdir)+files[i]+'"');
        end;
        Writeln(bat,'cd ..');
        if restart then
          Writeln(bat,'start "" "'+ParamStr(0)+'" '+restartparam);
        Writeln(bat,'rmdir /s /q "'+tempdir+'"');
      finally
        CloseFile(bat)
      end;
      Logger(' Launching update batch file '+updateBatch);
      hinstance := ShellExecute(
        0,
        PAnsiChar('open'),
        PAnsiChar( SysUtils.GetEnvironmentVariable('ComSpec')),
        PAnsiChar(AnsiString('/C '+updatebatch)),
        PAnsiChar(TempDir),
        SW_HIDE);
      if hinstance<=32 then
      begin
        writeln('Error launching update batch file :'+IntToStr(hinstance));
        ExitProcess(1);
      end
      else
        ExitProcess(0)
    end;

  finally
    Files.Free;
  end;
{$endif}
end;

function GetUniqueTempdir(Prefix: Utf8String): Utf8String;
var
  I: Integer;
  Start: Utf8String;
begin
  Start:=GetTempDir;
  if (Prefix='') then
      Start:=Start+'TMP'
  else
    Start:=Start+Prefix;
  I:=0;
  repeat
    Result:=Format('%s%.5d.tmp',[Start,I]);
    Inc(I);
  until not DirectoryExistsUTF8(Result);
end;


procedure UpdateApplication(fromURL:Utf8String;SetupExename,SetupParams,ExeName,RestartParam:Utf8String);
var
  bat: TextFile;
  tempdir,tempfn,updateBatch,zipfn,version : Utf8String;
  files:TStringList;
  UnZipper: TUnZipper;
  i,hinstance:integer;
begin
  {$ifdef windows}
  Files := TStringList.Create;
  try
    Logger('Updating application...');
    tempdir := GetUniqueTempdir('tis');
    if ExeName='' then
      ExeName :=ExtractFileName(ParamStr(0));

    tempfn := AppendPathDelim(tempdir)+SetupExename;
    mkdir(tempdir);
    Logger('Getting new file from: '+fromURL+' into '+tempfn);
    try
      wget(fromURL,tempfn,Nil,Nil,True);
      version := GetApplicationVersion(tempfn);
      if version='' then
        raise Exception.create('no version information in downloaded file.');
      Logger(' got '+SetupExename+' version: '+version);
      Files.Add(SetupExename);
    except
      //trying to get a zip file instead (exe files blocked by proxy ...)
      zipfn:= AppendPathDelim(tempdir)+ChangeFileExt(SetupExename,ansistring('.zip'));
      wget(ChangeFileExt(fromURL,ansistring('.zip')),zipfn,Nil,Nil,True);
      Logger('  unzipping file '+zipfn);
      UnZipper := TUnZipper.Create;
      try
        UnZipper.FileName := zipfn;
        UnZipper.OutputPath := tempdir;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
        for i := 0 to UnZipper.Entries.count-1 do
          if not UnZipper.Entries[i].IsDirectory then
            Files.Add(StringReplace(UnZipper.Entries[i].DiskFileName,'/','\',[rfReplaceAll]));
      finally
        UnZipper.Free;
      end;

      version := GetApplicationVersion(tempfn);
      if version='' then
        raise Exception.create('no version information in downloaded exe file.');
      Logger(' got '+SetupExename+' version: '+version);
    end;

    if FileExistsUtf8(tempfn) and (FileSizeUtf8(tempfn)>0) then
    begin
      // small batch to replace current running application
      updatebatch := AppendPathDelim(tempdir) + 'update.bat';
      AssignFile(bat,updateBatch);
      Rewrite(bat);
      try
        Logger(' Creating update batch file '+updateBatch);
        // wait for program to terminate..
        Writeln(bat,'timeout /T 2');
        Writeln(bat,'taskkill /im '+Exename+' /f');
        Writeln(bat,'"'+IncludeTrailingPathDelimiter(tempdir)+SetupExename+'" '+SetupParams);
        Writeln(bat,'cd ..');
        if RestartParam<>'' then
          Writeln(bat,'start "" "'+ParamStr(0)+'" '+restartparam);
        Writeln(bat,'rmdir /s /q "'+tempdir+'"');
      finally
        CloseFile(bat)
      end;
      Logger(' Launching update batch file '+updateBatch);
      hinstance := ShellExecute(
        0,
        PAnsiChar('open'),
        PAnsiChar( SysUtils.GetEnvironmentVariable(AnsiString('ComSpec'))),
        PAnsiChar(AnsiString('/C '+ updatebatch)),
        PAnsiChar(TempDir),
        SW_HIDE);
      if hinstance<=32 then
      begin
        writeln('Error launching update batch file :'+IntToStr(hinstance));
        ExitProcess(1);
      end
      else
        ExitProcess(0)
    end;

  finally
    Files.Free;
  end;
  {$endif}

end;

{$ifdef windows}
function GetUserNameWindows: Utf8String;
var
	 pcUser   : PWideChar;
	 dwUSize : DWORD;
begin
	 dwUSize := 21 * SizeOf(WideChar); // user name can be up to 20 characters
	 GetMem( pcUser, dwUSize); // allocate memory for the string
	 try
			if GetUserNameW( pcUser, dwUSize ) then
				 Result := pcUser;
	 finally
			FreeMem( pcUser ); // now free the memory allocated for the string
	 end;
end;
{$endif}

{$ifdef unix}
function GetUserNameUnix: AnsiString;
var
  User: String;
begin
  Result := 'john.doe';

  // LOGNAME is POSIX, USER is BSD
  User := GetEnvironmentVariable('LOGNAME');
  if User = '' then
    User := GetEnvironmentVariable('USER');

  { XXX fallback on fpgetuid + getpwnam? }

  Result := User;
end;
{$endif}

function GetUserName: String;
begin
  {$ifdef windows}
  Result := GetUserNameWindows();
  {$else}
  Result := GetUserNameUnix();
  {$endif}
end;

procedure StrResetLength(var S: AnsiString);
var
  I: SizeInt;
begin
  for I := 1 to Length(S) do
    if S[I] = #0 then
    begin
      SetLength(S, I);
      Exit;
    end;
end;

{$ifdef windows}
function GetUserDomainNameWindows(const CurUser: Ansistring): AnsiString;
var
  Count1, Count2: DWORD;
  Sd: PSID; // PSecurityDescriptor; // FPC requires PSID
  Snu: SID_Name_Use;
begin
  Count1 := 0;
  Count2 := 0;
  Sd := nil;
  Snu := SIDTypeUser;
  Result := '';
  LookupAccountName(nil, PAnsiChar(CurUser), Sd, Count1, PAnsiChar(Result), Count2, Snu);
  SetLength(Result, Count2 + 1);
  Sd := AllocMem(Count1);
  try
    if LookUpAccountName(nil, PAnsiChar(CurUser), Sd, Count1, PAnsiChar(Result), Count2, Snu) then
      StrResetLength(Result)
    else
      Result := EmptyStr;
  finally
    FreeMem(Sd);
  end;
end;
{$endif}

{$ifdef unix}
function GetUserDomainNameUnix(const curUser: Ansistring): AnsiString;
begin
  Result := 'unknowndomain';
end;
{$endif}

function GetUserDomainName(const curUser: Ansistring): AnsiString;
begin
  {$ifdef windows}
  Result := GetUserDomainNameWindows(curUser);
  {$else}
  Result := GetUserDomainNameUnix(curUser);
  {$endif}
end;

{$ifdef windows}
function GetWorkGroupNameWindows(): AnsiString;
var
  WkstaInfo: PByte;
  WkstaInfo100: PWKSTA_INFO_100;
begin
  if NetWkstaGetInfo(nil, 100, WkstaInfo) <> 0 then
    raise Exception.Create('NetWkstaGetInfo failed');
  WkstaInfo100 := PWKSTA_INFO_100(WkstaInfo);
  Result := WkstaInfo100^.wki100_langroup;
  NetApiBufferFree(Pointer(WkstaInfo));
end;
{$endif}

{$ifdef unix}
function GetWorkGroupNameUnix(): AnsiString;
begin
  Result := 'unknowndomain';
end;
{$endif}

function GetWorkgroupName: String;
begin
  {$ifdef windows}
  Result := GetWorkGroupNameWindows();
  {$else}
  Result := GetWorkGroupNameUnix();
  {$endif}
end;

{$ifdef windows}
function GetDomainNameWindows: Utf8String;
var
  hProcess, hAccessToken: THandle;
  InfoBuffer: PWideChar;
  AccountName: array [0..UNLEN] of WideChar;
  DomainName: array [0..UNLEN] of WideChar;

  InfoBufferSize: Cardinal;
  AccountSize: Cardinal;
  DomainSize: Cardinal;
  snu: SID_NAME_USE;
begin
  InfoBufferSize := 1000;
  AccountSize := SizeOf(AccountName);
  DomainSize := SizeOf(DomainName);

  hProcess := GetCurrentProcess;
  Result :='';
  if OpenProcessToken(hProcess, TOKEN_READ, hAccessToken) then
  try
    GetMem(InfoBuffer, InfoBufferSize);
    try
      if GetTokenInformation(hAccessToken, TokenUser, InfoBuffer, InfoBufferSize, InfoBufferSize) then
        LookupAccountSidW(nil, PSIDAndAttributes(InfoBuffer)^.sid, AccountName, AccountSize,
                         DomainName, DomainSize, snu)
      else
        RaiseLastOSError;
    finally
      FreeMem(InfoBuffer)
    end;
    Result := DomainName;
  finally
    CloseHandle(hAccessToken);
  end
end;
{$endif}

{$ifdef unix}
function GetDomainNameUnix(): WideString;
var
  Res, Host: WideString;
begin
  // Per RFC 6761
  Result := 'invalid';

  Res := unix.GetDomainName();
  if Res = '(none)' then
    Res := '';

  if Res = '' then
  begin
    Host := gethostname();
    if (Host <> '') and (Pos('.', Host) > 0) then
      Res := Copy(Host, Pos('.', Host) + 1, 255);
  end;

  if Res = '' then
  { XXX parse resolv.conf? }
  ;

  if Res <> '' then
    Result := Res;

end;
{$endif}

function GetDomainName(): String;
begin
  {$ifdef windows}
  Result := GetDomainNameWindows();
  {$else}
  Result := GetDomainNameUnix();
  {$endif}
end;

{$ifdef windows}

function GetSpecialFolderLocation(csidl: Integer; ForceFolder: Boolean = False ): Utf8String;
Var
  APath : Array[0..MAX_PATH] of WideChar;
  WS: UnicodeString;
  Len: SizeInt;
  hr: HRESULT;
begin
  Result := '';
  If (@SHGetFolderPathW <> Nil) then
  begin
    FillChar(APath{%H-}, SizeOf(APath), #0);
    hr := SHGetFolderPathW(0,csidl or CSIDL_FLAG_CREATE,0,0, @APATH[0]);
    if hr = S_OK then
    begin
      Len := StrLen(APath);
      SetLength(WS, Len);
      System.Move(APath[0], WS[1], Len * SizeOf(WideChar));
      Result := AppendPathDelim(Utf8Decode(APath));
    end;
  end;
end;

function GetSendToFolder: Utf8String;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  Registry.RootKey := HKEY_CURRENT_USER;
  if Registry.OpenKeyReadOnly( strnShellFolders ) then
    Result := AppendPathDelim(Registry.ReadString( 'SendTo' ))
  else
    Result := '';
  Registry.Free;
end;

function GetUserNameEx(NameFormat: DWORD; lpNameBuffer: LPSTR; var nSize: DWORD): Boolean; stdcall; external
  'secur32.dll' Name 'GetUserNameExA';

function GetCurrentUserName(fFormat: DWORD=NameSamCompatible) : Ansistring;
const
  cnMaxUserNameLen = 254;
var
  sUserName     : Ansistring;
  dwUserNameLen : DWord;
begin
  dwUserNameLen := cnMaxUserNameLen-1;
  SetLength( sUserName, cnMaxUserNameLen );
  GetUserNameEx(fFormat,
    PChar( sUserName ),
    dwUserNameLen );
  SetLength( sUserName, dwUserNameLen );
  Result := sUserName;
end;

function GetPersonalFolder:Utf8String;
begin
  result := GetSpecialFolderLocation(CSIDL_PERSONAL)
end;

function GetLocalAppdataFolder:Utf8String;
begin
  result :=  GetSpecialFolderLocation(CSIDL_LOCAL_APPDATA);
end;


function GetAppdataFolder:Utf8String;
begin
  result :=  GetSpecialFolderLocation(CSIDL_APPDATA);
end;

Function GetAppUserFolder : Utf8String;
begin
  Result := IncludeTrailingPathDelimiter(GetSpecialFolderLocation(CSIDL_APPDATA)) + ApplicationName;
end;

function GetStartMenuFolder: Utf8String;
begin
  result := GetSpecialFolderLocation(CSIDL_STARTMENU);
end;

function GetCommonStartMenuFolder: Utf8String;
begin
  result := GetSpecialFolderLocation(CSIDL_COMMON_STARTMENU);
end;

function GetStartupFolder: Utf8String;
begin
  result := GetSpecialFolderLocation(CSIDL_STARTUP);
end;

function GetCommonStartupFolder: Utf8String;
begin
  result := GetSpecialFolderLocation(CSIDL_COMMON_STARTUP);
end;

function GetCurrentUser: Utf8String;
var
  charBuffer: array[0..128] of WideChar;
  intgBufferSize: DWORD;
begin
  intgBufferSize := 128;
  if GetUserNameW( charBuffer, intgBufferSize ) then
  begin
    Result := StrPas( charBuffer );
  end
  else
  begin
    Result := '';
  end;
end;

// to store use specific settings for this application
function Appuserinipath:Utf8String;
var
  dir : Utf8String;
begin
  dir := IncludeTrailingPathDelimiter(GetAppdataFolder)+ApplicationName;
  if not DirectoryExistsUTF8(dir) then
    MkDir(dir);
  Result:=IncludeTrailingPathDelimiter(dir)+ApplicationName+'.ini';
end;
{$endif}

function SortableVersion(VersionString: String): String;
var
  version,tok : String;
begin
  version := VersionString;
  tok := StrToken(version,'.');
  Result :='';
  repeat
    if tok[1] in ['0'..'9'] then
      Result := Result+FormatFloat('0000',StrToInt(tok))
    else
      Result := Result+tok;
    tok := StrToken(version,'.');
  until tok='';
end;

function CompareVersion(const v1,v2:String):integer;
var
  version1,version2,pack1,pack2,tok1,tok2:String;
begin
  // '1.2.3-4';
  pack1 := v1;
  pack2 := v2;

  version1 := StrToken(pack1,'-');
  version2 := StrToken(pack2,'-');

  //version base
  repeat
    tok1 := StrToken(version1,'.');
    tok2 := StrToken(version2,'.');
    if (tok1<>'') or (tok2<>'') then
    try
      result := StrToInt(tok1)-StrToInt(tok2);
    except
      result := CompareStr(tok1,tok2)
    end;
    if (result<>0) or (tok1='') or (tok2='') then
      break;
  until (result<>0) or (tok1='') or (tok2='');

  // packaging
  if (Result=0) and ((pack1<>'') or (pack2<>'')) then
  begin
    if (pack1<>'') or (pack2<>'') then
    try
      result := StrToInt(pack1)-StrToInt(pack2);
    except
      result := CompareStr(pack1,pack2)
    end;
  end;
end;

procedure Logger(Msg: Utf8String;level:LogLevel=WARNING);
begin
  if level>=currentLogLevel then
  begin
    if IsConsole then
      WriteLn(Msg)
    else
      if Assigned(loghook) then
        loghook(Msg);
  end;
end;

{$ifdef windows}

function GetOSVersionInfo: TOSVersionInfoEx;
begin
  FillChar(Result, SizeOf(TOSVersionInfoEx), 0);
  Result.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  if not GetVersionEx(POSVersionInfo(@Result)) then
    Result.dwOSVersionInfoSize := 0;
end;

function IsWinXP:Boolean;
var
  Info : TOSVersionInfoEx;
begin
  Result := False;
  info := GetOSVersionInfo;
  if info.dwOSVersionInfoSize>0 then
    result := (Info.dwPlatformId = VER_PLATFORM_WIN32_NT) and
              (Info.dwMajorVersion = 5) and (Info.dwMinorVersion = 1)
end;

function GetComputerNameWindows : String;
var
  buffer: array[0..255] of WideChar;
  size: dword;
begin
  size := 256;
  if windows.GetComputerNameW(@buffer, size) then
    Result := UTF8Encode(WideString(buffer))
  else
    Result := ''
end;


 type
	PFixedFileInfo = ^TFixedFileInfo;
	TFixedFileInfo = record
		 dwSignature       : DWORD;
		 dwStrucVersion    : DWORD;
		 wFileVersionMS    : WORD;  // Minor Version
		 wFileVersionLS    : WORD;  // Major Version
		 wProductVersionMS : WORD;  // Build Number
		 wProductVersionLS : WORD;  // Release Version
		 dwFileFlagsMask   : DWORD;
		 dwFileFlags       : DWORD;
		 dwFileOS          : DWORD;
		 dwFileType        : DWORD;
		 dwFileSubtype     : DWORD;
		 dwFileDateMS      : DWORD;
		 dwFileDateLS      : DWORD;
	end; // TFixedFileInfo
{$endif}

{$ifdef unix}
function GetComputerNameUnix : AnsiString;
var
  Host: AnsiString;
begin
  Result := 'unknown';

  Host := gethostname();
  if (Host <> '') then
  begin
    if Pos('.', Host) > 1 then
      Result := Copy(Host, 1, Pos('.', Host) - 1)
    else
      Result := Host;
  end;
end;
{$endif}

function GetComputerName : String;
begin
  {$ifdef windows}
  Result := GetComputerNameWindows();
  {$else}
  Result := GetComputerNameUnix();
  {$endif}
end;

{$ifdef windows}
function GetApplicationVersion(FileName: Utf8String): Utf8String;
var
	dwHandle, dwVersionSize : DWORD;
	strSubBlock             : String;
	pTemp                   : Pointer;
	pData                   : Pointer;
begin
  Result:='';
	if Filename='' then
    FileName:=ParamStr(0);
	 strSubBlock := '\';

	 // get version information values
	 dwVersionSize := GetFileVersionInfoSizeW( PWideChar( UTF8Decode(FileName) ), // pointer to filename string
																						dwHandle );        // pointer to variable to receive zero

	 // if GetFileVersionInfoSize is successful
	 if dwVersionSize <> 0 then
	 begin
			GetMem( pTemp, dwVersionSize );
			try
				 if GetFileVersionInfo( PAnsiChar( FileName ),             // pointer to filename string
																dwHandle,                      // ignored
																dwVersionSize,                 // size of buffer
																pTemp ) then                   // pointer to buffer to receive file-version info.

						if VerQueryValue( pTemp,                           // pBlock     - address of buffer for version resource
															PAnsiChar( strSubBlock ),            // lpSubBlock - address of value to retrieve
															pData,                           // lplpBuffer - address of buffer for version pointer
															dwVersionSize ) then             // puLen      - address of version-value length buffer
							 with PFixedFileInfo( pData )^ do
								Result:=IntToSTr(wFileVersionLS)+'.'+IntToSTr(wFileVersionMS)+
											'.'+IntToStr(wProductVersionLS)+'.'+IntToStr(wProductVersionMS);
			finally
				 FreeMem( pTemp );
			end; // try
	 end; // if dwVersionSize
end;

function ProcessExists(ExeFileName: string): boolean;
{description checks if the process is running. Adapted for freepascal from:
URL: http://www.swissdelphicenter.ch/torry/showcode.php?id=2554}
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  CurrentPId:LongWord;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  CurrentPId:=longWord(GetCurrentProcessId);
  while integer(ContinueLoop) <> 0 do
  begin
    if (FProcessEntry32.th32ProcessID <> CurrentPId) and  ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot
           (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,
                 FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
          = UpperCase(ExeFileName)) or
        (UpperCase(FProcessEntry32.szExeFile) =
         UpperCase(ExeFileName))) then

    Result := Integer(TerminateProcess(OpenProcess(
            PROCESS_TERMINATE, BOOL(0),
            FProcessEntry32.th32ProcessID), 0));

    ContinueLoop := Process32Next(FSnapshotHandle,
                 FProcessEntry32);
  end;

  CloseHandle(FSnapshotHandle);
end;


//From Pascal SCADA / sockets_w32_w64  (C) Fabio Luis Girardi
function WaitForConnection(FListenerSocket:TSocket; timeout:LongInt):Boolean;
var
  readsel,wrsel:TFDSet;
  mode:u_long;
  tv : TTimeVal;
  p:ptimeval;
begin

  if timeout=-1 then
    p:=nil
  else begin
    tv.tv_Sec:=Timeout div 1000;
    tv.tv_Usec:=(Timeout mod 1000)*1000;
    p:=@tv;
  end;


  FD_ZERO(readsel);
  FD_SET(FListenerSocket, readsel);
  FD_ZERO(wrsel);
  FD_SET(FListenerSocket, wrsel);

  // XXX should probably be "FListenerSocket + 1" (ie. max_fd + 1)
  mode := select(FListenerSocket, @readsel, @wrsel, nil, p);

  if (mode <= 0) then begin
    Result := false;
  end else
    if (mode > 0) then begin
      Result := true;
    end;
end;


// from http://theroadtodelphi.wordpress.com/2010/02/21/checking-if-a-tcp-port-is-open-using-delphi-and-winsocks/
// + Pascal Scada
function CheckOpenPort(dwPort : Word; ipAddressStr:AnsiString;timeout:integer=5000):boolean;
var
  client : sockaddr_in;
  sock   : Integer;
  IP: AnsiString;
  ret    : Integer;
  wsdata : WSAData;
  mode   : long;
begin
  sock := -1;
  Result := False;
  IP := '';

  ret := WSAStartup($0002, wsdata); //initiates use of the Winsock DLL
  if ret<>0 then
    exit;

  try

    IP := GetIPFromHost(ipAddressStr);
    if IP = '' then
      exit;

    client.sin_family      := AF_INET;  //Set the protocol to use , in this case (IPv4)
    client.sin_port        := htons(dwPort); //convert to TCP/IP network byte order (big-endian)
    client.sin_addr.s_addr := inet_addr(PAnsiChar(IP));  //convert to IN_ADDR  structure
    sock := socket(AF_INET, SOCK_STREAM, 0);    //creates a socket
    mode := 1;
    ioctlsocket(sock, FIONBIO, @mode);
    Result:= (connect(sock,client,SizeOf(client)) <>0) and (WSAGetLastError=WSAEWOULDBLOCK) and
        WaitForConnection(sock,TimeOut);  //establishes a connection to a specified socket
  finally
    if sock>=0 then
      closesocket(sock);
    WSACleanup;
  end;
end;

function GetFreeLocalPort( portStart : Word = 5000; portEnd : Word = 10000):Word;
var
  client    : sockaddr_in;
  sock      : Integer;
  ret       : Integer;
  wsdata    : WSAData;
  bResult   : Boolean;
  trycount  : integer;
  status    : LongInt;


begin
 try
 ret := WSAStartup($0002, wsdata); //initiates use of the Winsock DLL
 except
  ret:=-1;
 end;

 if( ret <> 0 ) then
  Exit;

 bResult:=TRUE;
 try
  fillChar( client, sizeOf( client ), 0 );
  client.sin_family      := AF_INET;  //Set the protocol to use , in this case (IPv4)
  client.sin_addr.s_addr :=htonl(INADDR_LOOPBACK);
  //inet_addr(PAnsiChar(ipAddressStr));  //convert to IN_ADDR  structure
 except
  bResult:=FALSE;
 end;

 if( bResult ) then
 begin
  trycount:=0;

  while( trycount < (portEnd - portStart) ) do
  begin
   try
    Result := portStart+Random(portEnd-portStart) ;
    client.sin_port:=htons(result); //convert to TCP/IP network byte order (big-endian)
    sock:=socket(AF_INET, SOCK_STREAM, IPPROTO_TCP );    //creates a socket
    status:=connect(sock,client,sizeOf(client));
    bResult:=(status <> 0); //establishes a connection to a specified socket, less than zero is NOT in use
   except
    bResult:=FALSE;
   end;

   if( sock <> 0 ) then
   begin
    closesocket(sock);
    sock:=0;
   end;

   if( bResult ) then
    Exit;
   inc(trycount);
  end;
 end;

 Result := 0;

 try
  WSACleanup();
 except;
 end;
end;

{$endif}

{$ifdef unix}
function WaitForConnection(sock: cint; timeout:LongInt):Boolean;
var
  wrsel: TFDSet;
  res, sockopt_res, optval: cint;
  optlen: TSockLen;
  tv: timeVal;
  ptv: ptimeval;
begin

  if timeout = -1 then
    ptv := nil
  else
  begin
    tv.tv_Sec := Timeout div 1000;
    tv.tv_Usec := (Timeout mod 1000)*1000;
    ptv := @tv;
  end;

  fpFD_ZERO(wrsel);
  fpFD_SET(sock, wrsel);

  while True do
  begin
    res := fpselect(sock + 1, nil, @wrsel, nil, ptv);
    if (res < 0) then
    begin
      // select() error, did we get a signal?
      if (fpGetErrno() <> EsysEINTR) then
      begin
        logger('error within fpselect: ' + strerror(fpGetErrno()));
        Exit;
      end
    end
    else if (res > 0) then
    begin
      // select() indicates writability
      Assert(fpFD_IsSet(sock, wrsel) <> 0, 'fpselect returned > 0 but there is no socket marked as writable');
      // we have the result of the connect() call; is it a success?
      optval := 0;
      optlen := sizeof(optval);
      sockopt_res := fpgetsockopt(sock, SOL_SOCKET, SO_ERROR, @optval, @optlen);
      if sockopt_res <> 0 then
      begin
        // unexpected error, better bail out
        writeln('WaitForConnection: fpgetsockopt() failed: ', StrError(fpGetErrno()));
        Exit;
      end
      else if optval = 0 then
      begin
        // connect() succeeded
        Result := True;
        Exit;
      end
      else if (optval = EsysEINPROGRESS) or (optval = EsysEALREADY) then
        // nothing
      else
      begin
        // connect() error; silently return False
        //writeln('WaitForConnection: connect() failed: ', Strerror(optval));
        Exit;
      end
      ;
    end
    else
    begin
       writeln('WaitForConnection: fpselect() timeout');
       Exit;
    end;
  end;
end;

function CheckOpenPort(dwPort : Word; ipAddressStr:AnsiString; timeout: integer = 5000):boolean;
var
  sock, sockflags, res: cint;
  sin: sockaddr_in;
  ip: AnsiString;
begin
  Result := False;
  sock := -1;

  ip := GetIPFromHost(ipAddressStr);
  if ip = '' then
    Exit;

  FillChar(sin, sizeof(sin), 0);
  sin.sin_family := AF_INET;
  sin.sin_port := htons(dwPort);
  sin.sin_addr := StrToNetAddr(ip);

  try
    sock := fpsocket(AF_INET, SOCK_STREAM, 0);
    if sock = -1 then
      Exit;

    sockflags := fpfcntl(sock, F_GetFl);
    if sockflags = -1 then
      Exit;
    sockflags := sockflags or O_NONBLOCK;
    if fpfcntl(sock, F_SetFl, sockflags) = -1 then
      Exit;

    res := fpconnect(sock, psockaddr(@sin), sizeof(sin));

    if res = 0 then
      Result := True
    else if (res = -1) and ((fpGetErrno() = EsysEINPROGRESS) or (fpGetErrno() = EsysEALREADY)) then
      Result := WaitForConnection(sock, timeout)
    ;

  finally
    if sock <> -1 then
      fpclose(sock);
  end;

end;

function GetFreeLocalPort( portStart : Word = 5000; portEnd : Word = 10000):Word;
begin
  Result := portStart + random(portEnd-portStart);
  while CheckOpenPort(Result,'127.0.0.1',500) do
    Result := portStart + random(portEnd-portStart);

end;


{$endif}

{$ifdef windows}
function GetIPFromHostWindows(const HostName: ansistring): ansistring;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  i: Integer;
  GInitData: TWSAData;
begin
  WSAStartup($101, GInitData);
  Result := '';
  phe := gethostbyname(PAnsiChar(HostName));
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pPtr^[i] <> nil do
  begin
    Result := inet_ntoa(pptr^[i]^);
    Inc(i);
  end;
  WSACleanup;
end;
{$endif}

{$ifdef unix}
function GetIPFromHostUnix(const Hostname: AnsiString): AnsiString;
type
  TaPInAddr = array[0..10] of pin_addr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostent;
  pptr: PaPInAddr;
begin
  Result := '';
  phe := gethostbyname(PAnsiChar(Hostname));
  if phe = nil then
    Exit;
  pPtr := PaPInaddr(phe^.h_addr_list);
  if pPtr^[0] <> nil then
    Result := NetAddrToStr(pPtr^[0]^);
end;
{$endif}


function GetIPFromHost(const HostName: ansistring): ansistring;
begin
  {$ifdef windows}
  Result := GetIPFromHostWindows(Hostname);
  {$else}
  Result := GetIPFromHostUnix(Hostname);
  {$endif}
end;

function RunTask(cmd: utf8string;var ExitStatus:integer;WorkingDir:utf8String='';ShowWindow:TShowWindowOptions=swoHIDE): utf8string;
var
  AProcess: TProcess;
  AStringList: TStringList;
  Wow64FsEnableRedirection: LongBool;
begin
  try
    AProcess := TProcess.Create(nil);
    AStringList := TStringList.Create;
    try
      AProcess.CommandLine := cmd;
      if WorkingDir<>'' then
        AProcess.CurrentDirectory := ExtractFilePath(cmd);
      AProcess.Options := AProcess.Options + [poStderrToOutPut, poWaitOnExit, poUsePipes];
      AProcess.ShowWindow:=ShowWindow;
      AProcess.Execute;
      while AProcess.Running do;
      AStringList.LoadFromStream(AProcess.Output);
      Result := AStringList.Text;
      ExitStatus:= AProcess.ExitStatus;
    finally
      AStringList.Free;
      AProcess.Free;
    end;

  finally
  end;
end;


procedure ResetMemory(out P; Size: Longint);
begin
  if Size > 0 then
  begin
    Byte(P) := 0;
    FillChar(P, Size, 0);
  end;
end;


{$ifdef windows}
// From JCL library
function GetServiceStatusByName(const AServer,AServiceName:ansistring):TServiceState;
var
  ServiceHandle,
  SCMHandle: DWORD;
  SCMAccess,Access:DWORD;
  ServiceStatus: TServiceStatus;
begin
  Result:=ssUnknown;

  SCMAccess:=SC_MANAGER_CONNECT or SC_MANAGER_ENUMERATE_SERVICE or SC_MANAGER_QUERY_LOCK_STATUS;
  Access:=SERVICE_INTERROGATE or GENERIC_READ;

  SCMHandle:= OpenSCManager(PAnsiChar(AServer), Nil, SCMAccess);
  if SCMHandle <> 0 then
  try
    ServiceHandle:=OpenService(SCMHandle,PAnsiChar(AServiceName),Access);
    if ServiceHandle <> 0 then
    try
      ResetMemory(ServiceStatus, SizeOf(ServiceStatus));
      if QueryServiceStatus(ServiceHandle,ServiceStatus) then
        Result:=TServiceState(ServiceStatus.dwCurrentState);
    finally
      CloseServiceHandle(ServiceHandle);
    end;
  finally
    CloseServiceHandle(SCMHandle);
  end;
end;

function StartServiceByName(const AServer,AServiceName: AnsiString):Boolean;
var
  ServiceHandle,
  SCMHandle: DWORD;
  p: PAnsiChar;
  ts:TDateTime;
  SS:SERVICE_STATUS;
begin
  p:=nil;
  Result:=False;

  SCMHandle:= OpenSCManager(PAnsiChar(AServer), nil, SC_MANAGER_ALL_ACCESS);
  if SCMHandle <> 0 then
  try
    ServiceHandle:=OpenService(SCMHandle,PAnsiChar(AServiceName),SERVICE_ALL_ACCESS);
    if ServiceHandle <> 0 then
    begin
      Result:=StartService(ServiceHandle,0,p);
      if Result then
      begin
        ts := Now;
        repeat
          ResetMemory(SS, SizeOf(SS));
          QueryServiceStatus(ServiceHandle,SS);
        until (SS.dwCurrentState = SERVICE_RUNNING) or ((Now-ts)> 5/24/3600);
        Result := SS.dwCurrentState = SERVICE_RUNNING;
      end;
    end;
    CloseServiceHandle(ServiceHandle);
  finally
    CloseServiceHandle(SCMHandle);
  end;
end;

function StopServiceByName(const AServer, AServiceName: AnsiString):Boolean;
var
  ServiceHandle,
  SCMHandle: DWORD;
  SS: SERVICE_STATUS;
  ts:TDateTime;
begin
  Result := False;

  SCMHandle := OpenSCManager(PAnsiChar(AServer), nil, SC_MANAGER_ALL_ACCESS);
  if SCMHandle <> 0 then
  try
    ServiceHandle := OpenService(SCMHandle, PAnsiChar(AServiceName), SERVICE_ALL_ACCESS);
    if ServiceHandle <> 0 then
    begin
      ResetMemory(SS, SizeOf(SS));
      Result := ControlService(ServiceHandle, SERVICE_CONTROL_STOP, SS);
      if Result then
      begin
        ts := Now;
        repeat
          ResetMemory(SS, SizeOf(SS));
          QueryServiceStatus(ServiceHandle,SS);
        until (SS.dwCurrentState = SERVICE_STOPPED) or ((Now-ts)> 5/24/3600);
        Result := SS.dwCurrentState = SERVICE_STOPPED;
      end;
    end;
    CloseServiceHandle(ServiceHandle);
  finally
    CloseServiceHandle(SCMHandle);
  end;
end;

function GetGroups(srvName, usrName: WideString):TDynStringArray;
var
  dwEntriesRead, dwEntriesTotal: DWORD;
  grpi0: Pointer;
  pInfo: PGroupInfo0;
  nErr: Integer;
begin
  SetLength(Result,0);
  nErr := NetUserGetGroups(PWideChar(srvName), PWideChar(usrName), 0, grpi0,MAX_PREFERRED_LENGTH, @dwEntriesRead, @dwEntriesTotal);
  if nErr = NERR_SUCCESS then
  begin
    pInfo := grpi0;
    while dwEntriesRead > 0 do
    begin
      SetLength(result,length(result)+1);
      result[length(result)-1] := pInfo^.grpi0_name;
      Inc(pInfo);
      Dec(dwEntriesRead);
    end;
    NetAPIBufferFree(grpi0);
  end;
end;

function GetLocalGroups:TDynStringArray;
var
  dwEntriesRead, dwEntriesTotal,resumehandle: DWORD;
  grpi0: Pointer;
  pInfo: PGroupInfo0;
  nErr: Integer;
begin
  SetLength(Result,0);
  resumehandle := 0;
  nErr := NetLocalGroupEnum (Nil, 0, grpi0,MAX_PREFERRED_LENGTH, @dwEntriesRead, @dwEntriesTotal,Nil);
  if nErr = NERR_SUCCESS then
  begin
    pInfo := grpi0;
    while dwEntriesRead > 0 do
    begin
      SetLength(result,length(result)+1);
      result[length(result)-1] := pInfo^.grpi0_name;
      Inc(pInfo);
      Dec(dwEntriesRead);
    end;
    NetAPIBufferFree(grpi0);
  end;
end;

function GetLocalGroupMembers(GroupName:WideString):TDynStringArray;
var
  dwEntriesRead, dwEntriesTotal,resumehandle: DWORD;
  grpi0: Pointer;
  pInfo: PLOCALGROUP_MEMBERS_INFO_3;
  nErr: Integer;
begin
  SetLength(Result,0);
  resumehandle := 0;
  nErr := NetLocalGroupGetMembers(Nil,PWideChar(GroupName),3,grpi0,MAX_PREFERRED_LENGTH, @dwEntriesRead, @dwEntriesTotal,Nil);
  if nErr = NERR_SUCCESS then
  begin
    pInfo := grpi0;
    while dwEntriesRead > 0 do
    begin
      SetLength(result,length(result)+1);
      result[length(result)-1] := pInfo^.lgrmi3_domainandname;
      Inc(pInfo);
      Dec(dwEntriesRead);
    end;
    NetAPIBufferFree(grpi0);
  end;
end;

function UserLogin(user,password,domain:String):THandle;
var
  htok:THandle;
begin
 {$H-}
  if not LogonUser(PAnsiChar(user),pAnsichar(domain),pAnsichar(password),LOGON32_LOGON_NETWORK,LOGON32_PROVIDER_DEFAULT,htok) then
    raise EXCEPTION.Create('Unable to login as '+user+' on domain '+domain);
  result := htok;
  {$H+}
end;

function OnSystemAccount(): Boolean;
begin
  Result := GetCurrentUserSid='S-1-5-18';
end;

function UserDomain(htoken:THandle):AnsiString;
var
  cbBuf: Cardinal;
  ptiUser: PTOKEN_USER;
  snu: SID_NAME_USE;
  ProcessHandle: THandle;
  UserSize, DomainSize: DWORD;
  bSuccess: Boolean;
  user,domain:AnsiString;
begin
  Result := '';
  bSuccess := GetTokenInformation(hToken, TokenUser, nil, 0, cbBuf);
  ptiUser  := nil;
  while (not bSuccess) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) do
  begin
    ReallocMem(ptiUser, cbBuf);
    bSuccess := GetTokenInformation(hToken, TokenUser, ptiUser, cbBuf, cbBuf);
  end;

  if not bSuccess then
  begin
    Exit;
  end;

  UserSize := 0;
  DomainSize := 0;
  LookupAccountSid(nil, ptiUser^.User.Sid, nil, UserSize, nil, DomainSize, snu);
  if (UserSize <> 0) and (DomainSize <> 0) then
  begin
    SetLength(User, UserSize);
    SetLength(Domain, DomainSize);
    if LookupAccountSid(nil, ptiUser^.User.Sid, PAnsiChar(User), UserSize,
      PAnsiChar(Domain), DomainSize, snu) then
    begin
      User := StrPas(PAnsiChar(User));
      Domain := StrPas(PAnsiChar(Domain));
      Result := Domain;
    end;
  end;

  if bSuccess then
  begin
    FreeMem(ptiUser);
  end;
end;

// From http://www.swissdelphicenter.ch/torry/showcode.php?id=2095
function ConvertSid(Sid: PSID; pszSidText: PAnsiChar; var dwBufferLen: DWORD): BOOL;
var
  psia: PSIDIdentifierAuthority;
  dwSubAuthorities: DWORD;
  dwSidRev: DWORD;
  dwCounter: DWORD;
  dwSidSize: DWORD;
begin
  Result := False;

  dwSidRev := SID_REVISION;

  if not IsValidSid(Sid) then Exit;

  psia := GetSidIdentifierAuthority(Sid);

  dwSubAuthorities := GetSidSubAuthorityCount(Sid)^;

  dwSidSize := (15 + 12 + (12 * dwSubAuthorities) + 1) * SizeOf(Char);

  if (dwBufferLen < dwSidSize) then
  begin
    dwBufferLen := dwSidSize;
    SetLastError(ERROR_INSUFFICIENT_BUFFER);
    Exit;
  end;

  StrFmt(pszSidText, 'S-%u-', [dwSidRev]);

  if (psia^.Value[0] <> 0) or (psia^.Value[1] <> 0) then
    StrFmt(pszSidText + StrLen(pszSidText),
      '0x%.2x%.2x%.2x%.2x%.2x%.2x',
      [psia^.Value[0], psia^.Value[1], psia^.Value[2],
      psia^.Value[3], psia^.Value[4], psia^.Value[5]])
  else
    StrFmt(pszSidText + StrLen(pszSidText),
      '%u',
      [DWORD(psia^.Value[5]) +
      DWORD(psia^.Value[4] shl 8) +
      DWORD(psia^.Value[3] shl 16) +
      DWORD(psia^.Value[2] shl 24)]);

  dwSidSize := StrLen(pszSidText);

  for dwCounter := 0 to dwSubAuthorities - 1 do
  begin
    StrFmt(pszSidText + dwSidSize, '-%u',
      [GetSidSubAuthority(Sid, dwCounter)^]);
    dwSidSize := StrLen(pszSidText);
  end;

  Result := True;
end;

function ObtainTextSid(hToken: THandle; pszSid: PAnsiChar;
  var dwBufferLen: DWORD): BOOL;
var
  dwReturnLength: DWORD;
  dwTokenUserLength: DWORD;
  tic: TTokenInformationClass;
  ptu: Pointer;
begin
  Result := False;
  dwReturnLength := 0;
  dwTokenUserLength := 0;
  tic := TokenUser;
  ptu := nil;

  if not GetTokenInformation(hToken, tic, ptu, dwTokenUserLength,
    dwReturnLength) then
  begin
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      ptu := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, dwReturnLength);
      if ptu <> nil then
      try
        dwTokenUserLength := dwReturnLength;
        dwReturnLength    := 0;
        if not GetTokenInformation(hToken, tic, ptu, dwTokenUserLength,
          dwReturnLength) then Exit;
        if not ConvertSid((PTokenUser(ptu)^.User).Sid, pszSid, dwBufferLen) then Exit;
        Result := True;
      finally
        if ptu <> Nil then
          HeapFree(GetProcessHeap, 0, ptu);
      end;
    end
    else
      Exit;
  end;

end;

function GetCurrentUserSid: Ansistring;
var
  hAccessToken: THandle;
  bSuccess: BOOL;
  dwBufferLen: DWORD;
  szSid: array[0..260] of AnsiChar;
begin
  Result := '';

  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
  end;
  if bSuccess then
  begin
    ZeroMemory(@szSid, SizeOf(szSid));
    dwBufferLen := SizeOf(szSid);

    if ObtainTextSid(hAccessToken, szSid, dwBufferLen) then
      Result := szSid;
    CloseHandle(hAccessToken);
  end;
end;

procedure SetUserProfilePath(SID:AnsiString;ImagePath:AnsiString);
var
  r: TRegistry;
begin
  r := TRegistry.Create(KEY_ALL_ACCESS);
  try
    r.RootKey:=HKEY_LOCAL_MACHINE;
    r.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\'+SID,True);
    r.WriteExpandString('ProfileImagePath',ImagePath);
  finally
    r.CloseKey;
    r.Free;
  end;
end;

function GetUserProfilePath(SID:String):String;
var
  r: TRegistry;
begin
  r := TRegistry.Create(KEY_READ);
  try
    r.RootKey:=HKEY_LOCAL_MACHINE;
    r.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\'+SID,False);
    Result := r.ReadString('ProfileImagePath');
  finally
    r.CloseKey;
    r.Free;
  end;
end;


function GetCmdParams(ID:Utf8String;Default:Utf8String=''):Utf8String;
var
	i:integer;
	S:Utf8String;
  found:Boolean;
begin
	Result:='';
  found:=False;
	for i:=1 to ParamCount do
	begin
		S:=ParamStrUTF8(i);
		if
			(UTF8CompareText(Copy(S, 1, Length(ID)+2), '/'+ID+'=') = 0) or
			(UTF8CompareText(Copy(S, 1, Length(ID)+2), '-'+ID+'=') = 0) or
			(UTF8CompareText(Copy(S, 1, Length(ID)+3), '--'+ID+'=') = 0) then
		begin
      found:=True;
			Result:=Copy(S,pos('=',S)+1,MaxInt);
			Break;
		end;
	end;
  if not Found then
    Result:=Default;
end;
{$endif}

end.

