#include "clock_info.h"

clock_Info::clock_Info(QObject *parent) : QObject(parent) {

}



void clock_Info::process_Climate_Data(const QByteArray &data) {
    QByteArray temperature;
    temperature.append(data.at(1));
    temperature.append(data.at(0));

    _temperature_Celsius = temperature.toHex().toInt(nullptr, 16) / 100.0;
    _temperature_Fahrenheit = _temperature_Celsius * 9.0 / 5.0 + 32.0;

    QByteArray humidity = data.mid(2, 1);
    _humidity = humidity.toHex().toInt(nullptr, 16);

    emit climate_Changed();
}



void clock_Info::process_Battery_Data(const QByteArray &data) {
    _battery_Level = data.toHex().toInt(nullptr, 16);

    emit battery_Level_Changed();
}


void clock_Info::process_Temperature_Unit(const QByteArray &data) {
    if (data.toHex() == "01") {
        _temperature_Unit = "fahrenheit";
    }
    else if (data.toHex() == "ff") {
        _temperature_Unit = "celsius";
    }

    emit temperature_Unit_Changed(_temperature_Unit);
    emit climate_Changed();
}



void clock_Info::process_Time_Data(const QByteArray &data) {
    QByteArray timestamp_Data;
    QDateTime timestamp;

    for (int i = data.size() - 1; i >= 0; i--) {
        timestamp_Data.append(data.at(i));
    }

    QByteArray timestamp_Slice = timestamp_Data.mid(1, 4);
    _timestamp = timestamp_Slice.toHex().toULong(nullptr, 16);

    QByteArray timestamp_Timezone = timestamp_Data.mid(0, 1);
    _timestamp_Timezone = timestamp_Timezone.toHex().toUShort(nullptr, 16);

    if (_timestamp_Timezone < 128) {
        _timestamp = _timestamp + _timestamp_Timezone * 3600;
    }
    else {
        _timestamp = _timestamp + (_timestamp_Timezone - 256) * 3600;
    }

    timestamp.setSecsSinceEpoch(_timestamp);
    QDateTime UTC(timestamp.toUTC());
    _current_Time = UTC.toString("hh:mm");

    emit time_Changed();
}



float clock_Info::get_Temperature() {
    if (_temperature_Unit == "fahrenheit") {
        return _temperature_Fahrenheit;
    }
    else {
        return _temperature_Celsius;
    }
}



unsigned short clock_Info::get_Humidity() {
    return _humidity;
}



QString clock_Info::get_Time() {
    return _current_Time;
}



unsigned short clock_Info::get_Battery_Level() {
    return _battery_Level;
}



QString clock_Info::get_Temperature_Unit() {
    return _temperature_Unit;
}
