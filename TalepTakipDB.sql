CREATE TABLE Vatandas (
    VatandasID SERIAL PRIMARY KEY,
    TCNo CHAR(11) NOT NULL UNIQUE,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    Telefon VARCHAR(20) NOT NULL,
    Eposta VARCHAR(100),
    Adres TEXT NOT NULL,
    OlusturmaTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TalepTuru (
    TalepTuruID SERIAL PRIMARY KEY,
    TalepTuruAdi VARCHAR(100) NOT NULL UNIQUE,
    Aciklama TEXT,
    AktifMi BOOLEAN DEFAULT TRUE
);

CREATE TABLE TalepDurumu (
    TalepDurumuID SERIAL PRIMARY KEY,
    DurumAdi VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE Talep (
    TalepID SERIAL PRIMARY KEY,
    VatandasID INT NOT NULL,
    TalepTuruID INT NOT NULL,
    TalepDurumuID INT NOT NULL,

    Baslik VARCHAR(200) NOT NULL,
    Aciklama TEXT NOT NULL,

    Il VARCHAR(50),
    Ilce VARCHAR(50),
    Mahalle VARCHAR(100),

    Adres TEXT,

    OlusturmaTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SonGuncellenme TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_Talep_Vatandas
        FOREIGN KEY (VatandasID)
        REFERENCES Vatandas(VatandasID),

    CONSTRAINT FK_Talep_TalepTuru
        FOREIGN KEY (TalepTuruID)
        REFERENCES TalepTuru(TalepTuruID),

    CONSTRAINT FK_Talep_Durum
        FOREIGN KEY (TalepDurumuID)
        REFERENCES TalepDurumu(TalepDurumuID)
);


CREATE TABLE TalepFotograf (
    FotografID SERIAL PRIMARY KEY,

    TalepID INT NOT NULL,

    DosyaYolu VARCHAR(500) NOT NULL,
    YuklenmeTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_Fotograf_Talep
        FOREIGN KEY (TalepID)
        REFERENCES Talep(TalepID)
        ON DELETE CASCADE
);

CREATE TABLE TalepGecmisi (
    GecmisID SERIAL PRIMARY KEY,
    
    TalepID INT NOT NULL,

    EskiDurumID INT,
    YeniDurumID INT,

    Aciklama TEXT,

    IslemTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_Gecmis_Talep
        FOREIGN KEY (TalepID)
        REFERENCES Talep(TalepID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Gecmis_EskiDurum
        FOREIGN KEY (EskiDurumID)
        REFERENCES TalepDurumu(TalepDurumuID),

    CONSTRAINT FK_Gecmis_YeniDurum
        FOREIGN KEY (YeniDurumID)
        REFERENCES TalepDurumu(TalepDurumuID)

);

CREATE TABLE Il (
    IlID SERIAL PRIMARY KEY,
    IlAdi VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Ilce (
    IlceID SERIAL PRIMARY KEY,

    IlID INT NOT NULL,

    IlceAdi VARCHAR(100) NOT NULL,

    CONSTRAINT FK_Ilce_Il
        FOREIGN KEY(IlID)
        REFERENCES Il(IlID)
);

CREATE TABLE Mahalle (
    MahalleID SERIAL PRIMARY KEY,

    IlceID INT NOT NULL,

    MahalleAdi VARCHAR(100) NOT NULL,

    CONSTRAINT FK_Mahalle_Ilce
        FOREIGN KEY(IlceID)
        REFERENCES Ilce(IlceID)
);

CREATE TABLE Adres (

    AdresID SERIAL PRIMARY KEY,

    MahalleID INT NOT NULL,

    AcikAdres TEXT NOT NULL,

    BinaNo VARCHAR(20),
    DaireNo VARCHAR(20),

    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),

    CONSTRAINT FK_Adres_Mahalle
        FOREIGN KEY(MahalleID)
        REFERENCES Mahalle(MahalleID)

);

ALTER TABLE Vatandas
DROP COLUMN Adres;

ALTER TABLE Vatandas
ADD COLUMN AdresID INT;

ALTER TABLE Vatandas
ADD CONSTRAINT FK_Vatandas_Adres
FOREIGN KEY (AdresID)
REFERENCES Adres(AdresID);
