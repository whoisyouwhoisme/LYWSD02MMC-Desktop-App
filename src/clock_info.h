#ifndef CLOCK_INFO_H
#define CLOCK_INFO_H

#include <QObject>
#include <QDateTime>
#include <QDebug>

class clock_Info : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float get_Temperature READ get_Temperature NOTIFY climate_Changed)
    Q_PROPERTY(unsigned short get_Humidity READ get_Humidity NOTIFY climate_Changed)
    Q_PROPERTY(QString get_Time READ get_Time NOTIFY time_Changed)
    Q_PROPERTY(unsigned short get_Battery_Level READ get_Battery_Level NOTIFY battery_Level_Changed)
    Q_PROPERTY(QString get_Temperature_Unit READ get_Temperature_Unit NOTIFY temperature_Unit_Changed)

public:
    explicit clock_Info(QObject *parent = nullptr);

    float get_Temperature();
    unsigned short get_Humidity();
    QString get_Time();
    unsigned short get_Battery_Level();
    QString get_Temperature_Unit();

    void process_Climate_Data(const QByteArray &data);
    void process_Battery_Data(const QByteArray &data);
    void process_Temperature_Unit(const QByteArray &data);
    void process_Time_Data(const QByteArray &data);

signals:
    void climate_Changed();
    void time_Changed();
    void battery_Level_Changed();
    void temperature_Unit_Changed(QString unit);

private:
    float _temperature_Celsius = 0;
    float _temperature_Fahrenheit = 0;
    unsigned short _humidity = 0;
    unsigned long _timestamp = 0;
    unsigned short _timestamp_Timezone = 0;
    QString _current_Time = "00:00";
    unsigned short _battery_Level = 0;
    QString _temperature_Unit = "celsius";

};

#endif // CLOCK_INFO_H
