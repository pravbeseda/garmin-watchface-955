import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class XLWatchFace955View extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;

        if (Application.Properties.getValue("UseMilitaryFormat")) {
                timeFormat = "$1$:$2$";
                hours = hours.format("%02d");
        } else {
            if (!System.getDeviceSettings().is24Hour) {
                if (hours > 12) {
                    hours = hours - 12;
                }
            }
        }

        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Time
        var time = View.findDrawableById("TimeLabel") as Text;
        time.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        time.setText(timeString);
        time.setFont(Graphics.FONT_NUMBER_MEDIUM);

        // Battery
        var batteryPercent = System.getSystemStats().battery;
        var batteryInDays = System.getSystemStats().batteryInDays;
        var battery = View.findDrawableById("BatteryLabel") as Text;
        if (batteryPercent < 20) {
            battery.setColor(0xFF0000);
        } else {
            battery.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        }
        battery.setText(batteryPercent.format("%d") + "% (" + batteryInDays.format("%d") + "d)");

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$, $2$ $3$",
            [
                today.day_of_week,
                today.day,
                today.month,
            ]
        );
        var dayLabel = View.findDrawableById("DayLabel") as Text;
        dayLabel.setText(dateString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
