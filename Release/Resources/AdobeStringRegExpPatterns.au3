;Homescreen trial-expired Banner fix

Global $iPatternBannerS = '72656C6174696F6E7368697050726F66696C65'
Global $iPatternBannerR[1] = ["78656C6174696F6E7368697050726F66696C65"]

;PROFILE_EXPIRED - EndlessTrial-Creative cloud account works  - PROFILE_EXPIRED
;AfterEffects,PremierPro,PremiereRush,MediaEncoder,CharacterAnimator,Audition,Prelude,Bridge,InCopy,InDesign,Photoshop,Illustrator,Lightroom 1&2
;mov eax (192,193,194,195) -> 0


Global $iPatternPROFILE_EXPIREDS = '85C075(.{10})75(.{2})B892010000E9'
Global $iPatternPROFILE_EXPIREDR[5] = ["31C075","004883FF0F","75","00","B800000000E9"]

; Acrobat 85C075??B892010000E9
Global $iPatternPROFILE_EXPIRED1S = '85C075(.{2})B892010000E9'
Global $iPatternPROFILE_EXPIRED1R[3] = ["85C075","00","B800000000E9"]

;Global $iPatternPROFILE_EXPIRED2S = '75(.{2})B893010000E9'
;Global $iPatternPROFILE_EXPIRED2R[3] = ["75","00","B800000000E9"]

;Instant shutdown if not sign-in  CmpEax6 and mov qword ->3 to unlock homescreen and Lightroom dev module


Global $iPatternCmpEax61S =  '8B(.{2})85C074(.{2})83F80674(.{4})83(.{4})007D'
Global $iPatternCmpEax61R[9] = ["C7","??","030000","00","83F80674","00??","83","????","00EB"]

Global $iPatternCmpEax62S =  '8B(.{2})85C074(.{2})83F80674(.{4})83(.{6})007D'
Global $iPatternCmpEax62R[9] = ["C7","??","030000","00","83F80674","00??","83","??????","00EB"]

Global $iPatternCmpEax63S =  '8B(.{4})85C074(.{2})83F80674(.{4})83(.{4})007D'
Global $iPatternCmpEax63R[9] = ["C7","????","030000","00","83F80674","00??","83","????","00EB"]

Global $iPatternCmpEax64S =  '8B(.{4})85C074(.{2})83F80674(.{4})83(.{6})007D'
Global $iPatternCmpEax64R[9] = ["C7","????","030000","00","83F80674","00??","83","??????","00EB"]


;ProcessV2Profile1a - %s: request id: %lu api: %d call-status: %d profile-status: %d sequence: %s workflow?: %s spinner?: %s
; Small Jump Allow to start apps without Login
Global $iPatternProcessV2Profile1aS = '00007504488D4850'
Global $iPatternProcessV2Profile1aR[1]= ["00007500488D4850"]

;ProcessV2Profile1a - %s: request id: %lu api: %d call-status: %d profile-status: %d sequence: %s workflow?: %s spinner?: %s
; Small Jump Allow to start apps without Login
Global $iPatternProcessV2Profile1a1S = '00007504488D5050'
Global $iPatternProcessV2Profile1a1R[1]= ["00007500488D5050"]


;"%s: profile status %d, AMT status %d"
;Instant shutdown if not sign-in ValidateLicense - "ValidateLicense" go up
Global $iPatternValidateLicenseS =  '83F80175(.{2})BA94010000'
Global $iPatternValidateLicenseR[3] = ["83F80175","??","BA00000000"]

;Instant shutdown if not sign-in ValidateLicense - "ValidateLicense" go up
Global $iPatternValidateLicense1S =  '83F8040F95C281C293010000'
Global $iPatternValidateLicense1R[1] = ["83F8040F95C2BA0000000090"]

;Instant shutdown if not sign-in ValidateLicense - "ValidateLicense" go up
Global $iPatternValidateLicense2S =  '83F8040F95C181C193010000'
Global $iPatternValidateLicense2R[1] = ["83F8040F95C1B90000000090"]




;For Lightroom 1&2 Subscriber status 1!

;Global $iPatternLightSubStatus1S = '85(.{2})0F84(.{8})83(.{2})010F84(.{8})83(.{2})0274'
;Global $iPatternLightSubStatus1R [11]= ["85","??","0F84","????????","83","??","010F84","????????","83","??","02EB"]



;Bridge cache,camera raw,colors 2022
Global $iPatternBridgeCamRaw1S = '84C074(.{2})8B(.{2})83(.{2})0174(.{2})83(.{2})0174(.{2})83(.{2})01'
Global $iPatternBridgeCamRaw1R[15] = ["84C074","??","8B","??","83","??","01EB","??","83","??","0174","??","83","??","01"]

;Bridge cache,camera raw,colors 2023


Global $iPatternBridgeCamRaw2S = '4084F60F85(.{8})4084ED0F84'
Global $iPatternBridgeCamRaw2R[3] = ["4084F60F85","????????","40FEC60F85"]



;XDComplete
;Global $iPatternXDCompleteS = '807909000F84'
;Global $iPatternXDCompleteR[1] = ["C64109010F85"]



;HEVC & MPEG enabler - SweetPeaSupport.dll
;AfterEffects,PremierPro,MediaEncoder,Prelude,Rush

;FF50??0FB6
;FF50????0FB6

Global $iPatternHevcMpegEnabler1S = 'FF50(.{2})0FB6'
Global $iPatternHevcMpegEnabler1R[3] = ["FFC0","90","0FB6"]

Global $iPatternHevcMpegEnabler2S = 'FF50(.{4})0FB6'
Global $iPatternHevcMpegEnabler2R[3] = ["FFC0","90??","0FB6"]




;dvaappsupport.dll - ?IsValid@CreativeCloudIdentity@CloudService
;488379 ???? 740A488379 ???? 7403B001C332C0C3
;488379 ???? 740A488379 ???? 7403B001C3B001C3


Global $iPatternTeamProjectEnablerAS = '488379(.{4})740A488379(.{4})7403B001C332C0C3'
Global $iPatternTeamProjectEnablerAR[5] = ["488379","????","740A488379","????","7403B001C3B001C3"]



;Acrobat dll
;---------------------------------------------------------------------------------------------------
;Global $iPatternAcrobatAS = 'EB(.{2})33C066A3(.{8})881D(.{8})8AC35BC3' ;"IsAMTEnforced"
;Global $iPatternAcrobatAR[4] = ["EB","B00166A3","881D","8AC35BC3"]


;acrodistdll.dll
;---------------------------------------------------------------------------------------------------
;Global $iPatternAcrodistAS = '5332DBE8(.{8})84C075(.{2})E8(.{8})84C074(.{2})32C05BC3' ;"IsAMTEnforced"
;Global $iPatternAcrodistAR[5] = ["5332DBE8","30C075","E8","FEC074","32C05BC3"]

;acrotray.exe
;---------------------------------------------------------------------------------------------------
;Global $iPatternAcroTrayAS = '5332DBE8(.{8})84C075(.{2})E8(.{8})84C074(.{2})32C05BC3' ;"IsAMTEnforced"
;Global $iPatternAcroTrayAR[5] = ["5332DBE8","30C075","E8","FEC074","32C05BC3"]




;AppsPanelBL.dll

;trial remover ( find pointers by word freemium )
;83 78 ?? ?? 0F 84 ?? ?? ?? ?? 83 78 ?? ?? 0F 84 ?? ?? ?? ?? 83 78 ?? ?? 0F 84 ?? ?? ?? ?? 33 C0
;C6 40 ?? ?? 0F 84 ?? ?? ?? ?? C6 40 ?? ?? 0F 84 ?? ?? ?? ?? C6 40 ?? ?? 0F 84 ?? ?? ?? ?? 33 C0

;---------------------------------------------------------------------------------------------------
Global $iPatternACC1S = '8378(.{4})0F84(.{8})8378(.{4})0F84(.{8})8378(.{4})0F84(.{8})33C0'
Global $iPatternACC1R[13] = ["C640","????","0F84","????????","C640","????","0F84","????????","C640","????","0F84","????????","33C0"]


;"ccd.fw.userEntitlement"
;Inc al
;for older and other versions

;E8????????85C00F85????????83EC??8BCC89
;E8????????FEC00F85????????83EC??8BCC89

Global $iPatternACC2S = 'E8(.{8})85C00F85(.{8})83EC(.{2})8BCC89'
Global $iPatternACC2R[7] = ["E8","????????","FEC00F85","????????","83EC","??","8BCC89"]




;---------------------------------------------------------------------------------------------------
