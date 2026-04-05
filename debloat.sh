#!/usr/bin/env bash
# =============================================================================
# Debloater Enhanced — Multi-Brand Edition
# Version 4.0 | Author: Saksham Shekher
# Targets: OPPO / Realme (ColorOS 13+) | Xiaomi / Redmi (MIUI 14 / HyperOS)
#          OnePlus (OxygenOS 13/14)
# =============================================================================
# DISCLAIMER: Use at your own risk. Some packages may be required for full
# device functionality. Review each category carefully before proceeding.
# To restore any removed package:
#   adb shell cmd package install-existing <package.name>
# =============================================================================

# ── ANSI color codes ──────────────────────────────────────────────────────────
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[1;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ── Runtime state ─────────────────────────────────────────────────────────────
DRY_RUN=false
LOG_ENABLED=false
LOG_FILE="debloater_$(date +%Y%m%d_%H%M%S).log"
REMOVED_PKGS=()
DISABLED_PKGS=()
RESTORE_FILE=""     # lazy-initialized on first successful removal/disable

# ── Logging helpers ───────────────────────────────────────────────────────────
info()    { echo -e "  ${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "  ${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "  ${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "  ${RED}[ERR]${NC}   $*" >&2; }
section() { echo -e "\n${BOLD}${BLUE}  ══ $* ══${NC}"; }

log_action() {
    $LOG_ENABLED && echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# ── Restore-file helper ───────────────────────────────────────────────────────
# Lazily creates restore_packages_*.txt on the first successful action,
# then appends one line per package so the user can reinstall/re-enable later.
_write_restore_file() {
    local pkg="$1" action="$2"
    if [[ -z "$RESTORE_FILE" ]]; then
        RESTORE_FILE="restore_packages_$(date +%Y%m%d_%H%M%S).txt"
        local model brand
        model=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
        brand=$(adb shell getprop ro.product.brand 2>/dev/null | tr -d '\r')
        {
            printf "# Debloater Enhanced — Package Restore List\n"
            printf "# Generated : %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
            printf "# Device    : %s (%s)\n" "$model" "$brand"
            printf "#\n"
            printf "# To reinstall a REMOVED package:\n"
            printf "#   adb shell cmd package install-existing <package_id>\n"
            printf "#\n"
            printf "# To re-enable a DISABLED package:\n"
            printf "#   adb shell pm enable --user 0 <package_id>\n"
            printf "# ──────────────────────────────────────────────────────────\n"
        } > "$RESTORE_FILE"
    fi
    printf "%-60s  # %s\n" "$pkg" "$action" >> "$RESTORE_FILE"
}

# ── Banner ────────────────────────────────────────────────────────────────────
print_banner() {
    echo -e "${BOLD}${MAGENTA}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║       Debloater Enhanced — Multi-Brand Edition       ║"
    echo "  ║                     Version 4.0                      ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "  ${DIM}Author  : Saksham Shekher${NC}"
    echo -e "  ${RED}${BOLD}WARNING : Debloat at your own risk!${NC}"
    echo -e "  ${DIM}Tip     : Enable dry-run [d] first to preview changes.${NC}"
    echo
}

# ── Prerequisite checks ───────────────────────────────────────────────────────
check_adb() {
    if ! command -v adb &>/dev/null; then
        error "ADB not found. Install Android Platform Tools and add 'adb' to your PATH."
        error "Download: https://developer.android.com/studio/releases/platform-tools"
        exit 1
    fi
}

check_device() {
    local count
    count=$(adb devices 2>/dev/null | grep -c $'\tdevice$')
    if [[ "$count" -eq 0 ]]; then
        error "No authorised device detected."
        warn  "  1. Enable USB Debugging (Settings → About Phone → tap Build Number ×7)"
        warn  "  2. Connect via USB and tap 'Allow' on the device prompt"
        warn  "  3. Confirm your USB cable supports data transfer"
        exit 1
    fi
    if [[ "$count" -gt 1 ]]; then
        warn "Multiple devices found. Using the first one. Set ANDROID_SERIAL to target a specific device."
    fi
}

# ── Device information ────────────────────────────────────────────────────────
print_device_info() {
    local model brand android coloros miui
    model=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    brand=$(adb shell getprop ro.product.brand 2>/dev/null | tr -d '\r')
    android=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    coloros=$(adb shell getprop ro.build.version.oplusrom.display 2>/dev/null | tr -d '\r')
    [[ -z "$coloros" ]] && coloros=$(adb shell getprop ro.coloros.version.display 2>/dev/null | tr -d '\r')
    miui=$(adb shell getprop ro.miui.ui.version.name 2>/dev/null | tr -d '\r')
    [[ -z "$coloros" ]] && coloros="N/A"
    [[ -z "$miui" ]] && miui="N/A"

    echo -e "  ${BOLD}Connected Device${NC}"
    echo    "  ┌─────────────────────────────────┐"
    printf  "  │  %-10s : %-19s│\n" "Model"   "$model"
    printf  "  │  %-10s : %-19s│\n" "Brand"   "$brand"
    printf  "  │  %-10s : %-19s│\n" "Android" "$android"
    printf  "  │  %-10s : %-19s│\n" "ColorOS" "$coloros"
    printf  "  │  %-10s : %-19s│\n" "MIUI/HOS" "$miui"
    echo    "  └─────────────────────────────────┘"
    echo

    local brand_lc
    brand_lc=$(echo "$brand" | tr '[:upper:]' '[:lower:]')
    if [[ "$brand_lc" != "oppo" && "$brand_lc" != "realme" && \
          "$brand_lc" != "oneplus" && "$brand_lc" != "xiaomi" && \
          "$brand_lc" != "redmi" && "$brand_lc" != "poco" ]]; then
        warn "This script targets OPPO/Realme/Xiaomi/Redmi/OnePlus devices."
        warn "Detected brand: '${brand}'. Package names may not match — proceed with caution."
        echo
    fi
}

# ── Core install/remove engine ────────────────────────────────────────────────
# Usage: uninstall_pkg <package> <friendly-name>
uninstall_pkg() {
    local pkg="$1" name="${2:-$1}"

    if ! adb shell pm list packages 2>/dev/null | grep -q "^package:${pkg}$"; then
        echo -e "  ${DIM}  SKIP    ${pkg} (not installed)${NC}"
        log_action "SKIP    $pkg — not installed"
        return 0
    fi

    if $DRY_RUN; then
        echo -e "  ${YELLOW}  DRY-RUN${NC} Would remove: ${BOLD}${name}${NC} (${pkg})"
        log_action "DRY-RUN $pkg — $name"
        return 0
    fi

    local out
    out=$(adb shell pm uninstall --user 0 "$pkg" 2>&1)
    if echo "$out" | grep -q "Success"; then
        echo -e "  ${GREEN}  REMOVED${NC} ${BOLD}${name}${NC} (${pkg})"
        log_action "REMOVED $pkg — $name"
        REMOVED_PKGS+=("$pkg")
        _write_restore_file "$pkg" "REMOVED"
    else
        echo -e "  ${RED}  FAILED${NC}  ${BOLD}${name}${NC} (${pkg}) → ${out}"
        log_action "FAILED  $pkg — $name → $out"
    fi
}

# Usage: disable_pkg <package> <friendly-name>
disable_pkg() {
    local pkg="$1" name="${2:-$1}"

    if ! adb shell pm list packages 2>/dev/null | grep -q "^package:${pkg}$"; then
        echo -e "  ${DIM}  SKIP    ${pkg} (not installed)${NC}"
        return 0
    fi

    if $DRY_RUN; then
        echo -e "  ${YELLOW}  DRY-RUN${NC} Would disable: ${BOLD}${name}${NC} (${pkg})"
        return 0
    fi

    local out
    out=$(adb shell pm disable-user --user 0 "$pkg" 2>&1)
    if echo "$out" | grep -qi "disabled"; then
        echo -e "  ${CYAN}  DISABLED${NC} ${BOLD}${name}${NC} (${pkg})"
        log_action "DISABLED $pkg — $name"
        DISABLED_PKGS+=("$pkg")
        _write_restore_file "$pkg" "DISABLED"
    else
        echo -e "  ${RED}  FAILED${NC}  disable ${BOLD}${name}${NC} (${pkg}) → ${out}"
        log_action "FAILED  disable $pkg — $name → $out"
    fi
}

confirm() {
    local prompt="${1:-Continue?}"
    local answer
    echo
    echo -e "  ${YELLOW}${prompt}${NC}"
    echo -ne "  Type ${BOLD}yes${NC} to proceed, anything else to cancel: "
    read -r answer
    [[ "$answer" == "yes" ]]
}

# =============================================================================
# DEBLOAT CATEGORIES — ColorOS 13.1
# =============================================================================

# ── 1. Analytics, Telemetry & Spyware ────────────────────────────────────────
debloat_analytics() {
    section "Analytics, Telemetry & Spyware"
    echo -e "  ${DIM}Removes silent data-collection, crash reporting, and ad-serving components.${NC}"
    confirm "Remove analytics & telemetry packages?" || { info "Skipped."; return; }

    uninstall_pkg "com.heytap.habit.analysis"     "HeyTap Intelligent Analytics"
    uninstall_pkg "com.nearme.statistics.rom"      "NearMe ROM Statistics"
    uninstall_pkg "com.oplus.logkit"               "OPlus Feedback / Log Kit"
    uninstall_pkg "com.oplus.crashbox"             "OPlus CrashBox"
    uninstall_pkg "com.oplus.statistical"          "OPlus Statistical Service"
    uninstall_pkg "com.tencent.soter.soterserver"  "Tencent Soter Server (Telemetry)"
    uninstall_pkg "com.coloros.activation"         "ColorOS E-Warranty / Activation"
    uninstall_pkg "com.oplus.stdid"                "OPlus Standard ID Service"
    uninstall_pkg "com.oplus.lfeh"                 "OPlus LFEHer (Behaviour Tracking)"
    uninstall_pkg "com.oppoex.afterservice"        "OPPO After-Sales Diagnostics"
    uninstall_pkg "com.realme.securitycheck"       "Realme Security Analysis"
    uninstall_pkg "com.opos.cs"                    "OPOS Content Services / Hot Apps"
    uninstall_pkg "com.coloros.diag"               "ColorOS Diagnostics Daemon"
    uninstall_pkg "com.nearme.push"                "NearMe Push Service (Ad Notifications)"
    uninstall_pkg "com.oplus.aiunit"               "OPlus AI Unit (Behavioural Analytics)"
    uninstall_pkg "com.oplus.omcservice"           "OPlus Operator Management Content (Promos)"

    # OPPO/ColorOS analytics, diagnostics & telemetry
    uninstall_pkg "com.coloros.athena"             "ColorOS Athena (AI Telemetry Service)"
    uninstall_pkg "com.coloros.avastofferwall"     "Avast Offer Wall (Ad/Tracking Preload)"
    uninstall_pkg "com.coloros.bootreg"            "ColorOS Boot Registry (System Stats)"
    uninstall_pkg "com.coloros.healthcheck"        "ColorOS Health Check Service"
    uninstall_pkg "com.coloros.resmonitor"         "ColorOS Resource Monitor"
    uninstall_pkg "com.coloros.sauhelper"          "ColorOS SAU Helper (Usage Analytics)"
    uninstall_pkg "com.coloros.sceneservice"       "ColorOS Scene Service (Usage Tracking)"
    uninstall_pkg "com.oppo.ScoreAppMonitor"       "OPPO Score App Monitor"
    uninstall_pkg "com.oppo.criticallog"           "OPPO Critical Log Service"
    uninstall_pkg "com.oppo.logkit"                "OPPO Log Kit"
    uninstall_pkg "com.oppo.qualityprotect"        "OPPO Quality Protect"
    uninstall_pkg "com.oppo.startlogkit"           "OPPO Startup Log Kit"
    uninstall_pkg "com.oppo.usageDump"             "OPPO Usage Dump"
    uninstall_pkg "com.oppo.lfeh"                  "OPPO LFEH Behaviour Tracking"

    disable_pkg "com.coloros.safesdkproxy"         "ColorOS Safe SDK Proxy"
    disable_pkg "com.oppo.nw"                      "OPPO Network Service Monitor"
    disable_pkg "com.oppo.rftoolkit"               "OPPO RF Toolkit (Factory Diagnostics)"
    disable_pkg "com.oppo.wifirf"                  "OPPO WiFi RF Test Tool"
    disable_pkg "com.oppo.bttestmode"              "OPPO Bluetooth Test Mode"
    disable_pkg "com.dsi.ant.server"               "DSI ANT+ Server"

    success "Analytics & telemetry debloated."
}

# ── 2. ColorOS / OPPO System Bloatware ───────────────────────────────────────
debloat_coloros() {
    section "ColorOS / OPPO System Bloatware"
    echo -e "  ${DIM}Removes pre-installed OPPO/Realme apps not essential to ColorOS 13.1.${NC}"
    confirm "Remove ColorOS bloatware?" || { info "Skipped."; return; }

    # Browsing & search
    uninstall_pkg "com.heytap.browser"             "HeyTap Browser"
    uninstall_pkg "com.oppo.quicksearchbox"        "OPPO Home Screen Search"
    uninstall_pkg "com.nearme.browser"             "NearMe Browser"

    # Multimedia
    uninstall_pkg "com.heytap.music"               "HeyTap Music"
    uninstall_pkg "com.coloros.video"              "ColorOS Video Player"
    uninstall_pkg "com.realme.movieshot"           "Realme MovieShot / Combine Captions"
    uninstall_pkg "com.oppo.music"                 "OPPO Music Player"

    # Cloud & backup
    uninstall_pkg "com.heytap.cloud"               "HeyTap Cloud"
    uninstall_pkg "com.coloros.backuprestore"      "ColorOS Backup & Restore"
    uninstall_pkg "com.coloros.backuprestore.remoteservice" "ColorOS Backup Remote Service"
    uninstall_pkg "com.coloros.wifibackuprestore"  "ColorOS WiFi Backup & Restore"

    # Social & account services
    uninstall_pkg "com.realmecomm.app"             "Realme Community"
    uninstall_pkg "com.heytap.usercenter"          "My OPPO / HeyTap User Centre"
    uninstall_pkg "com.oppo.usercenter"            "OPPO User Center"

    # App store & market
    uninstall_pkg "com.heytap.market"              "HeyTap GetApps Market"
    uninstall_pkg "com.oppo.market"                "OPPO App Market"
    uninstall_pkg "com.nearme.themestore"          "NearMe Theme Store"

    # Non-essential utilities
    uninstall_pkg "com.coloros.compass2"           "ColorOS Compass"
    uninstall_pkg "com.coloros.oshare"             "O-Share (File Transfer)"
    uninstall_pkg "com.coloros.ocrscanner"         "ColorOS Smart Scan (OCR)"
    uninstall_pkg "com.coloros.smartdrive"         "ColorOS Smart Driving"
    uninstall_pkg "com.coloros.oppomultiapp"       "OPPO Clone Phone"
    uninstall_pkg "com.oplus.multiapp"             "OPlus App Cloner"
    uninstall_pkg "com.oppo.opperationManual"      "OPPO User Guide / Manual (legacy)"
    uninstall_pkg "com.oppo.operationManual"       "OPPO Operation Manual"
    uninstall_pkg "com.os.docvault"                "Doc Vault"
    uninstall_pkg "com.redteamobile.roaming"       "O-Roaming (eSIM Roaming)"
    uninstall_pkg "com.redteamobile.roaming.deamon" "Red Mobile Roaming Daemon"
    uninstall_pkg "com.nearme.atlas"               "OPPO Atlas"
    uninstall_pkg "com.oppo.atlas"                 "OPPO Atlas Service"
    uninstall_pkg "com.heytap.accessory"           "Quick Device Connect"
    uninstall_pkg "com.realme.wellbeing"           "Realme Wellbeing / Sleep Capsule"
    uninstall_pkg "com.oplus.linker"               "OPlus PC Connect"
    uninstall_pkg "com.oplus.synergy"              "Hey Synergy (Cross-Device)"
    uninstall_pkg "com.finshell.fin"               "Finshell"
    uninstall_pkg "com.oplus.cosa"                 "App Enhancement Engine (COSA)"
    uninstall_pkg "com.heytap.pictorial"           "Lockscreen Magazine"
    uninstall_pkg "com.oppo.sos"                   "OPPO Emergency SOS"
    uninstall_pkg "com.oplus.encryption"           "Private Safe"
    uninstall_pkg "com.coloros.note"               "ColorOS Notes"
    uninstall_pkg "com.coloros.healthkit"          "ColorOS Health"
    uninstall_pkg "com.oplus.voiceassistant"       "OPlus Voice Assistant"
    uninstall_pkg "com.oplus.omoji"                "OPlus Omoji (AR Emoji)"
    uninstall_pkg "com.oplus.babelfish"            "OPlus Babelfish Translation"
    uninstall_pkg "com.heytap.speechassist"        "HeyTap Speech Assistant"
    uninstall_pkg "com.nearme.live"                "NearMe Live Streaming"
    uninstall_pkg "com.coloros.tips"               "ColorOS Tips & What's New"
    uninstall_pkg "com.heytap.easyswitch"          "HeyTap Easy Switch (Cross-Device)"
    uninstall_pkg "com.coloros.documentmanager"    "ColorOS Document Manager"
    uninstall_pkg "com.oppo.assistivetouch"        "OPPO Assistive Touch / Navigator Ball"
    uninstall_pkg "com.coloros.appmanager"         "ColorOS App Manager"
    uninstall_pkg "com.coloros.assistantscreen"    "ColorOS Assistant Screen"
    uninstall_pkg "com.coloros.childrenspace"      "ColorOS Children's Space"
    uninstall_pkg "com.coloros.floatassistant"     "ColorOS Float Assistant"
    uninstall_pkg "com.coloros.focusmode"          "ColorOS Focus Mode"
    uninstall_pkg "com.coloros.phonenoareainquire" "ColorOS Phone Number Area Inquiry"
    uninstall_pkg "com.coloros.pictorial"          "ColorOS Pictorial / Magazine"
    uninstall_pkg "com.coloros.screenrecorder"     "ColorOS Screen Recorder"
    uninstall_pkg "com.coloros.soundrecorder"      "ColorOS Sound Recorder"
    uninstall_pkg "com.coloros.speechassist"       "ColorOS Speech Assist"
    uninstall_pkg "com.coloros.translate.engine"   "ColorOS Translate Engine"
    uninstall_pkg "com.oppo.mimosiso"              "OPPO Mimosiso"
    uninstall_pkg "com.oppo.ovoicemanager"         "OPPO Voice Manager"
    uninstall_pkg "com.oppo.partnerbrowsercustomizations" "OPPO Partner Browser Customizations"

    # Disable rather than remove (affects OTA / restore flow)
    disable_pkg "com.heytap.themestore"            "HeyTap Theme Store"
    disable_pkg "com.coloros.phonemanager"         "ColorOS Phone Manager"
    disable_pkg "com.caf.fmradio"                  "Qualcomm CAF FM Radio"
    disable_pkg "com.android.fmradio"              "FM Radio"
    disable_pkg "com.glance.internet"              "Glance (Lock Screen Ads)"

    success "ColorOS bloatware debloated."
}

# ── 3. Game Space & Gaming Services ──────────────────────────────────────────
debloat_gaming() {
    section "Game Space & Gaming Services"
    echo -e "  ${DIM}Removes Game Space UI, HeyFun platform and associated gaming services.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Removing Game Space disables its in-game FPS and network optimisations."
    confirm "Remove game-related bloatware?" || { info "Skipped."; return; }

    uninstall_pkg "com.coloros.gamespaceui"        "ColorOS Game Space UI"
    uninstall_pkg "com.coloros.gamespace"          "ColorOS Game Space Service"
    uninstall_pkg "com.heytap.quickgame"           "HeyTap HeyFun / Quick Game"
    uninstall_pkg "com.oplus.games"                "OPlus Games Platform"
    uninstall_pkg "com.nearme.game.platform"       "NearMe Game Platform"

    success "Gaming bloatware removed."
}

# ── 4. Payment & Financial Apps ───────────────────────────────────────────────
debloat_payments() {
    section "Payment & Financial Apps"
    echo -e "  ${DIM}Removes pre-installed regional payment and banking apps.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Skip this category if you actively use any of these services."
    confirm "Remove payment & financial apps?" || { info "Skipped."; return; }

    uninstall_pkg "com.oplus.pay"                  "OPlus Pay / Secure Payment"
    uninstall_pkg "com.coloros.securepay"          "ColorOS Secure Pay"
    uninstall_pkg "com.realmepay.payments"         "Realme PaySa"
    uninstall_pkg "com.coloros.wallet"             "ColorOS Wallet"

    success "Payment apps removed."
}

# ── 5. Facebook & Social Media Preloads ───────────────────────────────────────
debloat_social() {
    section "Facebook & Social Media Preloads"
    echo -e "  ${DIM}Removes Facebook system-level preloads and silent installer components.${NC}"
    confirm "Remove Facebook & social preloads?" || { info "Skipped."; return; }

    uninstall_pkg "com.facebook.services"          "Facebook Services"
    uninstall_pkg "com.facebook.appmanager"        "Facebook App Manager"
    uninstall_pkg "com.facebook.system"            "Facebook System"
    uninstall_pkg "com.facebook.katana"            "Facebook (Katana)"

    success "Social media preloads removed."
}

# ── 6. Google Bloatware ───────────────────────────────────────────────────────
debloat_google() {
    section "Google Bloatware"
    echo -e "  ${DIM}Removes non-essential Google apps. Core GMS services are NOT touched.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Removing Assistant may break some Google integrations."
    confirm "Remove Google bloatware?" || { info "Skipped."; return; }

    # Pre-installed Google apps
    uninstall_pkg "com.google.android.apps.tachyon"              "Google Meet / Duo"
    uninstall_pkg "com.google.android.apps.nbu.paisa.user"       "Google Pay (GPay India)"
    uninstall_pkg "com.google.android.apps.subscriptions.red"    "Google One"
    uninstall_pkg "com.google.android.marvin.talkback"           "TalkBack (Accessibility)"
    uninstall_pkg "com.google.android.keep"                      "Google Keep Notes"
    uninstall_pkg "com.google.android.music"                     "Google Play Music (legacy)"
    uninstall_pkg "com.google.android.videos"                    "Google Play Movies & TV"
    uninstall_pkg "com.google.android.apps.books"                "Google Play Books"
    uninstall_pkg "com.android.hotwordenrollment.okgoogle"       "OK Google Hotword Enrolment"
    uninstall_pkg "com.android.hotwordenrollment.xgoogle"        "X Google Hotword Enrolment"
    uninstall_pkg "com.google.android.apps.googleassistant"      "Google Assistant"
    uninstall_pkg "com.google.android.youtube"                   "YouTube"
    uninstall_pkg "com.google.android.apps.wellbeing"            "Google Digital Wellbeing"
    uninstall_pkg "com.google.android.apps.podcasts"             "Google Podcasts"
    uninstall_pkg "com.google.android.apps.youtube.music"        "YouTube Music"
    uninstall_pkg "com.google.android.apps.nbu.files"            "Files by Google"
    uninstall_pkg "com.google.ar.core"                           "Google AR Core"
    uninstall_pkg "com.google.android.printservice.recommendation" "Print Service Recommender"
    uninstall_pkg "com.google.ar.lens"                           "Google Lens (AR)"
    uninstall_pkg "com.google.android.apps.docs"                 "Google Drive / Docs"
    uninstall_pkg "com.google.android.feedback"                  "Google Market Feedback Agent"
    uninstall_pkg "com.google.android.projection.gearhead"       "Android Auto"
    uninstall_pkg "com.google.android.gm"                        "Gmail"
    uninstall_pkg "com.google.android.apps.safetyhub"            "Google Personal Safety"
    uninstall_pkg "com.google.android.googlequicksearchbox"      "Google Search App (GSB)"
    uninstall_pkg "com.google.android.apps.restore"              "Google Device Restore"
    uninstall_pkg "com.google.android.onetimeinitializer"        "Google One-Time Initializer"
    uninstall_pkg "com.google.android.apps.healthdata"           "Google Health Data"
    uninstall_pkg "com.google.android.adservices.api"            "Google Ad Services API"

    # Disable rather than fully remove (setup, telemetry, overlays)
    disable_pkg "com.android.stk"                                "SIM Toolkit"
    disable_pkg "com.android.nfc"                                "NFC Service"
    disable_pkg "com.google.android.setupwizard"                 "Google Setup Wizard"
    disable_pkg "com.google.android.federatedcompute"            "Google Federated Compute (ML)"
    disable_pkg "com.google.android.healthconnect.controller"    "Health Connect"
    disable_pkg "com.google.android.gms.location.history"        "Google Location History"
    disable_pkg "com.google.android.gms.supervision"             "Google Family Link / Supervision"
    disable_pkg "com.google.mainline.adservices"                 "Google Mainline Ad Services"
    disable_pkg "com.google.mainline.telemetry"                  "Google Mainline Telemetry"
    disable_pkg "com.google.android.as.oss"                      "Android System Intelligence (OSS)"
    disable_pkg "com.google.android.ondevicepersonalization.services" "Google On-Device Personalisation"
    disable_pkg "com.google.ambient.streaming"                   "Google Ambient Streaming (Cast)"
    disable_pkg "com.google.android.accessibility.switchaccess"  "Google Switch Access (Accessibility)"
    disable_pkg "com.google.android.overlay.modules.healthfitness.forframework" "Google Health Fitness Overlay"
    disable_pkg "com.google.android.cellbroadcastreceiver.overlay.miui"  "Cell Broadcast Receiver MIUI Overlay"
    disable_pkg "com.google.android.cellbroadcastservice.overlay.miui"   "Cell Broadcast Service MIUI Overlay"

    success "Google bloatware debloated."
}

# ── 8. Xiaomi / Redmi Analytics, Ads & Telemetry (MIUI 14 / HyperOS) ─────────
debloat_miui_analytics() {
    section "Xiaomi / Redmi Analytics, Ads & Telemetry"
    echo -e "  ${DIM}Removes MIUI/HyperOS ad services, usage trackers, and telemetry daemons.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Safe on all Xiaomi and Redmi global/India ROM builds."
    confirm "Remove Xiaomi/Redmi analytics & ad packages?" || { info "Skipped."; return; }

    uninstall_pkg "com.miui.analytics"              "MIUI Analytics (Telemetry Beacon)"
    uninstall_pkg "com.xiaomi.joyose"               "Xiaomi Joyose (Ad & Usage Targeting)"
    uninstall_pkg "com.miui.msa.global"             "MIUI System Ad Service"
    uninstall_pkg "com.miui.hybrid"                 "MIUI Hybrid Ad Bridge"
    uninstall_pkg "com.miui.systemadserver"         "MIUI System Ad Server"
    uninstall_pkg "com.miui.contentcatcher"         "MIUI Content Catcher (Ad Feeds)"
    uninstall_pkg "com.miui.global.mab"             "MIUI Mobile Ad Bridge (Global)"
    uninstall_pkg "com.miui.mab"                    "MIUI Mobile Ad Bridge"
    uninstall_pkg "com.miui.bugreport"              "MIUI Bug Report & Feedback"
    uninstall_pkg "com.xiaomi.mipicks"              "Mi Picks (Promotional Content)"
    uninstall_pkg "com.bsp.catchlog"                "BSP Catchlog (System Telemetry)"
    uninstall_pkg "com.xiaomi.miservice"            "Xiaomi Mi Service Framework (Telemetry)"
    uninstall_pkg "com.miui.catcherpatch"           "MIUI Catcher Patch"
    uninstall_pkg "com.miui.global.analytics"       "MIUI Global Analytics"
    uninstall_pkg "com.miui.hybrid.xiaomihybrid"    "Xiaomi Hybrid Ad Service"
    uninstall_pkg "com.xiaomi.aiasst.service"       "Xiaomi AI Assistant Service (Telemetry)"
    uninstall_pkg "com.xiaomi.aiasst.vision"        "Xiaomi AI Vision Analytics"
    uninstall_pkg "com.xiaomi.barrage"              "Xiaomi Barrage (Notification Bullets)"

    disable_pkg "com.miui.misightservice"           "MIUI MiSight Analytics Service"
    disable_pkg "com.miui.daemon"                   "MIUI Background Daemon"

    success "Xiaomi/Redmi analytics & ad packages removed."
}

# ── 9. Xiaomi / Redmi System App Bloatware (MIUI 14 / HyperOS) ───────────────
debloat_miui_apps() {
    section "Xiaomi / Redmi System App Bloatware"
    echo -e "  ${DIM}Removes pre-installed MIUI/HyperOS apps replaceable with alternatives.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Mi Pay / Xiaomi Payment — skip if actively using Xiaomi Pay."
    confirm "Remove Xiaomi/Redmi system bloat apps?" || { info "Skipped."; return; }

    # News & feed
    uninstall_pkg "com.mi.android.globalminusscreen" "Global Minus Screen (News Feed)"
    uninstall_pkg "com.miui.minusscreen"             "Minus Screen (Swipe-Left Feed)"
    uninstall_pkg "com.miui.personalassistant"       "MIUI Personal Assistant (Mi Daily)"
    uninstall_pkg "com.miui.contentextension"        "MIUI Content Extension (AI Recs)"
    uninstall_pkg "com.miui.newhome"                 "MIUI New Home (Wallpaper Suggestions)"
    uninstall_pkg "com.miui.suggest"                 "MIUI App Suggestions"
    uninstall_pkg "com.miui.android.fashiongallery"  "MIUI Fashion Gallery (Lock Screen Mag)"
    uninstall_pkg "com.miui.miwallpaper"             "MIUI AI Wallpaper"

    # Multimedia & utilities
    uninstall_pkg "com.miui.player"                  "Mi Music Player"
    uninstall_pkg "com.miui.videoplayer"             "Mi Video Player"
    uninstall_pkg "com.miui.notes"                   "Mi Notes"
    uninstall_pkg "com.miui.compass"                 "Mi Compass"
    uninstall_pkg "com.miui.fm"                      "Mi FM Radio"
    uninstall_pkg "com.miui.qr"                      "MIUI QR Scanner"
    uninstall_pkg "com.xiaomi.scanner"               "Xiaomi Smart Scanner"
    uninstall_pkg "com.miui.supercut"                "MIUI Super Cut (Scrolling Screenshot)"
    uninstall_pkg "com.miui.touchassistant"          "MIUI Touch Assistant (Floating Ball)"
    uninstall_pkg "com.miui.voiceassist"             "Mi Voice Assistant"

    # File sharing & cross-device
    uninstall_pkg "com.miui.mishare.connectivity"    "Mi Share (File Transfer)"
    uninstall_pkg "com.xiaomi.midrop"                "Mi Drop (P2P File Sharing)"
    uninstall_pkg "com.milink.service"               "MiLink Cross-Device Service"

    # Cloud & backup
    uninstall_pkg "com.miui.cloudbackup"             "MIUI Cloud Backup"
    uninstall_pkg "com.miui.cloudservice"            "MIUI Cloud Service"

    # Smart home & IoT
    uninstall_pkg "com.xiaomi.smarthome"             "Mi Home (Smart Home Hub)"

    # Productivity (replaceable)
    uninstall_pkg "cn.wps.xiaomi.abroad.lite"        "WPS Office Lite"
    uninstall_pkg "com.miui.yellowpage"              "Xiaomi Yellow Pages (Caller ID)"

    # Payment (skip if using)
    uninstall_pkg "com.xiaomi.payment"               "Xiaomi Payment / Mi Pay"

    # Third-party input methods bundled by OEM
    uninstall_pkg "com.sohu.inputmethod.sogou.xiaomi" "Sogou Input Method"
    uninstall_pkg "com.iflytek.inputmethod.miui"      "iFlytek Voice Input"
    uninstall_pkg "com.baidu.input_mi"                "Baidu Input Method"

    # Browser & search
    uninstall_pkg "com.miui.browser"                  "Mi Browser"

    # System cleaners
    uninstall_pkg "com.miui.cleanmaster"               "MIUI Clean Master / Phone Cleaner"

    # Gaming
    uninstall_pkg "com.xiaomi.gamecenter"              "Xiaomi Game Center"

    # Communication & misc
    uninstall_pkg "com.miui.antispam"                  "MIUI Anti-Spam Filter"
    uninstall_pkg "com.miui.newchannels"               "MIUI News Channels"
    uninstall_pkg "com.miui.translation"               "MIUI Translation Service"
    uninstall_pkg "com.mi.android.globaltranslation"   "Xiaomi Global Translation"
    uninstall_pkg "com.xiaomi.channel"                 "Xiaomi Channel (Promotions)"

    # AOD, utilities & media tools
    uninstall_pkg "com.mi.globalminusscreen"              "Mi Global Minus Screen"
    uninstall_pkg "com.mi.appfinder"                      "Mi App Finder"
    uninstall_pkg "com.miui.backup"                       "MIUI Backup"
    uninstall_pkg "com.miui.cleaner"                      "MIUI Phone Cleaner"
    uninstall_pkg "com.miui.phrase"                       "MIUI Auto Phrase / Quick Phrases"
    uninstall_pkg "com.xiaomi.glgm"                       "Xiaomi GLGM (Analytics)"
    uninstall_pkg "com.mi.globalbrowser"                  "Mi Browser (Global)"
    uninstall_pkg "com.xiaomi.mi_connect_service"         "Mi Connect Service"
    uninstall_pkg "com.xiaomi.discover"                   "Xiaomi Discover"
    uninstall_pkg "com.miuix.editor"                      "MIUI Photo/Video Editor"
    uninstall_pkg "com.xiaomi.mtb"                        "Xiaomi MTB (Message Top Boards)"
    uninstall_pkg "com.xiaomi.mirror"                     "Mi Mirror (Screen Cast)"
    uninstall_pkg "com.xiaomi.cameramind"                 "Xiaomi CameraMind (AI Camera)"
    uninstall_pkg "com.xiaomi.cameratools"                "Xiaomi Camera Tools"

    # Disable rather than remove (battery dependency)
    disable_pkg "com.miui.powerkeeper"               "MIUI Power Keeper (Battery Mgmt)"
    disable_pkg "com.miui.miservice"                 "MIUI Mi Service"
    disable_pkg "com.miui.micloudsync"               "MIUI Mi Cloud Sync"

    success "Xiaomi/Redmi system bloat removed."
}

# ── 10. OnePlus / OxygenOS Bloatware ─────────────────────────────────────────
debloat_oneplus() {
    section "OnePlus / OxygenOS Bloatware"
    echo -e "  ${DIM}Removes OnePlus-specific apps and services not needed on OxygenOS 13/14.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} OPlus-namespaced packages are already covered in ColorOS sections."
    confirm "Remove OnePlus/OxygenOS bloatware?" || { info "Skipped."; return; }

    # Account & store services
    uninstall_pkg "com.oneplus.account"              "OnePlus Account"
    uninstall_pkg "com.oneplus.appcenter"            "OnePlus App Center"
    uninstall_pkg "com.oneplus.store"                "OnePlus Store"
    uninstall_pkg "com.oneplus.community"            "OnePlus Community Forum"
    uninstall_pkg "net.oneplus.odm"                  "OnePlus ODM Service"

    # Diagnostics & logging
    uninstall_pkg "com.oneplus.logkit"               "OnePlus Log Kit (Diagnostics)"
    uninstall_pkg "com.oneplus.brickmode"            "OnePlus Brick Mode"
    uninstall_pkg "com.oneplus.region"               "OnePlus Region Service"

    # Pre-installed apps (replaceable)
    uninstall_pkg "com.oneplus.tips"                 "OnePlus Tips"
    uninstall_pkg "com.oneplus.clipboard"            "OnePlus Clipboard"

    # Wallet & health (skip if using)
    uninstall_pkg "com.oneplus.wallet"               "OnePlus Wallet"
    uninstall_pkg "com.oneplus.health"               "OnePlus Health"

    # Game Space (disables in-game FPS/network tools if removed)
    uninstall_pkg "com.oneplus.gamespace"            "OnePlus Game Space"

    # Widgets & push notifications
    uninstall_pkg "net.oneplus.widget"               "OnePlus Widgets"
    uninstall_pkg "com.oneplus.push"                 "OnePlus Push Service"

    # Amazon preload (some regional variants)
    uninstall_pkg "com.amazon.appstore"              "Amazon App Store (Preload)"

    # Focus mode
    uninstall_pkg "com.oneplus.zen"                  "OnePlus Zen Mode"

    success "OnePlus/OxygenOS bloatware removed."
}

# ── 13. AOSP / Android System Extras ─────────────────────────────────────────
debloat_android_extras() {
    section "AOSP / Android System Extras"
    echo -e "  ${DIM}Removes or disables rarely-needed AOSP system apps and background services.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Safe on all brands. Does NOT touch core telephony or Settings."
    confirm "Remove/disable AOSP system extras?" || { info "Skipped."; return; }

    # Safe to uninstall (no device-critical dependency)
    uninstall_pkg "com.android.devicediagnostics"        "Android Device Diagnostics"
    uninstall_pkg "com.android.traceur"                  "Android System Tracer (Developer)"
    uninstall_pkg "com.android.DeviceAsWebcam"           "Device as Webcam"
    uninstall_pkg "com.android.providers.partnerbookmarks" "Partner Bookmarks Provider"

    # Disable only (may be invoked by carrier flows)
    disable_pkg "com.android.calllogbackup"              "Call Log Backup Service"
    disable_pkg "com.android.carrierdefaultapp"          "Carrier Default App"

    success "AOSP system extras debloated."
}

# ── 14. Vendor Overlays & Runtime Resources (RROs) ────────────────────────────
debloat_vendor_overlays() {
    section "Vendor Overlays & Runtime Resources (RROs)"
    echo -e "  ${DIM}Disables MIUI/Xiaomi and carrier RRO overlay packages.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} All entries are DISABLED, not uninstalled, for safe recovery."
    echo -e "  ${RED}  WARN:${NC} Disabling SystemUI or Settings overlays on some ROMs may alter UI."
    confirm "Disable vendor overlay packages?" || { info "Skipped."; return; }

    disable_pkg "android.qvaoverlay.common"                      "QVA Common Overlay"
    disable_pkg "android.autoinstalls.config.Xiaomi.model"       "Xiaomi Auto-Install Config Overlay"
    disable_pkg "com.android.cellbroadcastreceiver.overlay.common" "Cell Broadcast Receiver Common Overlay"
    disable_pkg "com.android.inputsettings.overlay.miui"         "Input Settings MIUI Overlay"
    disable_pkg "com.android.managedprovisioning.overlay"        "Managed Provisioning Overlay"
    disable_pkg "com.android.phone.auto_generated_characteristics_rro" "Phone Characteristics RRO"
    disable_pkg "com.android.role.notes.enabled"                 "Notes Role Overlay"
    disable_pkg "com.android.settings.overlay.miui"              "Settings MIUI Overlay"
    disable_pkg "com.android.stk.overlay.miui"                   "STK MIUI Overlay"
    disable_pkg "com.android.systemui.overlay.miui"              "SystemUI MIUI Overlay"
    disable_pkg "com.miui.miwallpaper.overlay"                   "MIUI Wallpaper Overlay"
    disable_pkg "com.miui.miwallpaper.overlay.customize"         "MIUI Wallpaper Customize Overlay"
    disable_pkg "com.miui.phone.carriers.overlay.h3g"            "MIUI H3G Carrier Overlay"
    disable_pkg "com.miui.phone.carriers.overlay.vodafone"       "MIUI Vodafone Carrier Overlay"
    disable_pkg "com.miui.settings.rro.device.type.overlay"      "MIUI Settings Device-Type Overlay"
    disable_pkg "com.miui.wallpaper.overlay"                     "MIUI Wallpaper Generic Overlay"
    disable_pkg "com.miui.wallpaper.overlay.customize"           "MIUI Wallpaper Customize Overlay (Alt)"
    disable_pkg "com.mi.globallayout"                            "Mi Global Layout Overlay"
    disable_pkg "com.xiaomi.micloud.sdk"                         "Xiaomi Mi Cloud SDK"
    disable_pkg "com.oppo.gmail.overlay"                         "OPPO Gmail Overlay"
    disable_pkg "com.coloros.activation.overlay.common"          "ColorOS Activation Common Overlay"

    success "Vendor overlays disabled."
}

# ── 15. Qualcomm & Hardware Diagnostics ───────────────────────────────────────
debloat_qualcomm() {
    section "Qualcomm & Hardware Diagnostics"
    echo -e "  ${DIM}Removes OEM factory-test tools and disables Qualcomm background services.${NC}"
    echo -e "  ${YELLOW}  NOTE:${NC} Safe on Snapdragon devices. Not applicable to MediaTek/Exynos."
    confirm "Remove/disable Qualcomm & diagnostics packages?" || { info "Skipped."; return; }

    uninstall_pkg "com.qualcomm.qti.devicestatisticsservice" "Qualcomm Device Statistics Service"
    uninstall_pkg "com.miui.cit"                             "MIUI CIT Factory Test Tool"
    uninstall_pkg "com.goodix.gftest"                        "Goodix Fingerprint Test Tool"
    uninstall_pkg "com.fingerprints.sensortesttool"          "Fingerprint Sensor Test Tool"

    disable_pkg "com.qualcomm.qti.callfeaturessetting"       "Qualcomm Call Features Setting"
    disable_pkg "com.qti.qualcomm.deviceinfo"                "Qualcomm Device Info Service"
    disable_pkg "com.qualcomm.qti.xrcb"                      "Qualcomm XR Callback Service"
    disable_pkg "com.qualcomm.qti.xrvd.service"              "Qualcomm XR Virtual Display Service"

    success "Qualcomm & hardware diagnostics debloated."
}

# ── 16. Microsoft & Third-Party Preloads ──────────────────────────────────────
debloat_microsoft() {
    section "Microsoft & Third-Party Preloads"
    echo -e "  ${DIM}Removes Microsoft app-management and cross-device integration preloads.${NC}"
    confirm "Remove Microsoft & third-party preloads?" || { info "Skipped."; return; }

    uninstall_pkg "com.microsoft.appmanager"                  "Microsoft App Manager"
    uninstall_pkg "com.microsoftsdk.crossdeviceservicebroker" "Microsoft Cross-Device Service Broker"
    uninstall_pkg "com.microsoft.deviceintegrationservice"    "Microsoft Device Integration Service"

    success "Microsoft & third-party preloads removed."
}

# ── 17. Full debloat (all categories) ────────────────────────────────────────
debloat_all() {
    section "Full Debloat — All Categories"
    echo -e "  ${RED}${BOLD}This will run every debloat category sequentially.${NC}"
    echo -e "  ${YELLOW}  Recommended for a fresh setup. Confirm each category individually.${NC}"
    debloat_analytics
    debloat_coloros
    debloat_gaming
    debloat_payments
    debloat_social
    debloat_google
    debloat_miui_analytics
    debloat_miui_apps
    debloat_oneplus
    debloat_android_extras
    debloat_vendor_overlays
    debloat_qualcomm
    debloat_microsoft
}

# ── List installed packages ───────────────────────────────────────────────────
list_packages() {
    section "Installed Packages"
    echo -ne "  Filter by keyword (leave blank to list all): "
    read -r filter
    echo
    if [[ -n "$filter" ]]; then
        adb shell pm list packages 2>/dev/null | grep "$filter" | sed 's/^package://' | sort
    else
        adb shell pm list packages 2>/dev/null | sed 's/^package://' | sort
    fi
    echo
}

# ── Reinstall a previously removed package ────────────────────────────────────
reinstall_pkg() {
    section "Reinstall Package"
    echo -ne "  Enter package name to reinstall: "
    read -r pkg
    [[ -z "$pkg" ]] && { warn "No package name entered."; return; }
    info "Attempting reinstall of ${BOLD}${pkg}${NC}…"
    local out
    out=$(adb shell cmd package install-existing "$pkg" 2>&1)
    if echo "$out" | grep -q "installed\|Success"; then
        success "${pkg} reinstalled successfully."
    else
        error "Failed to reinstall ${pkg}. It may not exist in the device OTA image."
        echo -e "  ${DIM}${out}${NC}"
    fi
}

# ── Custom single-package removal ────────────────────────────────────────────
custom_uninstall() {
    section "Custom Package Removal"
    echo -ne "  Enter package name to uninstall: "
    read -r pkg
    [[ -z "$pkg" ]] && { warn "No package name entered."; return; }
    confirm "Uninstall ${BOLD}${pkg}${NC}?" || { info "Cancelled."; return; }
    uninstall_pkg "$pkg" "$pkg"
}

# ── Toggle dry-run mode ───────────────────────────────────────────────────────
toggle_dry_run() {
    if $DRY_RUN; then
        DRY_RUN=false
        success "Dry-run DISABLED. Changes will now be applied to the device."
    else
        DRY_RUN=true
        warn "Dry-run ENABLED. No changes will be made to the device."
    fi
}

# ── Toggle logging ────────────────────────────────────────────────────────────
toggle_logging() {
    if $LOG_ENABLED; then
        LOG_ENABLED=false
        info "Logging disabled."
    else
        LOG_ENABLED=true
        success "Logging enabled → ${BOLD}${LOG_FILE}${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session started" >> "$LOG_FILE"
    fi
}

# ── Session summary ───────────────────────────────────────────────────────────
print_summary() {
    section "Session Summary"
    echo -e "  ${BOLD}Packages removed this session :${NC} ${#REMOVED_PKGS[@]}"
    local p
    for p in "${REMOVED_PKGS[@]}"; do
        echo -e "    ${DIM}• ${p}${NC}"
    done
    echo -e "  ${BOLD}Packages disabled this session:${NC} ${#DISABLED_PKGS[@]}"
    for p in "${DISABLED_PKGS[@]}"; do
        echo -e "    ${DIM}• ${p}${NC}"
    done
    if $LOG_ENABLED; then
        echo -e "\n  ${DIM}Log saved to: ${LOG_FILE}${NC}"
    fi
    if [[ -n "$RESTORE_FILE" ]]; then
        echo -e "\n  ${GREEN}${BOLD}Restore list saved to: ${RESTORE_FILE}${NC}"
        echo -e "  ${DIM}Reinstall : adb shell cmd package install-existing <package_id>${NC}"
        echo -e "  ${DIM}Re-enable : adb shell pm enable --user 0 <package_id>${NC}"
    else
        echo -e "\n  ${GREEN}${BOLD}To restore any removed package:${NC}"
        echo -e "  ${DIM}adb shell cmd package install-existing <package.name>${NC}"
    fi
    echo
}

# ── Main menu ─────────────────────────────────────────────────────────────────
main_menu() {
    while true; do
        local dr_status log_status
        $DRY_RUN    && dr_status="${YELLOW}ON${NC} " || dr_status="${GREEN}OFF${NC}"
        $LOG_ENABLED && log_status="${GREEN}ON${NC} " || log_status="${DIM}OFF${NC}"

        echo -e "${BOLD}${BLUE}"
        echo "  ┌─────────────────────────────────────────────────────┐"
        echo "  │                     MAIN MENU                       │"
        echo "  ├─────────────────────────────────────────────────────┤"
        printf "  │  %-5s %-47s│\n" "[1]"  "List installed packages"
        printf "  │  %-5s %-47s│\n" "[2]"  "Debloat: Analytics & Telemetry (ColorOS)"
        printf "  │  %-5s %-47s│\n" "[3]"  "Debloat: ColorOS / OPPO bloatware"
        printf "  │  %-5s %-47s│\n" "[4]"  "Debloat: Game Space & Gaming services"
        printf "  │  %-5s %-47s│\n" "[5]"  "Debloat: Payment & Financial apps"
        printf "  │  %-5s %-47s│\n" "[6]"  "Debloat: Facebook & Social preloads"
        printf "  │  %-5s %-47s│\n" "[7]"  "Debloat: Google bloatware"
        printf "  │  %-5s %-47s│\n" "[8]"  "Debloat: ALL categories (full clean)"
        printf "  │  %-5s %-47s│\n" "[9]"  "Custom uninstall"
        printf "  │  %-5s %-47s│\n" "[10]" "Debloat: Xiaomi/Redmi Analytics & Ads"
        printf "  │  %-5s %-47s│\n" "[11]" "Debloat: Xiaomi/Redmi System Apps"
        printf "  │  %-5s %-47s│\n" "[12]" "Debloat: OnePlus / OxygenOS bloatware"
        printf "  │  %-5s %-47s│\n" "[13]" "Debloat: AOSP / Android System Extras"
        printf "  │  %-5s %-47s│\n" "[14]" "Debloat: Vendor Overlays & RROs"
        printf "  │  %-5s %-47s│\n" "[15]" "Debloat: Qualcomm & HW Diagnostics"
        printf "  │  %-5s %-47s│\n" "[16]" "Debloat: Microsoft & 3rd-Party Preloads"
        printf "  │  %-5s %-47s│\n" "[r]"  "Reinstall / restore a package"
        echo "  │                                                     │"
        echo -ne "  │  [d]  Dry-run mode  : "; echo -e "${dr_status}${BOLD}${BLUE}                              │"
        echo -ne "  │  [l]  Logging       : "; echo -e "${log_status}${BOLD}${BLUE}                              │"
        echo "  │                                                     │"
        printf "  │  %-5s %-47s│\n" "[s]" "Show session summary"
        printf "  │  %-5s %-47s│\n" "[0]" "Exit"
        echo "  └─────────────────────────────────────────────────────┘"
        echo -e "${NC}"

        echo -ne "  Enter option: "
        read -r option

        case "$option" in
            1) list_packages ;;
            2) debloat_analytics ;;
            3) debloat_coloros ;;
            4) debloat_gaming ;;
            5) debloat_payments ;;
            6) debloat_social ;;
            7) debloat_google ;;
            8) debloat_all ;;
            9) custom_uninstall ;;
            10) debloat_miui_analytics ;;
            11) debloat_miui_apps ;;
            12) debloat_oneplus ;;
            13) debloat_android_extras ;;
            14) debloat_vendor_overlays ;;
            15) debloat_qualcomm ;;
            16) debloat_microsoft ;;
            r|R) reinstall_pkg ;;
            d|D) toggle_dry_run ;;
            l|L) toggle_logging ;;
            s|S) print_summary ;;
            0|q|Q)
                echo
                print_summary
                info "Exiting. Enjoy your optimised device!"
                exit 0
                ;;
            *) warn "Invalid option '${option}'. Please try again." ;;
        esac
    done
}

# ── Entry point ───────────────────────────────────────────────────────────────
main() {
    clear
    print_banner
    check_adb
    check_device
    print_device_info
    main_menu
}

main
