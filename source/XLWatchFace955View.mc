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
    var weatherDayClearIcon;
    var weatherNightClearIcon;
    var weatherCloudyIcon;
    var weatherOvercastIcon;
    var weatherRainIcon;
    var weatherRainThunderIcon;
    var weatherSnowIcon;
    var weatherSnowThunderIcon;
    var weatherSleetIcon;
    var weatherFogIcon;
    var weatherMistIcon;
    var weatherThunderIcon;
    var weatherTornadoIcon;
    var weatherWindIcon;
    var weatherDayPartialCloudIcon;
    var weatherNightPartialCloudIcon;
    var weatherDayRainIcon;
    var weatherNightRainIcon;
    var weatherDaySnowIcon;
    var weatherNightSnowIcon;
    var weatherDaySleetIcon;
    var weatherNightSleetIcon;
    var weatherDayRainThunderIcon;
    var weatherNightRainThunderIcon;
    var weatherDaySnowThunderIcon;
    var weatherNightSnowThunderIcon;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        imageFootsteps = Application.loadResource( Rez.Drawables.footsteps ) as BitmapResource;
        batteryIcon = Application.loadResource( Rez.Drawables.battery ) as BitmapResource;
        personIcon = Application.loadResource( Rez.Drawables.person ) as BitmapResource;
        weatherDayClearIcon = Application.loadResource(Rez.Drawables.weather_day_clear) as BitmapResource;
        weatherNightClearIcon = Application.loadResource(Rez.Drawables.weather_night_clear) as BitmapResource;
        weatherCloudyIcon = Application.loadResource(Rez.Drawables.weather_cloudy) as BitmapResource;
        weatherOvercastIcon = Application.loadResource(Rez.Drawables.weather_overcast) as BitmapResource;
        weatherRainIcon = Application.loadResource(Rez.Drawables.weather_rain) as BitmapResource;
        weatherRainThunderIcon = Application.loadResource(Rez.Drawables.weather_rain_thunder) as BitmapResource;
        weatherSnowIcon = Application.loadResource(Rez.Drawables.weather_snow) as BitmapResource;
        weatherSnowThunderIcon = Application.loadResource(Rez.Drawables.weather_snow_thunder) as BitmapResource;
        weatherSleetIcon = Application.loadResource(Rez.Drawables.weather_sleet) as BitmapResource;
        weatherFogIcon = Application.loadResource(Rez.Drawables.weather_fog) as BitmapResource;
        weatherMistIcon = Application.loadResource(Rez.Drawables.weather_mist) as BitmapResource;
        weatherThunderIcon = Application.loadResource(Rez.Drawables.weather_thunder) as BitmapResource;
        weatherTornadoIcon = Application.loadResource(Rez.Drawables.weather_tornado) as BitmapResource;
        weatherWindIcon = Application.loadResource(Rez.Drawables.weather_wind) as BitmapResource;
        weatherDayPartialCloudIcon = Application.loadResource(Rez.Drawables.weather_day_partial_cloud) as BitmapResource;
        weatherNightPartialCloudIcon = Application.loadResource(Rez.Drawables.weather_night_partial_cloud) as BitmapResource;
        weatherDayRainIcon = Application.loadResource(Rez.Drawables.weather_day_rain) as BitmapResource;
        weatherNightRainIcon = Application.loadResource(Rez.Drawables.weather_night_rain) as BitmapResource;
        weatherDaySnowIcon = Application.loadResource(Rez.Drawables.weather_day_snow) as BitmapResource;
        weatherNightSnowIcon = Application.loadResource(Rez.Drawables.weather_night_snow) as BitmapResource;
        weatherDaySleetIcon = Application.loadResource(Rez.Drawables.weather_day_sleet) as BitmapResource;
        weatherNightSleetIcon = Application.loadResource(Rez.Drawables.weather_night_sleet) as BitmapResource;
        weatherDayRainThunderIcon = Application.loadResource(Rez.Drawables.weather_day_rain_thunder) as BitmapResource;
        weatherNightRainThunderIcon = Application.loadResource(Rez.Drawables.weather_night_rain_thunder) as BitmapResource;
        weatherDaySnowThunderIcon = Application.loadResource(Rez.Drawables.weather_day_snow_thunder) as BitmapResource;
        weatherNightSnowThunderIcon = Application.loadResource(Rez.Drawables.weather_night_snow_thunder) as BitmapResource;
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
        var weatherIcon = weatherDayClearIcon; // по умолчанию
        if (currentWeather != null) {
            var weatherLabel = View.findDrawableById("WeatherLabel") as Text;
            weatherLabel.setText(currentWeather.temperature.format("%d") + "°C");
            var cond = currentWeather.condition;
            if (cond == Weather.CONDITION_CLEAR || cond == Weather.CONDITION_FAIR || cond == Weather.CONDITION_MOSTLY_CLEAR || cond == Weather.CONDITION_PARTLY_CLEAR) {
                weatherIcon = weatherDayClearIcon;
            } else if (cond == Weather.CONDITION_PARTLY_CLOUDY || cond == Weather.CONDITION_MOSTLY_CLOUDY || cond == Weather.CONDITION_THIN_CLOUDS) {
                weatherIcon = weatherDayPartialCloudIcon;
            } else if (cond == Weather.CONDITION_CLOUDY || cond == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN || cond == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW || cond == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW) {
                weatherIcon = weatherCloudyIcon;
            } else if (cond == Weather.CONDITION_RAIN || cond == Weather.CONDITION_SHOWERS || cond == Weather.CONDITION_SCATTERED_SHOWERS || cond == Weather.CONDITION_LIGHT_RAIN || cond == Weather.CONDITION_HEAVY_RAIN || cond == Weather.CONDITION_LIGHT_SHOWERS || cond == Weather.CONDITION_HEAVY_SHOWERS || cond == Weather.CONDITION_CHANCE_OF_SHOWERS || cond == Weather.CONDITION_DRIZZLE) {
                weatherIcon = weatherRainIcon;
            } else if (cond == Weather.CONDITION_RAIN_SNOW || cond == Weather.CONDITION_LIGHT_RAIN_SNOW || cond == Weather.CONDITION_HEAVY_RAIN_SNOW || cond == Weather.CONDITION_CHANCE_OF_RAIN_SNOW) {
                weatherIcon = weatherSleetIcon;
            } else if (cond == Weather.CONDITION_SNOW || cond == Weather.CONDITION_LIGHT_SNOW || cond == Weather.CONDITION_HEAVY_SNOW || cond == Weather.CONDITION_CHANCE_OF_SNOW || cond == Weather.CONDITION_FLURRIES) {
                weatherIcon = weatherSnowIcon;
            } else if (cond == Weather.CONDITION_WINTRY_MIX || cond == Weather.CONDITION_FREEZING_RAIN || cond == Weather.CONDITION_ICE || cond == Weather.CONDITION_ICE_SNOW) {
                weatherIcon = weatherSleetIcon;
            } else if (cond == Weather.CONDITION_FOG || cond == Weather.CONDITION_MIST || cond == Weather.CONDITION_HAZE || cond == Weather.CONDITION_HAZY || cond == Weather.CONDITION_DUST || cond == Weather.CONDITION_SMOKE || cond == Weather.CONDITION_VOLCANIC_ASH) {
                weatherIcon = weatherFogIcon;
            } else if (cond == Weather.CONDITION_THUNDERSTORMS || cond == Weather.CONDITION_SCATTERED_THUNDERSTORMS || cond == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS || cond == Weather.CONDITION_SQUALL) {
                weatherIcon = weatherRainThunderIcon;
            } else if (cond == Weather.CONDITION_TORNADO || cond == Weather.CONDITION_HURRICANE || cond == Weather.CONDITION_TROPICAL_STORM) {
                weatherIcon = weatherTornadoIcon;
            } else if (cond == Weather.CONDITION_WINDY) {
                weatherIcon = weatherWindIcon;
            } else if (cond == Weather.CONDITION_HAIL) {
                weatherIcon = weatherSnowThunderIcon;
            } else if (cond == Weather.CONDITION_SAND || cond == Weather.CONDITION_SANDSTORM) {
                weatherIcon = weatherWindIcon;
            } else if (cond == Weather.CONDITION_UNKNOWN || cond == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
                weatherIcon = weatherOvercastIcon;
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

        dc.drawBitmap(180, 60, weatherIcon );
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
