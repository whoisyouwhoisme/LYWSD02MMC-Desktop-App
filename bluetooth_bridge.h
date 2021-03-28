#ifndef BLUETOOTH_BRIDGE_H
#define BLUETOOTH_BRIDGE_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothLocalDevice>
#include <QLowEnergyController>
#include <QTimer>

#include "device_info.h"
#include "clock_info.h"

class device_Info;

class bluetooth_Bridge : public QObject {
    Q_OBJECT

public:
    bluetooth_Bridge(clock_Info *clockInfo, QObject *parent = nullptr);

    Q_INVOKABLE void scan_Devices();
    Q_INVOKABLE void stop_Scan();
    Q_INVOKABLE void disconnect_Device();
    Q_INVOKABLE void connect_To_Device(QString device_Mac);
    Q_INVOKABLE void change_Temperature_Unit(QString unit);
    Q_INVOKABLE void set_New_Time(unsigned long new_TimeStamp, char new_TimeZone);

    void clear_Devices();
    void connect_Device(device_Info *device);

private slots:
    void S_add_Device(const QBluetoothDeviceInfo&);
    void S_device_Scan_Finished();
    void S_device_Scan_Error(QBluetoothDeviceDiscoveryAgent::Error);

    void S_device_Connected();
    void S_device_Disconnected();
    void S_service_Discovered(const QBluetoothUuid &gatt);
    void S_service_Scan_Done();
    void S_BLE_Controller_Error(QLowEnergyController::Error);

    void S_service_State_Changed(QLowEnergyService::ServiceState state);
    void S_service_Characteristic_Changed(const QLowEnergyCharacteristic &characteristic, const QByteArray &value);
    void S_service_Characteristic_Read(const QLowEnergyCharacteristic &characteristic, const QByteArray &value);
    void S_service_Characteristic_Written(const QLowEnergyCharacteristic &characteristic, const QByteArray &value);
    void S_service_Error(QLowEnergyService::ServiceError error);

    void S_read_Data();
    void S_Connection_Timeout();

signals:
    void new_Device_Found(QString device_Name, QString device_Mac);
    void clear_Devices_List();
    void connected_To_Device(QString device_Name);
    void device_Disconnected();
    void search_Started();
    void writing_Service();
    void writing_Service_Completed();
    void connection_Completed();
    void search_Status_Changed(QString new_Status);
    void connecting_Status_Changed(QString new_status);
    void connection_Error(QString reason);
    void search_Completed();

private:
    void ble_Critical_Error(QString error);

    bool _display_Service_Found;
    bool _scan_In_Progress = false;
    bool _device_Connected = false;

    QList<QObject*> _BLE_Devices;
    QList<QBluetoothUuid> _BLE_Services_UUID;

    device_Info *_current_Device = nullptr;
    clock_Info *_clock_Service;

    QTimer *_update_Timer;
    QTimer *_timeout_Timer;

    QLowEnergyDescriptor _climate_Descriptor;

    QLowEnergyCharacteristic _climate_Data;
    QLowEnergyCharacteristic _temperature_Unit;
    QLowEnergyCharacteristic _battery_Level;
    QLowEnergyCharacteristic _timestamp;

    QBluetoothDeviceDiscoveryAgent *_device_Discovery_Agent;
    QLowEnergyController *_BLE_Controller = nullptr;
    QLowEnergyService *_BLE_Service = nullptr;

};

#endif // BLUETOOTH_BRIDGE_H
