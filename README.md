# franky36

franky36 is 36 key compact handwired split keyboard. 
It uses RP2040-Zero controller and QMK firmware.

![franky36](./docs/assets/franky36.jpg)

## Features

- Split with single controller
- QMK (fully customizable)
- VIA support
- OLED display with layer status
- USB-C

## Case and plate

Designed in OpenSCAD and 3D printed. See [case](./case) for STL files and OpenSCAD source.

## Bill of material

| Item                              | Quantity |
|-----------------------------------|----------|
| RP2040-Zero controller            | 1        |
| MX switches                       | 36       |
| Through hole 1N4148 diodes        | 36       |
| OLED 128x32 SSD1306 display       | 1        |
| 1u keycaps                        | 32       |
| 1.25u keycaps                     | 4        |
| Electrical wires                  | -        |
| Magnetic USB-C adapter (optional) | 1        |
| Foam                              | -        |

## Firmware

QMK with VIA support. See [firmware](./firmware) folder for firmware files.
