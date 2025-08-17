// Vehicle makes and models data
class VehicleData {
  static final List<String> makes = [
    "Audi",
    "BMW",
    "Chevrolet",
    "Fisker",
    "Ford",
    "Honda",
    "Hyundai",
    "Kia",
    "Lexus",
    "Lucid",
    "Mercedes-Benz",
    "Nissan",
    "Polestar",
    "Porsche",
    "Rivian",
    "Subaru",
    "Tesla",
    "Toyota",
    "Volkswagen",
    "Volvo",
    "Others"
  ];

  static final Map<String, List<String>> makeToModels = {
    "Audi": [
      "A3", "A4", "A6", "A7", "A8", "Custom", "Q3", "Q4 e-tron", "Q5", "Q7", "Q8", "Q8 e-tron", "R8", "TT", "e-tron", "e-tron GT"
    ],
    "BMW": [
      "3 Series", "5 Series", "7 Series", "Custom", "M3", "M4", "M5", "X3", "X4", "X5", "X6", "X7", "i3", "i4", "i7", "i8", "iX", "iX1", "iX3"
    ],
    "Chevrolet": [
      "Blazer", "Bolt EV", "Camaro", "Colorado", "Corvette", "Custom", "Equinox", "Malibu", "Silverado", "Suburban", "Tahoe", "Traverse", "Trax"
    ],
    "Fisker": [
      "Custom", "Ocean", "Pear"
    ],
    "Ford": [
      "Bronco", "Bronco Sport", "Custom", "E-Transit", "EcoSport", "Edge", "Escape", "Expedition", "Explorer", "F-150", "F-150 Lightning",
      "Mustang", "Mustang GT", "Mustang Mach-E", "Ranger"
    ],
    "Honda": [
      "Accord", "Civic", "Civic Type R", "CR-V", "Custom", "Fit", "HR-V", "Insight", "Odyssey", "Passport", "Pilot", "Pilot Elite", "Ridgeline"
    ],
    "Hyundai": [
      "Custom", "Elantra", "Elantra N", "Ioniq", "Ioniq 5", "Ioniq 6", "Ioniq 7", "Kona", "Kona Electric", "Nexo",
      "Palisade", "Santa Fe", "Sonata", "Tucson", "Veloster", "Venue"
    ],
    "Kia": [
      "Carnival", "Custom", "CV", "EV6", "EV9", "Forte", "K5", "K900", "Niro EV", "Rio", "Sorento", "Soul", "Sportage", "Stinger", "Telluride"
    ],
    "Lexus": [
      "Custom", "ES", "GX", "IS", "LC", "LS", "LX", "NX", "RC", "RX", "UX"
    ],
    "Lucid": [
      "Air", "Custom", "Gravity"
    ],
    "Mercedes-Benz": [
      "A-Class", "AMG-GT", "C-Class", "CLA", "Custom", "E-Class", "EQA", "EQB", "EQC", "EQE", "EQS", "EQV",
      "G-Class", "GLA", "GLB", "GLC", "GLE", "GLS", "Maybach S-Class", "S-Class"
    ],
    "Nissan": [
      "Altima", "Ariya", "Armada", "Custom", "E70Z", "Frontier", "GT-R", "LEAF", "Max-Out", "Maxima", "Murano",
      "Pathfinder", "Rogue", "Sentra", "Titan"
    ],
    "Polestar": [
      "Custom", "Polestar 2", "Polestar 3", "Polestar 4"
    ],
    "Porsche": [
      "718", "911", "Boxster", "Cayenne", "Cayman", "Custom", "Macan", "Panamera", "Taycan", "Taycan Cross Turismo"
    ],
    "Rivian": [
      "Custom", "R1S", "R1T"
    ],
    "Subaru": [
      "Ascent", "BRZ", "Crosstrek", "Custom", "Forester", "Impreza", "Legacy", "Outback", "WRX"
    ],
    "Tesla": [
      "Cybertruck", "Custom", "Model 3", "Model S", "Model X", "Model Y"
    ],
    "Toyota": [
      "4Runner", "Avalon", "C-HR", "Camry", "Corolla", "Custom", "GR86", "Highlander", "Land Cruiser", "Mirai",
      "Prius", "RAV4", "Sienna", "Supra", "Tacoma", "Tundra"
    ],
    "Volkswagen": [
      "Arteon", "Atlas", "Atlas Cross Sport", "Custom", "Golf", "Golf GTI", "ID Buzz", "ID.3", "ID.4", "ID.5", "ID.6",
      "Jetta", "Jetta GLI", "Passat", "Taos", "Tiguan"
    ],
    "Volvo": [
      "C40 Recharge", "Custom", "S60", "S90", "V60", "V90", "XC40", "XC60", "XC90"
    ],
    "Others": [
      "OTHER_MODEL"
    ],
  };

  static final List<String> years = [
    for (int year = 2026; year >= 1995; year--) year.toString(),
  ];
}
