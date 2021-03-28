#include "device_info.h"
#include <QBluetoothAddress>



device_Info::device_Info(const QBluetoothDeviceInfo &info):_BLE_Device(info) {
}



QBluetoothDeviceInfo device_Info::get_Device() const {
    return _BLE_Device;
}



QString device_Info::get_Device_Name() const {
    return _BLE_Device.name();
}



QString device_Info::get_Device_Address() const {
    return _BLE_Device.address().toString();
}



void device_Info::set_Device(const QBluetoothDeviceInfo &device) {
    _BLE_Device = device;
    emit device_Changed();
}
