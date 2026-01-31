/// SoilGrids API konstantlari
/// Tuproq turi va tarkibi ma'lumotlari uchun (ISRIC)
class SoilGridsConstants {
  SoilGridsConstants._();

  // ================== BASE URLs ==================
  
  /// Asosiy API URL
  static const String baseUrl = 'https://rest.isric.org/soilgrids/v2.0';
  
  /// Properties query endpoint
  static const String propertiesQueryEndpoint = '/properties/query';
  
  /// Classification query endpoint (WRB tuproq klassifikatsiyasi)
  static const String classificationEndpoint = '/classification/query';

  // ================== TIMEOUTS ==================
  
  static const int connectTimeout = 60; // SoilGrids sekin ishlashi mumkin
  static const int receiveTimeout = 60;
  static const int sendTimeout = 30;

  // ================== QUERY PARAMETERS ==================
  
  /// Koordinata parametrlari
  static const String latitudeParam = 'lat';
  static const String longitudeParam = 'lon';
  
  /// Ma'lumot parametrlari
  static const String propertyParam = 'property';
  static const String depthParam = 'depth';
  static const String valueParam = 'value';

  // ================== TUPROQ XUSUSIYATLARI ==================
  
  /// Mavjud tuproq xususiyatlari
  static const String bdod = 'bdod';     // Bulk density (kg/dm³)
  static const String cec = 'cec';       // Cation Exchange Capacity (cmol(c)/kg)
  static const String cfvo = 'cfvo';     // Coarse fragments (cm³/dm³)
  static const String clay = 'clay';     // Clay content (g/kg)
  static const String nitrogen = 'nitrogen'; // Total nitrogen (g/kg)
  static const String phh2o = 'phh2o';   // pH (H2O)
  static const String sand = 'sand';     // Sand content (g/kg)
  static const String silt = 'silt';     // Silt content (g/kg)
  static const String soc = 'soc';       // Soil organic carbon (g/kg)
  static const String ocd = 'ocd';       // Organic carbon density (kg/m³)
  static const String ocs = 'ocs';       // Organic carbon stocks (kg/m²)
  static const String wv0010 = 'wv0010'; // Water content at 10kPa (cm³/dm³)
  static const String wv0033 = 'wv0033'; // Water content at 33kPa (cm³/dm³)
  static const String wv1500 = 'wv1500'; // Water content at 1500kPa (cm³/dm³)

  /// Barcha mavjud xususiyatlar ro'yxati
  static const List<String> allProperties = [
    bdod,
    cec,
    cfvo,
    clay,
    nitrogen,
    phh2o,
    sand,
    silt,
    soc,
    ocd,
    ocs,
    wv0010,
    wv0033,
    wv1500,
  ];

  /// Asosiy tuproq tarkibi xususiyatlari
  static const List<String> textureProperties = [
    clay,
    sand,
    silt,
  ];

  /// Unumdorlik xususiyatlari
  static const List<String> fertilityProperties = [
    soc,
    nitrogen,
    cec,
    phh2o,
  ];

  /// Suv saqlash xususiyatlari
  static const List<String> waterProperties = [
    wv0010,
    wv0033,
    wv1500,
  ];

  // ================== CHUQURLIK INTERVALLARI ==================
  
  /// Standart chuqurlik intervallari (cm)
  static const String depth0to5 = '0-5';
  static const String depth5to15 = '5-15';
  static const String depth15to30 = '15-30';
  static const String depth30to60 = '30-60';
  static const String depth60to100 = '60-100';
  static const String depth100to200 = '100-200';

  /// Barcha chuqurlik intervallari
  static const List<String> allDepths = [
    depth0to5,
    depth5to15,
    depth15to30,
    depth30to60,
    depth60to100,
    depth100to200,
  ];

  /// Yuza qatlam chuqurliklari (dehqonchilik uchun muhim)
  static const List<String> topsoilDepths = [
    depth0to5,
    depth5to15,
    depth15to30,
  ];

  /// Ildiz qatlami chuqurliklari
  static const List<String> rootZoneDepths = [
    depth30to60,
    depth60to100,
  ];

  // ================== QIYMAT TURLARI ==================
  
  /// Statistik qiymat turlari
  static const String meanValue = 'mean';
  static const String q005Value = 'Q0.05';  // 5th percentile
  static const String q050Value = 'Q0.5';   // Median
  static const String q095Value = 'Q0.95';  // 95th percentile

  /// Barcha qiymat turlari
  static const List<String> allValues = [
    meanValue,
    q005Value,
    q050Value,
    q095Value,
  ];

  // ================== TUPROQ NOMI VA TAVSIFI ==================
  
  /// Xususiyat nomlari (uzbekcha)
  static const Map<String, String> propertyNames = {
    bdod: 'Bulk zichlik',
    cec: 'Kation almashinuv sig\'imi',
    cfvo: "Yirik zarrachalar hajmi",
    clay: 'Gil miqdori',
    nitrogen: 'Umumiy azot',
    phh2o: 'pH (H2O)',
    sand: 'Qum miqdori',
    silt: 'Lyos miqdori',
    soc: 'Organik uglerod',
    ocd: 'Organik uglerod zichligi',
    ocs: 'Organik uglerod zaxirasi',
    wv0010: 'Suv miqdori (10kPa)',
    wv0033: 'Suv miqdori (33kPa)',
    wv1500: 'Suv miqdori (1500kPa)',
  };

  /// Xususiyat birliklari
  static const Map<String, String> propertyUnits = {
    bdod: 'kg/dm³',
    cec: 'cmol(c)/kg',
    cfvo: 'cm³/dm³',
    clay: 'g/kg',
    nitrogen: 'g/kg',
    phh2o: '',
    sand: 'g/kg',
    silt: 'g/kg',
    soc: 'g/kg',
    ocd: 'kg/m³',
    ocs: 'kg/m²',
    wv0010: 'cm³/dm³',
    wv0033: 'cm³/dm³',
    wv1500: 'cm³/dm³',
  };

  // ================== TUPROQ KLASSIFIKATSIYASI ==================
  
  /// WRB tuproq klassifikatsiyasi (World Reference Base)
  static const Map<String, String> wrbSoilClasses = {
    'Acrisols': 'Kislotali tuproqlar',
    'Alisols': 'Alisol tuproqlar',
    'Andosols': 'Vulqon tuproqlari',
    'Anthrosols': "Inson ta'sirida shakllangan tuproqlar",
    'Arenosols': 'Qumli tuproqlar',
    'Calcisols': 'Ohakli tuproqlar',
    'Cambisols': "O'zgaruvchan tuproqlar",
    'Chernozems': 'Qora tuproqlar',
    'Cryosols': 'Muzlagan tuproqlar',
    'Durisols': 'Silisiumli tuproqlar',
    'Ferralsols': 'Temir boyit tuproqlar',
    'Fluvisols': 'Daryo bo\'yi tuproqlari',
    'Gleysols': 'Botqoq tuproqlar',
    'Gypsisols': 'Gipsli tuproqlar',
    'Histosols': 'Torf tuproqlar',
    'Kastanozems': 'Kashtan tuproqlar',
    'Leptosols': 'Yupqa tuproqlar',
    'Lixisols': 'Liksisol tuproqlar',
    'Luvisols': 'Gil boyit tuproqlar',
    'Nitisols': 'Nitisol tuproqlar',
    'Phaeozems': 'Qoramtir tuproqlar',
    'Planosols': 'Tekis tuproqlar',
    'Plinthosols': 'Plintit tuproqlar',
    'Podzols': 'Kulrang tuproqlar',
    'Regosols': 'Rivojlanmagan tuproqlar',
    'Retisols': 'Retisol tuproqlar',
    'Solonchaks': 'Sho\'rlankan tuproqlar',
    'Solonetz': 'Ishqoriy tuproqlar',
    'Stagnosols': 'Suv tiqilgan tuproqlar',
    'Technosols': 'Texnogen tuproqlar',
    'Umbrisols': 'Umbrisol tuproqlar',
    'Vertisols': 'Gil tuproqlar',
  };

  // ================== HELPER METHODS ==================
  
  /// Xususiyat nomini olish
  static String getPropertyName(String property) {
    return propertyNames[property] ?? property;
  }

  /// Xususiyat birligini olish
  static String getPropertyUnit(String property) {
    return propertyUnits[property] ?? '';
  }

  /// Chuqurlik intervalini formatlash
  static String formatDepth(String depth) {
    return '$depth cm';
  }

  /// WRB tuproq nomini olish
  static String getSoilClassName(String wrbClass) {
    return wrbSoilClasses[wrbClass] ?? wrbClass;
  }

  /// Tuproq teksturasini aniqlash (gil, qum, lyos nisbatiga ko'ra)
  static String getSoilTexture({
    required double clayPercent,
    required double sandPercent,
    required double siltPercent,
  }) {
    // USDA tuproq tekstura uchburchagi asosida
    if (clayPercent >= 40) {
      if (siltPercent >= 40) return 'Silit-gil';
      if (sandPercent >= 45) return 'Qumli gil';
      return 'Gil';
    } else if (sandPercent >= 85) {
      return 'Qum';
    } else if (siltPercent >= 80) {
      return 'Lyos';
    } else if (sandPercent >= 70) {
      return 'Qumli lyosli';
    } else if (clayPercent >= 27 && clayPercent < 40) {
      if (sandPercent >= 20 && sandPercent < 45) return 'Gilli lyos';
      return 'Lyosli gil';
    } else if (clayPercent >= 7 && clayPercent < 27) {
      if (siltPercent >= 28 && siltPercent < 50) return 'Lyos';
      if (siltPercent >= 50 && siltPercent < 80) return 'Lyosli sho\'r';
      return 'Qumli lyos';
    }
    return 'Aralash';
  }
}
