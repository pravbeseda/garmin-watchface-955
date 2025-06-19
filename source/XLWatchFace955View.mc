import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Weather;
using Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;

class XLWatchFace955View extends WatchUi.WatchFace {
    var imageFootsteps;
    var batteryIcon;
    var personIcon;
    var weather2SunIcon;
    var weather2PartlySunnyIcon;
    var weather2CloudIcon;
    var weather2RainIcon;
    var weather2SnowIcon;
    var weather2StormIcon;
    var weather2HazeIcon;
    var weather2HailIcon;
    var weather2TornadoIcon;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        imageFootsteps = Application.loadResource( Rez.Drawables.footsteps ) as BitmapResource;
        batteryIcon = Application.loadResource( Rez.Drawables.battery ) as BitmapResource;
        personIcon = Application.loadResource( Rez.Drawables.person ) as BitmapResource;
        weather2SunIcon = Application.loadResource(Rez.Drawables.weather2_sun) as BitmapResource;
        weather2PartlySunnyIcon = Application.loadResource(Rez.Drawables.weather2_partly_sunny) as BitmapResource;
        weather2CloudIcon = Application.loadResource(Rez.Drawables.weather2_cloud) as BitmapResource;
        weather2RainIcon = Application.loadResource(Rez.Drawables.weather2_rain) as BitmapResource;
        weather2SnowIcon = Application.loadResource(Rez.Drawables.weather2_snow) as BitmapResource;
        weather2StormIcon = Application.loadResource(Rez.Drawables.weather2_storm) as BitmapResource;
        weather2HazeIcon = Application.loadResource(Rez.Drawables.weather2_haze) as BitmapResource;
        weather2HailIcon = Application.loadResource(Rez.Drawables.weather2_hail) as BitmapResource;
        weather2TornadoIcon = Application.loadResource(Rez.Drawables.weather2_tornado) as BitmapResource;
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
        var batteryDays = View.findDrawableById("BatteryDays") as Text;
        if (batteryPercent < 20) {
            battery.setColor(0xFF0000);
        } else {
            battery.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        }
        battery.setText(batteryPercent.format("%d") + "%");
        batteryDays.setText(batteryInDays.format("%d") + "d");

        // Date
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

        var activity = ActivityMonitor.getInfo();
        var stepsLabel = View.findDrawableById("StepsLabel") as Text;
        var stepsString = Lang.format("$1$",
            [
                activity.steps
            ]
        );
        stepsLabel.setText(stepsString);
        var distanceLabel = View.findDrawableById("DistanceLabel") as Text;
        distanceLabel.setText((activity.distance / 100000.0).format("%.2f") + " km");

        var stressScore = activity.stressScore;
        var stressLabel = View.findDrawableById("StressLabel") as Text;
        
        if (stressScore != null) {
            stressLabel.setText(stressScore + " s");
        }

        var bodyBattery = getBodyBattery();
        var bodyBatteryLabel = View.findDrawableById("BodyBatteryLabel") as Text;
        if (bodyBattery != "-") {
            bodyBatteryLabel.setText(bodyBattery);
        }

        // Weather
        var currentWeather = Weather.getCurrentConditions();
        var weatherIcon = weather2SunIcon;
        if (currentWeather != null) {
            var weatherLabel = View.findDrawableById("WeatherLabel") as Text;
            weatherLabel.setText(currentWeather.temperature.format("%d") + "°C");
            var humidityLabel = View.findDrawableById("HumidityLabel") as Text;
            if (currentWeather.relativeHumidity != null) {
                humidityLabel.setText(currentWeather.relativeHumidity.format("%d") + "%");
            } else {
                humidityLabel.setText("");
            }
            var cond = currentWeather.condition;
            if (cond == Weather.CONDITION_CLEAR || cond == Weather.CONDITION_FAIR || cond == Weather.CONDITION_MOSTLY_CLEAR || cond == Weather.CONDITION_PARTLY_CLEAR) {
                weatherIcon = weather2SunIcon;
            } else if (cond == Weather.CONDITION_PARTLY_CLOUDY || cond == Weather.CONDITION_MOSTLY_CLOUDY) {
                weatherIcon = weather2PartlySunnyIcon;
            } else if (cond == Weather.CONDITION_CLOUDY) {
                weatherIcon = weather2CloudIcon;
            } else if (cond == Weather.CONDITION_RAIN || cond == Weather.CONDITION_SCATTERED_SHOWERS || cond == Weather.CONDITION_LIGHT_RAIN || cond == Weather.CONDITION_HEAVY_RAIN || cond == Weather.CONDITION_LIGHT_SHOWERS || cond == Weather.CONDITION_SHOWERS || cond == Weather.CONDITION_HEAVY_SHOWERS || cond == Weather.CONDITION_CHANCE_OF_SHOWERS || cond == Weather.CONDITION_DRIZZLE || cond == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
                weatherIcon = weather2RainIcon;
            } else if (cond == Weather.CONDITION_SNOW || cond == Weather.CONDITION_LIGHT_SNOW || cond == Weather.CONDITION_HEAVY_SNOW) {
                weatherIcon = weather2SnowIcon;
            } else if (cond == Weather.CONDITION_THUNDERSTORMS || cond == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
                weatherIcon = weather2StormIcon;
            } else if (cond == Weather.CONDITION_WINTRY_MIX || cond == Weather.CONDITION_RAIN_SNOW || cond == Weather.CONDITION_LIGHT_RAIN_SNOW || cond == Weather.CONDITION_HEAVY_RAIN_SNOW) {
                weatherIcon = weather2SnowIcon;
            } else if (cond == Weather.CONDITION_FOG || cond == Weather.CONDITION_MIST || cond == Weather.CONDITION_HAZY || cond == Weather.CONDITION_HAZE) {
                weatherIcon = weather2HazeIcon;
            } else if (cond == Weather.CONDITION_HAIL) {
                weatherIcon = weather2HailIcon;
            } else if (cond == Weather.CONDITION_TORNADO) {
                weatherIcon = weather2TornadoIcon;
            } else if (cond == Weather.CONDITION_WINDY) {
                // Нет иконки для WINDY, ничего не делаем
            }
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawLine(0, 50, 280, 50);
        dc.drawLine(150, 50, 150, 164);
        dc.drawLine(0, 164, 280, 164);
        dc.drawLine(0, 210, 280, 210);

        dc.drawBitmap(125, 220, batteryIcon );
        dc.drawBitmap(110, 175, imageFootsteps );
        dc.drawBitmap(120, 17, personIcon );

        dc.drawBitmap(170, 48, weatherIcon );
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

    function getBodyBattery() as String {
        var bodybattery = null;
        if (
            Toybox has :SensorHistory &&
            Toybox.SensorHistory has :getBodyBatteryHistory
        ) {
            bodybattery = Toybox.SensorHistory.getBodyBatteryHistory({ :period => 1 });
        } else {
            return "-";
        }
        if (bodybattery != null) {
            bodybattery = bodybattery.next();
        }
        if (bodybattery != null) {
            bodybattery = bodybattery.data;
        }

        if (bodybattery != null && bodybattery >= 0 && bodybattery <= 100) {
            return bodybattery.format("%d") + "%";
        } else {
            return "-";
        }
    }

}
