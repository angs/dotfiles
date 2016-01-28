{-# LANGUAGE FlexibleContexts #-}

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.LayoutModifier
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import System.IO 
import System.Exit

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myconf

startup :: X ()
startup = screenWorkspace 1 >>= flip whenJust (windows . W.view) >> (windows $ W.greedyView "9") >> screenWorkspace 0 >>= flip whenJust (windows . W.view) 

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppTitle = xmobarColor "green" "" . shorten 120 } 

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myconf = defaultConfig
	{ borderWidth         = 2
	, terminal            = "gnome-terminal"
	, normalBorderColor   = "#ffffff"
	, focusedBorderColor  = "#ff0000"
	, logHook = dynamicLog
	, workspaces = myWorkspaces
	, startupHook = startup
	, handleEventHook = fullscreenEventHook
	, keys = myKeys
	, modMask = mod1Mask
	, manageHook = composeAll 
		[ className =? "XBoard" --> doFloat 
		, stringProperty "WM_WINDOW_ROLE" =? "irssi" --> doShift "9"
		, stringProperty "WM_WINDOW_ROLE" =? "alsamixer" --> doShift "9"
		, stringProperty "WM_WINDOW_ROLE" =? "musiikki" --> doShift "9"
		, className =? "XClock" --> doShift "9"
		, className =? "Evolution" --> doShift "8"
		, className =? "Thunderbird" --> doShift "8"
		, className =? "Gimp" --> doFloat
--			, className =? "MPlayer" --> doFloat
		] <+> manageDocks
	, layoutHook = lessBorders OnlyFloat $
		onWorkspace "9" lo9 $
		lo
	}
	
lo = avoidStruts tiled ||| avoidStruts (Mirror tiled) ||| noBorders Full
	where tiled = Tall 1 0.03 0.68
lo9 = avoidStruts tiled ||| avoidStruts (Mirror tiled) ||| noBorders Full
	where tiled = Tall 2 0.03 0.6

myWorkspaces :: [WorkspaceId]
myWorkspaces = map show [1..9 :: Int]

-- Custom keys for of dvorak layout
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
		[ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
		, ((modMask,               xK_colon), spawn $ XMonad.terminal conf)
		, ((modMask,               xK_p     ), spawn "dmenu_run") -- %! Launch dmenu
		, ((modMask .|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun
		, ((modMask .|. shiftMask, xK_q     ), kill) -- %! Close the focused window
		, ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
		, ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts
		, ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size
		, ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
		, ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
		, ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
		, ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
		, ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window
		, ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
		, ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
		, ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window
		, ((modMask,               xK_grave ), windows W.swapDown  ) -- %! Swap the focused window with the next window
		, ((modMask .|. shiftMask, xK_grave ), windows W.swapUp    ) -- %! Swap the focused window with the previous window
		, ((modMask,               xK_minus ), sendMessage Shrink) -- %! Shrink the master area
		, ((modMask,               xK_equal ), sendMessage Expand) -- %! Expand the master area
		, ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling
		, ((modMask .|. shiftMask, xK_equal ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
		, ((modMask .|. shiftMask, xK_minus ), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area
		, ((modMask .|. shiftMask, xK_BackSpace ), io (exitWith ExitSuccess)) -- %! Quit xmonad
    , ((modMask .|. shiftMask, xK_F7    ), spawn "autoclick")
		, ((modMask              , xK_BackSpace ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
		, ((modMask,               xK_F11   ), 
			spawn "xrandr --output VGA-0 --pos 1080x600 --rotate normal --output DVI-D-0 --auto --pos 0x0 --rotate left")
		, ((modMask,               xK_F12   ), 
			spawn "xrandr --output VGA-0 --right-of DVI-D-0 --rotate normal --output DVI-D-0 --auto --pos 0x0 --rotate normal")
		, ((modMask,               xK_KP_Add), spawn "amixer -M -c 0 set Master 3%+")
		, ((modMask,               xK_KP_Subtract), spawn "amixer -M -c 0 set Master 3%-")
		]
		++
		-- mod-[1..9] %! Switch to workspace N
		-- mod-shift-[1..9] %! Move client to workspace N
		[((m .|. modMask, k), windows $ f i)
			| (i, k) <- zip myWorkspaces [xK_exclam, xK_at, xK_numbersign, xK_dollar, xK_percent, xK_ampersand, xK_asciicircum, xK_asterisk, xK_parenleft, xK_parenright]
			, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
		++
		[((m .|. modMask, k), windows $ f i)
		    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
		    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
		++
		-- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
		-- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
		[((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
		    | (key, sc) <- zip [xK_comma, xK_period, xK_apostrophe] [0..]
		    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
