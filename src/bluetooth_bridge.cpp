#include "bluetooth_bridge.h"

bluetooth_Bridge::bluetooth_Bridge(clock_Info *clockInfo, QObject *parent) : QObject(parent), _clock_Service(clockInfo) {
    _update_Timer = new QTimer();
    _timeout_Timer = new QTimer();

    _update_Timer->setInterval(30000);
    _timeout_Timer->setInterval(10000);

    connect(_update_Timer, SIGNAL(timeout()), this, SLOT(S_read_Data()));
    connect(_timeout_Timer, SIGNAL(timeout()), this, SLOT(S_Connection_Timeout()));
}



void bluetooth_Bridge::ble_Critical_Error(QString error) {
    disconnect_Device();
    emit connection_Error(error);
}



void bluetooth_Bridge::clear_Devices() {
    if (_current_Device) {
        _BLE_Controller->disconnectFromDevice();
    }
    qDeleteAll(_BLE_Devices);
    _BLE_Devices.clear();

    emit clear_Devices_List();
}



void bluetooth_Bridge::scan_Devices() {
    clear_Devices();

    QBluetoothLocalDevice *local_Device = new QBluetoothLocalDevice;

    if (local_Device->isValid()) {
        local_Device->powerOn();
        local_Device->setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    }
    else {
        ble_Critical_Error("Bluetooth IS NOT Available.");
    }

    _device_Discovery_Agent = new QBluetoothDeviceDiscoveryAgent();
    _device_Discovery_Agent->setLowEnergyDiscoveryTimeout(30000);

    connect(_device_Discovery_Agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &bluetooth_Bridge::S_add_Device);
    //connect(_device_Discovery_Agent, QOverload<QBluetoothDeviceDiscoveryAgent::Error>::of(&QBluetoothDeviceDiscoveryAgent::error), this, &bluetooth_Bridge::S_device_Scan_Error);
    connect(_device_Discovery_Agent, &QBluetoothDeviceDiscoveryAgent::finished, this, &bluetooth_Bridge::S_device_Scan_Finished);
    connect(_device_Discovery_Agent, &QBluetoothDeviceDiscoveryAgent::canceled, this, &bluetooth_Bridge::S_device_Scan_Finished);

    emit search_Status_Changed("Start scanning...");

    _device_Discovery_Agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    _scan_In_Progress = true;
    emit search_Started();
}



void bluetooth_Bridge::stop_Scan() {
    if (_scan_In_Progress) {
        _scan_In_Progress = false;
        _device_Discovery_Agent->stop();
    }
}



void bluetooth_Bridge::S_add_Device(const QBluetoothDeviceInfo &device) {
    emit new_Device_Found(device.name(), device.address().toString());
    _BLE_Devices.append(new device_Info(device));

    QString devices_Size = QString::number(_BLE_Devices.size());

    emit search_Status_Changed("Found Devices: " + devices_Size);
}



void bluetooth_Bridge::S_device_Scan_Finished() {
    if (_BLE_Devices.isEmpty()) {
        emit search_Status_Changed("No Low Energy devices found.");
        emit search_Completed();
    }
    else {
        emit search_Status_Changed("Scanning done successfully.");
        emit search_Completed();
    }

    _scan_In_Progress = false;
    _device_Discovery_Agent->stop();
}



void bluetooth_Bridge::connect_To_Device(QString device_Mac) {
    device_Info *current_Device = nullptr;
    for (QObject *entry : qAsConst(_BLE_Devices)) {
        auto device = qobject_cast<device_Info *>(entry);
        if (device) {
            if (device->get_Device_Address() == device_Mac) {
                current_Device = device;
                break;
            }
        }
    }

    if (current_Device) {
        connect_Device(current_Device);
    }
}



void bluetooth_Bridge::S_device_Scan_Error(QBluetoothDeviceDiscoveryAgent::Error error) {
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError) {
        ble_Critical_Error("The Bluetooth adapter is powered off.");

    }
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError) {
        ble_Critical_Error("Bluetooth IO Error.");

    }
    else {
        ble_Critical_Error("An unknown error has occurred.");
    }
}



void bluetooth_Bridge::connect_Device(device_Info *device) {
    _current_Device = device;

    // Disconnect and delete old connection
    if (_BLE_Controller) {
        _BLE_Controller->disconnectFromDevice();
        delete _BLE_Controller;
        _BLE_Controller = nullptr;
    }

    // Create new controller and connect it if device available
    if (_current_Device) {
        _BLE_Controller = QLowEnergyController::createCentral(_current_Device->get_Device());
        emit connecting_Status_Changed("Creating connection...");
        _timeout_Timer->start();

        connect(_BLE_Controller, SIGNAL(connected()), this, SLOT(S_device_Connected()));
        connect(_BLE_Controller, SIGNAL(serviceDiscovered(QBluetoothUuid)), this, SLOT(S_service_Discovered(QBluetoothUuid)));
        connect(_BLE_Controller, SIGNAL(discoveryFinished()), this, SLOT(S_service_Scan_Done()), Qt::QueuedConnection);
        connect(_BLE_Controller, SIGNAL(disconnected()), this, SLOT(S_device_Disconnected()));
        //connect(_BLE_Controller, SIGNAL(error(QLowEnergyController::Error)), this, SLOT(S_BLE_Controller_Error(QLowEnergyController::Error)));

        _BLE_Controller->connectToDevice();
    }
}



void bluetooth_Bridge::S_device_Connected() {
    _timeout_Timer->stop();
    emit connected_To_Device(_current_Device->get_Device_Name());
    emit connecting_Status_Changed("Connected. Searching services...");
    _BLE_Services_UUID.clear();
    _BLE_Controller->discoverServices();
}



void bluetooth_Bridge::disconnect_Device() {
    if (_BLE_Controller) {
        if (_BLE_Controller->state() != QLowEnergyController::UnconnectedState) {
            _BLE_Controller->disconnectFromDevice();
            _current_Device = nullptr;
        }
    }
}



void bluetooth_Bridge::S_device_Disconnected() {
    _device_Connected = false;
    _update_Timer->stop();
    emit device_Disconnected();
}



void bluetooth_Bridge::S_service_Discovered(const QBluetoothUuid &gatt) {
    emit connecting_Status_Changed("Service discovered: " + gatt.toString());

    if (gatt.toString() == "{ebe0ccb0-7a0a-4b0c-8a1a-6ff2997da3a6}") {
        _display_Service_Found = true;
    }
}



void bluetooth_Bridge::S_service_Scan_Done() {
    emit connecting_Status_Changed("Services scan done.");

    _BLE_Services_UUID = _BLE_Controller->services();

    if (_BLE_Services_UUID.isEmpty()) {
        ble_Critical_Error("CONNECTION ERROR. Can't Find Any Services.");
    }
    else {
        if (_display_Service_Found) {
            _BLE_Service = _BLE_Controller->createServiceObject(QBluetoothUuid(QUuid("{ebe0ccb0-7a0a-4b0c-8a1a-6ff2997da3a6}")));
            emit connecting_Status_Changed("Display service discovered.");
        }
    }

    if (_BLE_Service) {
        connect(_BLE_Service, SIGNAL(stateChanged(QLowEnergyService::ServiceState)), this, SLOT(S_service_State_Changed(QLowEnergyService::ServiceState)));
        connect(_BLE_Service, SIGNAL(characteristicChanged(QLowEnergyCharacteristic,QByteArray)), this, SLOT(S_service_Characteristic_Changed(QLowEnergyCharacteristic,QByteArray)));
        connect(_BLE_Service, SIGNAL(characteristicRead(QLowEnergyCharacteristic,QByteArray)), this, SLOT(S_service_Characteristic_Read(QLowEnergyCharacteristic,QByteArray)));
        connect(_BLE_Service, SIGNAL(characteristicWritten(QLowEnergyCharacteristic,QByteArray)), this, SLOT(S_service_Characteristic_Written(QLowEnergyCharacteristic,QByteArray)));
        //connect(_BLE_Service, SIGNAL(error(QLowEnergyService::ServiceError)), this, SLOT(S_service_Error(QLowEnergyService::ServiceError)));

        if (_BLE_Service->state() == QLowEnergyService::RemoteService) {
            emit connecting_Status_Changed("Discovering Service Details...");
            _BLE_Service->discoverDetails();
        }
    }
    else {
        ble_Critical_Error("CONNECTION ERROR. Display Service NOT Found.");
    }
}



void bluetooth_Bridge::S_service_State_Changed(QLowEnergyService::ServiceState state) {
    if (state == QLowEnergyService::RemoteServiceDiscovered) {

        _climate_Data = _BLE_Service->characteristic(QBluetoothUuid(QUuid("{ebe0ccc1-7a0a-4b0c-8a1a-6ff2997da3a6}")));
        _climate_Descriptor = _climate_Data.descriptor(QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
        if (_climate_Descriptor.isValid()) {
            _BLE_Service->writeDescriptor(_climate_Descriptor, QByteArray::fromHex("01")); //Writing a descriptor to wait for notifications
        }
        else {
            ble_Critical_Error("Climate Descriptor Is Not Valid.");
        }


        _temperature_Unit = _BLE_Service->characteristic(QBluetoothUuid(QUuid("{ebe0ccbe-7a0a-4b0c-8a1a-6ff2997da3a6}")));
        if (!_temperature_Unit.isValid()) {
            ble_Critical_Error("Temperature Unit Descriptor Is Not Valid.");
        }


        _battery_Level = _BLE_Service->characteristic(QBluetoothUuid(QUuid("{ebe0ccc4-7a0a-4b0c-8a1a-6ff2997da3a6}")));
        if (!_battery_Level.isValid()) {
            ble_Critical_Error("Battery Level Descriptor Is Not Valid.");
        }


        _timestamp = _BLE_Service->characteristic(QBluetoothUuid(QUuid("{ebe0ccb7-7a0a-4b0c-8a1a-6ff2997da3a6}")));
        if (!_timestamp.isValid()) {
            ble_Critical_Error("Timestamp Descriptor Is Not Valid.");
        }

        //The initial reading of all the data
        _BLE_Service->readCharacteristic(_timestamp);
        _BLE_Service->readCharacteristic(_battery_Level);
        _BLE_Service->readCharacteristic(_temperature_Unit);
        _update_Timer->start(); //Start polling timer
        _device_Connected = true;

        emit connection_Completed();
    }
}



void bluetooth_Bridge::S_read_Data() {
    _BLE_Service->readCharacteristic(_timestamp);
    _BLE_Service->readCharacteristic(_battery_Level);
}



void bluetooth_Bridge::S_Connection_Timeout() {
    disconnect_Device();
    _timeout_Timer->stop();
    ble_Critical_Error("Connection timed out. Try again.");
}



void bluetooth_Bridge::set_New_Time(unsigned long new_TimeStamp, char new_TimeZone) {
    QByteArray time_Array;

    for (int i = 0; i != sizeof(new_TimeStamp); ++i) {
        time_Array.append((char)((new_TimeStamp & (0xFF << (i*8))) >> (i*8)));
    }

    time_Array.append(new_TimeZone);

    if (_device_Connected) {
        emit writing_Service();
        _BLE_Service->writeCharacteristic(_timestamp, time_Array);
    }
}



void bluetooth_Bridge::change_Temperature_Unit(QString unit) {
    if (_device_Connected) {
        emit writing_Service();

        if (unit == "celsius") {
            _BLE_Service->writeCharacteristic(_temperature_Unit, QByteArray::fromHex("ff"));
        }
        else if (unit == "fahrenheit") {
            _BLE_Service->writeCharacteristic(_temperature_Unit, QByteArray::fromHex("01"));
        }
    }
}



void bluetooth_Bridge::S_service_Characteristic_Changed(const QLowEnergyCharacteristic &characteristic, const QByteArray &value) {
    if (characteristic.uuid() == QBluetoothUuid(QUuid("{ebe0ccc1-7a0a-4b0c-8a1a-6ff2997da3a6}"))) {
        _clock_Service->process_Climate_Data(value);
    }
}



void bluetooth_Bridge::S_service_Characteristic_Read(const QLowEnergyCharacteristic &characteristic, const QByteArray &value) {
    if (characteristic.uuid() == QBluetoothUuid(QUuid("{ebe0ccb7-7a0a-4b0c-8a1a-6ff2997da3a6}"))) {
        _clock_Service->process_Time_Data(value);
    }

    if (characteristic.uuid() == QBluetoothUuid(QUuid("{ebe0ccc4-7a0a-4b0c-8a1a-6ff2997da3a6}"))) {
        _clock_Service->process_Battery_Data(value);
    }

    if (characteristic.uuid() == QBluetoothUuid(QUuid("{ebe0ccbe-7a0a-4b0c-8a1a-6ff2997da3a6}"))) {
        _clock_Service->process_Temperature_Unit(value);
    }
}



void bluetooth_Bridge::S_service_Characteristic_Written(const QLowEnergyCharacteristic &characteristic, const QByteArray &value) {
    emit writing_Service_Completed();

    if (characteristic.uuid() == QBluetoothUuid(QUuid("{ebe0ccb7-7a0a-4b0c-8a1a-6ff2997da3a6}"))) {
        _clock_Service->process_Time_Data(value);
    }

    if (characteristic.uuid() == QBluetoothUuid(QUuid("{ebe0ccbe-7a0a-4b0c-8a1a-6ff2997da3a6}"))) {
        _clock_Service->process_Temperature_Unit(value);
    }
}



void bluetooth_Bridge::S_BLE_Controller_Error(QLowEnergyController::Error error) {
    Q_UNUSED(error);
    ble_Critical_Error("BLE Controller Error.");
    _update_Timer->stop();
}



void bluetooth_Bridge::S_service_Error(QLowEnergyService::ServiceError error) {
    Q_UNUSED(error);
    ble_Critical_Error("CONNECTION ERROR. Display Service Error.");
    _update_Timer->stop();
}
