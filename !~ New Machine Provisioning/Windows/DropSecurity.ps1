#Requires -RunAsAdministrator

# Admin & Tamper Protection Check; yell at user if it hasn't been disabled.
$regTamperProtection = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
try {
    $protCheck = Get-ItemProperty -Path $regTamperProtection -Name "TamperProtection"
    if ($protCheck.TamperProtection -eq 5) {
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show(
            "Tamper Protection is enabled. Please disable it before proceeding.`n`nSteps:`n(Windows Key) > 'Tamper Protection' > Toggle 'Tamper Protection' to Off.`n`nRe-run this script after completing.",
            'Tamper Protection Warning',
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Warning
        )
        exit
    } else {
        Write-Host '[+] Tamper Protection is disabled.' -ForegroundColor Green
    }
} catch {
    Write-Warning "[-] Error checking Tamper Protection status."
    exit
}
#--------------------------------------------------------------------------------------------------#
### Yes I'm aware this is gross, but in my defense I'm incredibly lazy. I'll optimize this later ###
#--------------------------------------------------------------------------------------------------#
$parentDir = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
$rtpPath = "$parentDir\Real-Time Protection"
$spynetPath = "$parentDir\Spynet"
$sigUpdatePath = "$parentDir\Signature Updates"
$smartScreenPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

Write-Host '[+] Modifying the Registry...' -ForegroundColor Green
# Disabling Real-Time Protection
New-Item -Path $rtpPath -Force | Out-Null
Set-ItemProperty -Path $rtpPath -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord
Set-ItemProperty -Path $rtpPath -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord
Set-ItemProperty -Path $rtpPath -Name "DisableScriptScanning" -Value 1 -Type DWord
Set-ItemProperty -Path $rtpPath -Name "DisableIntrusionPreventionSystem" -Value 1 -Type DWord
Set-ItemProperty -Path $rtpPath -Name "DisableIOAVProtection" -Value 1 -Type DWord 
Write-Host '[+] RTP Disabled'
# Disabling Telemetry/payload submission; This helps your professor by not forcing me to re-make our malware every semester.
# If you're reading this, don't submit our samples to VirusTotal, thx.
New-Item -Path $spynetPath -Force | Out-Null
Set-ItemProperty -Path $spynetPath -Name "SubmitSamplesConsent" -Value 2 -Type DWord
Set-ItemProperty -Path $spynetPath -Name "SpynetReporting" -Value 0 -Type DWord
Write-Host '[+] Telemetry Disabled'
# Disable Signature Adjustment
New-Item -Path $sigUpdatePath -Force | Out-Null
Set-ItemProperty -Path $sigUpdatePath -Name "SignatureDisableUpdateOnStartupWithoutEngine" -Value 1 -Type DWord
Write-Host '[+] Signatures Disabled'
# SmartScreen Shenannigans
New-Item -Path $smartScreenPath -Force | Out-Null
Set-ItemProperty -Path $smartScreenPath -Name "EnableSmartScreen" -Value 0 -Type DWord
Write-Host '[+] SmartScreen Disabled'
Write-Host '[+] Registry modifications complete!' -ForegroundColor Green
