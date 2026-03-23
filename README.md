<!--suppress ALL -->

<p align="center">
    <a href="https://www.gaman.pl/" target="_blank">
        <img src="LOGO.png" alt="Logo of gaman.pl" width="300" height="300">
    </a>
</p>

<p align="center">
    <img src="TITLE.svg" width="600" height="63" alt="gaman.pl: ParkPal">
</p>

<hr>

- [A. Relacje](#a-relacje)
    * [A1. Szlaban wjazdowy](#a1-szlaban-wjazdowy)
    * [A2. Szlaban wyjazdowy](#a2-szlaban-wyjazdowy)
- [B. Przepływy na szlabanie wjazdowym](#b-przep-ywy-na-szlabanie-wjazdowym)
    * [B1. Odczyt rejestracji samochodu przez kamerę ANPR](#b1-odczyt-rejestracji-samochodu-przez-kamer--anpr)
    * [B2. Odczyt QR-kodu przez czytnik QR](#b2-odczyt-qr-kodu-przez-czytnik-qr)
    * [B3. Wprowadzenie numeru rezerwacji na ekranie dotykowym](#b3-wprowadzenie-numeru-rezerwacji-na-ekranie-dotykowym)
    * [B4. Wykonanie połączenia na numer automatyczny](#b4-wykonanie-po--czenia-na-numer-automatyczny)
    * [B5. Wysłanie SMSa na numer automatyczny](#b5-wys-anie-smsa-na-numer-automatyczny)
    * [B6. Rejestracja jest potwierdzona](#b6-rejestracja-jest-potwierdzona)
    * [B7. Rejestracja nie istnieje](#b7-rejestracja-nie-istnieje)

# A. Relacje

## A1. Szlaban wjazdowy

```mermaid
flowchart LR
    actor(Kierowca) ==> eCar([samochód]) ==> iCam(Kamera)
    iCam ==> ePlate([numer<br />rejestracji]) ==> HA((Home<br />Assistant))
    
    actor ==> eCode([QR kod]) ==> iQR(Czytnik<br />kodów)
    iQR ==> eID([numer<br />rezerwacji]) ==> HA
    
    actor ==> eFinger([palec]) ==> iTS(Ekran<br />dotykowy)
    HA ==> eReq([tekst]) ==> iTS
    iTS ==> eText([dane]) ==> HA
    
    actor ==> ePhone([połączenie]) ==> iPH(Stary<br />telefon)
    actor ==> eMess([SMS]) ==> iPH
    iPH ==> ePN([numer<br />telefonu]) ==> HA
    
    HA ==> eDS([numer telefonu<br />numer rezerwacji<br />numer rejestracji]) ==> apiPF(ParkFlow)
    apiPF ==> eRS([potwierdzona?<br />miejsce?]) ==> HA
    
    HA ==> eTrig2([impuls]) ==> G(Szlaban) ==> End((o))
```

## A2. Szlaban wyjazdowy

```mermaid
flowchart LR
    actor(Kierowca) ==> eCar([samochód]) ==> iCam(Kamera)
    iCam ==> ePlate([numer<br />rejestracji]) ==> HA((Home<br />Assistant))
    
    actor ==> eCode([QR kod]) ==> iQR(Czytnik<br />kodów)
    iQR ==> eID([numer<br />rezerwacji]) ==> HA
    
    actor ==> eFinger([palec]) ==> iTS(Ekran<br />dotykowy)
    HA ==> eReq([tekst]) ==> iTS
    iTS ==> eText([dane]) ==> HA
    
    actor ==> ePhone([połączenie]) ==> iPH(Stary<br />telefon)
    actor ==> eMess([SMS]) ==> iPH
    iPH ==> ePN([numer<br />telefonu]) ==> HA
    
    HA ==> eDS1([numer telefonu<br />numer rezerwacji<br />numer rejestracji]) ==> eCom1([sprawdź!]) ==> apiPF(ParkFlow)
    apiPF ==> eRS([potwierdzona?<br />opłacona?<br />dopłata?]) ==> HA

    HA ==> eDS2([numer rezerwacji]) ==> eCom2([opłacona!]) ==> apiPF2(ParkFlow)
    apiPF2 ==> eRS2([opłacona!]) ==> HA
    
    HA ==> eTrig2([impuls]) ==> G(Szlaban) ==> End((o))

    HA ==> eReq1([transakcja<br />+ numer telefonu]) ==> iPH2(Stary<br />telefon)
    iPH2 ==> eResp1([Wyślij SMS]) ==> End
    
    HA ==> eReq2([transakcja]) ==> iTerm(Terminal<br />PAX IM30)
    iTerm ==> eResp2([opłacona?]) ==> HA
    
    HA ==> eText2([dane]) ==> iTS2(Ekran<br />dotykowy) ==> eReq3([transakcja<br />+ numer telefonu<br />+ adres email<br />+ KID]) ==> iCash(Kasa<br />Pospay2)
    iCash ==> eResp3([fiskalizacja?]) ==> HA
    
    HA ==> eReq4([transakcja<br />+ adres email]) ==> iSMTP(Serwer<br />pocztowy)
    iSMTP ==> eResp4([Wyślij email]) ==> HA
```

# B. Przepływy na szlabanie wjazdowym

## B1. Odczyt rejestracji samochodu przez kamerę ANPR

```mermaid
flowchart LR
    subgraph Kamera
        Read[Odczyt<br />rejestracji]
    end

    subgraph Home Assistant
        Proc([Była już<br />przetwarzana?])
        Proc --Tak--> End((o))
    end

    subgraph Ekran dotykowy
        Disp[Wyświetl<br />rejestrację]
    end

    subgraph ParkFlow API
        Req1[Wyszukaj<br />rezerwację] --> Res1([Potwierdzona]) ==> B6((B6)) 
        Req1 --> Res2([Nie istnieje]) ==> B7((B7))
    end

    Read ==> Proc
    Proc ==Nie==> Disp
    Disp ==> Req1
```

## B2. Odczyt QR-kodu przez czytnik QR

## B3. Wprowadzenie numeru rezerwacji na ekranie dotykowym

## B4. Wykonanie połączenia na numer automatyczny

## B5. Wysłanie SMSa na numer automatyczny

## B6. Rejestracja jest potwierdzona

```mermaid
flowchart LR
    subgraph Home Assistant
        Proc([Przetwórz<br />odpowiedź])
    end

    subgraph Szlaban
        Open[Otwórz<br />szlaban]
    end

    subgraph Ekran dotykowy
        Disp[Wyświetl komunikat<br />'Proszę wjechać!']
    end

    B6((B6)) ==> Proc
    Proc ==> Open
    Proc ==> Disp
```

## B7. Rejestracja nie istnieje

```mermaid
flowchart LR
    subgraph Home Assistant
        Proc([Przetwórz<br />odpowiedź])
    end

    subgraph Szlaban
        Open[Otwórz<br />szlaban]
    end

    subgraph Ekran dotykowy
        Disp1[Wyświetl komunikat<br />'Brak miejsc!']
        Disp2[Wyświetl pytanie<br />'Płacisz przy wyjeździe?'] --> Res3([Tak])
        Disp2 --> Res4([Nie]) --> Disp1
    end

    subgraph ParkFlow API
        Req1[Sprawdź<br />wolne<br />miejsca] --> Res1([Brak])
        Req1 --> Res2([Są])
    end

    B7((B7)) ==> Proc
    Proc ==sezon niski==> Req1
    Proc ==sezon wysoki==> Disp1
    Res1 ==> Disp1
    Res2 ==> Disp2
    Res3 ==> Open
```