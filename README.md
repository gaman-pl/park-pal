<!--suppress ALL -->

<p align="center">
    <a href="https://www.jamb.pl/" target="_blank">
        <img src="LOGO.png" alt="Logo of Jamb" width="300" height="300">
    </a>
</p>

<p align="center">
    <img src="TITLE.svg" width="600" height="63" alt="Jamb: ParkPal">
</p>

<hr>

# High-Level Design

## Szlaban wjazdowy

```mermaid
flowchart LR
    actor([Kierowca]) --samochód--> iCAM([Kamera])
    actor --kod--> iQR([Czytnik kodów])
    actor --palec--> iTS([Ekran dotykowy])
    actor --telefon--> iPH([Komórka])
    actor --SMS--> iPH([Komórka])
    actor --palec--> iBP([Klawisz])
    iCAM --> HA([Home Assistant])
    iQR --> HA
    iTS --> HA
    iPH --> HA
    iBP --> HA
    HA --> PF([ParkFlow API])
    PF --> HA
    HA --> G([Szlaban])
```

## Szlaban wyjazdowy

```mermaid
flowchart LR
    actor([Kierowca]) --samochód--> iCAM([Kamera])
    actor --kod--> iQR([Czytnik kodów])
    actor --palec--> iTS([Ekran dotykowy])
    actor --telefon--> iPH([Komórka])
    actor --SMS--> iPH([Komórka])
    actor --palec--> iBP([Klawisz])
    iCAM --> HA([Home Assistant])
    iQR --> HA
    iTS --> HA
    iPH --> HA
    iBP --> HA
    HA --> PF([ParkFlow API])
    PF --> HA
    HA --> PG([Payment Gateway])
    PG --> HA
    HA --> G([Szlaban])
```