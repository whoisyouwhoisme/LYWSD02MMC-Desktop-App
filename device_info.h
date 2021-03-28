#ifndef DEVICE_INFO_H
#define DEVICE_INFO_H

#include <QObject>
#include <QBluetoothDeviceInfo>

class device_Info : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString device_Name READ get_Device_Name NOTIFY device_Changed)
    Q_PROPERTY(QString device_Address READ get_Device_Address NOTIFY device_Changed)

public:
    device_Info(const QBluetoothDeviceInfo &device);

    void set_Device(const QBluetoothDeviceInfo &device);
    QString get_Device_Name() const;
    QString get_Device_Address() const;
    QBluetoothDeviceInfo get_Device() const;

signals:
    void device_Changed();

private:
    QBluetoothDeviceInfo _BLE_Device;

};

#endif // DEVICE_INFO_H
