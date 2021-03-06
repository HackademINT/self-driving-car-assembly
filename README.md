# Self Driving Car Assembly

## Project

### Goals:

- make a self driving [car](Project/images/car_from_sky.jpg) that could follow a black line.
- light a siren and a laser on receiving a 4 (ASCII) on one of the sensors.
- increment of a counter with update of the LED display on receipt of ASCII characters D/C/G on the sensor.
- establish communication between the [slave card](Project/slave.a51) and the [master card](Project/master.a51) to send stop and start orders.
- increment of the number of laps realized at the reception of zero in ascii.

![](Project/videos/car.gif)

## Tutorials (TP in french)

### TP1: [README](TP1/README.md)
- State change of a led on a falling edge
- 4-bit and 8-bit display using I / O ports for increment and decrement

### TP2: [README](TP2/README.md)
- Use of interrupt vectors to make a comparison between two numbers

### TP3: [README](TP3/README.md)
- Build a 50 milliseconds timer and a cyclic report generator

### TP4: [README](TP4/README.md)
- Message display on the LCD screen

### TP5: [README](TP5/README.md)
- Data reception and emission through the use of serial ports

## Copyright:

### Master
- Teo COUPRIE DIAZ
- Dylan SOTON

### Slave
- Victor VEDIE
- Aurélien DUBOC
