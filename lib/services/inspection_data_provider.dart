import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Provider for inspection checklist data
/// Returns checklist items customized by vehicle type, fuel type, and age
class InspectionDataProvider {
  /// Get all inspection categories
  static List<String> getCategories() {
    return [
      'Exterior',
      'Interior',
      'Engine & Mechanical',
      'Suspension & Shocks',
      'Tyres & Wheels',
      'Test Drive',
      'Documents',
    ];
  }

  /// Get inspection items for a specific vehicle configuration
  static List<InspectionItem> getInspectionItems({
    VehicleType? vehicleType,
    FuelType? fuelType,
    int? vehicleAge,
  }) {
    final items = <InspectionItem>[];

    // Exterior checks
    items.addAll(_getExteriorItems());

    // Interior checks
    items.addAll(_getInteriorItems());

    // Engine checks (varies by fuel type)
    items.addAll(_getEngineItems(fuelType));

    // Suspension checks
    items.addAll(_getSuspensionItems(vehicleType));

    // Tyre checks
    items.addAll(_getTyreItems());

    // Test drive checks
    items.addAll(_getTestDriveItems(vehicleType, fuelType));

    // Document checks
    items.addAll(_getDocumentItems(vehicleAge));

    return items;
  }

  static List<InspectionItem> _getExteriorItems() {
    return [
      const InspectionItem(
        id: 'ext_1',
        category: 'Exterior',
        title: 'Body Paint Condition',
        description: 'Is the paint consistent across all panels?',
        helpText:
            'Look for color differences, orange peel texture, or overspray on rubber seals which may indicate repainting after an accident.',
        riskWeight: 8,
      ),
      const InspectionItem(
        id: 'ext_2',
        category: 'Exterior',
        title: 'Panel Gaps',
        description: 'Are the gaps between panels even and consistent?',
        helpText:
            'Uneven gaps between doors, hood, or trunk may indicate accident repair or frame damage.',
        riskWeight: 9,
      ),
      const InspectionItem(
        id: 'ext_3',
        category: 'Exterior',
        title: 'Rust Check',
        description: 'Is the body free from rust or corrosion?',
        helpText:
            'Check wheel arches, door edges, trunk edges, and under the car for rust bubbles or holes.',
        riskWeight: 7,
      ),
      const InspectionItem(
        id: 'ext_4',
        category: 'Exterior',
        title: 'Glass & Mirrors',
        description: 'Are all windows and mirrors crack-free?',
        helpText:
            'Check for chips, cracks, or clouding. Aftermarket windshields may indicate accident history.',
        riskWeight: 5,
      ),
      const InspectionItem(
        id: 'ext_5',
        category: 'Exterior',
        title: 'Lights & Signals',
        description: 'Do all lights work properly?',
        helpText:
            'Check headlights, tail lights, brake lights, turn signals, and reverse lights.',
        riskWeight: 4,
      ),
      const InspectionItem(
        id: 'ext_6',
        category: 'Exterior',
        title: 'Flood Damage Signs',
        description: 'Any water stain lines or mud deposits?',
        helpText:
            'Look for water marks on headlight housings, mud in hidden areas, or musty smell.',
        riskWeight: 10,
      ),
    ];
  }

  static List<InspectionItem> _getInteriorItems() {
    return [
      const InspectionItem(
        id: 'int_1',
        category: 'Interior',
        title: 'Seat Condition',
        description: 'Are seats in good condition without excessive wear?',
        helpText:
            'Check for tears, stains, or sagging. Driver seat wear should match claimed mileage.',
        riskWeight: 4,
      ),
      const InspectionItem(
        id: 'int_2',
        category: 'Interior',
        title: 'Dashboard & Instruments',
        description: 'Do all gauges and warning lights work properly?',
        helpText:
            'Turn ignition on - all warning lights should illuminate briefly then turn off.',
        riskWeight: 6,
      ),
      const InspectionItem(
        id: 'int_3',
        category: 'Interior',
        title: 'Air Conditioning',
        description: 'Does the AC blow cold air?',
        helpText:
            'AC should cool the cabin within 2-3 minutes. Check all vents and fan speeds.',
        riskWeight: 5,
      ),
      const InspectionItem(
        id: 'int_4',
        category: 'Interior',
        title: 'Power Windows',
        description: 'Do all power windows work smoothly?',
        helpText:
            'Test each window up and down. Listen for grinding or hesitation.',
        riskWeight: 3,
      ),
      const InspectionItem(
        id: 'int_5',
        category: 'Interior',
        title: 'Odometer Verification',
        description: 'Does the mileage look genuine?',
        helpText:
            'Compare wear on pedals, steering, and seats with claimed mileage. Typically 12-15k km/year.',
        riskWeight: 9,
      ),
      const InspectionItem(
        id: 'int_6',
        category: 'Interior',
        title: 'Carpet & Floor',
        description: 'Are carpets clean without water damage?',
        helpText:
            'Lift carpets to check for water stains, rust, or replacement carpets (flood sign).',
        riskWeight: 8,
      ),
      const InspectionItem(
        id: 'int_7',
        category: 'Interior',
        title: 'Musty Smell',
        description: 'Is the car free from musty or moldy smell?',
        helpText:
            'Strong air fresheners may be hiding bad smells. Musty smell indicates water damage.',
        riskWeight: 7,
      ),
    ];
  }

  static List<InspectionItem> _getEngineItems(FuelType? fuelType) {
    final items = <InspectionItem>[
      const InspectionItem(
        id: 'eng_1',
        category: 'Engine & Mechanical',
        title: 'Engine Start',
        description: 'Does the engine start smoothly?',
        helpText:
            'Engine should start within 2-3 seconds without unusual sounds.',
        riskWeight: 8,
      ),
      const InspectionItem(
        id: 'eng_2',
        category: 'Engine & Mechanical',
        title: 'Engine Idle',
        description: 'Does the engine idle smoothly?',
        helpText:
            'Engine should run steadily without shaking or stalling. Use vibration test.',
        riskWeight: 7,
      ),
      const InspectionItem(
        id: 'eng_3',
        category: 'Engine & Mechanical',
        title: 'Engine Oil',
        description: 'Is the engine oil clean and at proper level?',
        helpText:
            'Oil should be honey-colored or dark amber. Black, gritty, or milky oil is bad.',
        riskWeight: 6,
      ),
      const InspectionItem(
        id: 'eng_4',
        category: 'Engine & Mechanical',
        title: 'Coolant Level',
        description: 'Is coolant level proper and clean?',
        helpText:
            'Check coolant reservoir. Brown or oily coolant may indicate head gasket problems.',
        riskWeight: 7,
      ),
      const InspectionItem(
        id: 'eng_5',
        category: 'Engine & Mechanical',
        title: 'Exhaust Smoke',
        description: 'Is the exhaust smoke-free during acceleration?',
        helpText:
            'Blue smoke = oil burning, White smoke = coolant leak, Black smoke = fuel issues.',
        riskWeight: 8,
      ),
      const InspectionItem(
        id: 'eng_6',
        category: 'Engine & Mechanical',
        title: 'Engine Noise',
        description: 'Is the engine free from knocking or ticking sounds?',
        helpText:
            'Knocking may indicate worn bearings. Ticking may be valve or timing issues.',
        riskWeight: 9,
      ),
      const InspectionItem(
        id: 'eng_7',
        category: 'Engine & Mechanical',
        title: 'Transmission',
        description: 'Does the gearbox shift smoothly?',
        helpText:
            'For automatic: should shift without jerks. For manual: clutch should engage smoothly.',
        riskWeight: 9,
      ),
    ];

    // Add hybrid-specific checks
    if (fuelType == FuelType.hybrid || fuelType == FuelType.electric) {
      items.addAll([
        const InspectionItem(
          id: 'eng_hyb_1',
          category: 'Engine & Mechanical',
          title: 'Hybrid Battery Health',
          description: 'Check hybrid battery health status',
          helpText:
              'Use diagnostic tool to check battery health percentage. Below 70% may need replacement soon.',
          riskWeight: 10,
        ),
        const InspectionItem(
          id: 'eng_hyb_2',
          category: 'Engine & Mechanical',
          title: 'Electric Motor',
          description: 'Does the electric motor engage properly?',
          helpText:
              'Car should run on electric motor at low speeds without unusual sounds.',
          riskWeight: 8,
        ),
      ]);
    }

    // Add diesel-specific checks
    if (fuelType == FuelType.diesel) {
      items.addAll([
        const InspectionItem(
          id: 'eng_dsl_1',
          category: 'Engine & Mechanical',
          title: 'Turbo Operation',
          description: 'Does the turbo spool up without issues?',
          helpText:
              'Listen for turbo whistle during acceleration. Excessive smoke or lag indicates problems.',
          riskWeight: 8,
        ),
        const InspectionItem(
          id: 'eng_dsl_2',
          category: 'Engine & Mechanical',
          title: 'DPF Status',
          description: 'Is the diesel particulate filter clean?',
          helpText:
              'DPF warning light or excessive regeneration may indicate expensive repairs needed.',
          riskWeight: 7,
        ),
      ]);
    }

    return items;
  }

  static List<InspectionItem> _getSuspensionItems(VehicleType? vehicleType) {
    final items = <InspectionItem>[
      const InspectionItem(
        id: 'sus_1',
        category: 'Suspension & Shocks',
        title: 'Bounce Test',
        description: 'Does the car stop bouncing after one bounce?',
        helpText:
            'Push down each corner firmly. Car should bounce once and settle. Multiple bounces = worn shocks.',
        riskWeight: 6,
      ),
      const InspectionItem(
        id: 'sus_2',
        category: 'Suspension & Shocks',
        title: 'Shock Absorber Leaks',
        description: 'Are shock absorbers free from oil leaks?',
        helpText:
            'Look for oil stains around shock absorbers. Leaking shocks need replacement.',
        riskWeight: 5,
      ),
      const InspectionItem(
        id: 'sus_3',
        category: 'Suspension & Shocks',
        title: 'Steering Play',
        description: 'Is the steering free from excessive play?',
        helpText:
            'With engine on, turn wheel slightly. More than 2 inches of play indicates worn components.',
        riskWeight: 7,
      ),
      const InspectionItem(
        id: 'sus_4',
        category: 'Suspension & Shocks',
        title: 'Alignment',
        description: 'Does the car track straight?',
        helpText:
            'On a flat road, car should drive straight without pulling to either side.',
        riskWeight: 4,
      ),
    ];

    // Add SUV/Pickup specific checks
    if (vehicleType == VehicleType.suv || vehicleType == VehicleType.pickup) {
      items.add(
        const InspectionItem(
          id: 'sus_5',
          category: 'Suspension & Shocks',
          title: '4WD System',
          description: 'Does the 4WD system engage properly?',
          helpText:
              'Test all 4WD modes if available. Listen for grinding or difficulty engaging.',
          riskWeight: 8,
        ),
      );
    }

    return items;
  }

  static List<InspectionItem> _getTyreItems() {
    return [
      const InspectionItem(
        id: 'tyr_1',
        category: 'Tyres & Wheels',
        title: 'Tread Depth',
        description: 'Do all tyres have adequate tread?',
        helpText:
            'Minimum 2mm tread depth required. Check using the coin test or tread indicators.',
        riskWeight: 5,
      ),
      const InspectionItem(
        id: 'tyr_2',
        category: 'Tyres & Wheels',
        title: 'Even Wear',
        description: 'Are tyres wearing evenly?',
        helpText:
            'Uneven wear may indicate alignment issues or suspension problems. Check inner edges too.',
        riskWeight: 5,
      ),
      const InspectionItem(
        id: 'tyr_3',
        category: 'Tyres & Wheels',
        title: 'Tyre Age',
        description: 'Are the tyres less than 5 years old?',
        helpText:
            'Check DOT code on sidewall. Last 4 digits show week and year of manufacture.',
        riskWeight: 4,
      ),
      const InspectionItem(
        id: 'tyr_4',
        category: 'Tyres & Wheels',
        title: 'Wheel Condition',
        description: 'Are wheels free from damage?',
        helpText:
            'Check for curb damage, cracks, or bends. Damaged wheels can cause vibration and tyre damage.',
        riskWeight: 4,
      ),
      const InspectionItem(
        id: 'tyr_5',
        category: 'Tyres & Wheels',
        title: 'Spare Tyre',
        description: 'Is the spare tyre present and in good condition?',
        helpText:
            'Check spare tyre pressure and condition. Ensure jack and tools are present.',
        riskWeight: 3,
      ),
    ];
  }

  static List<InspectionItem> _getTestDriveItems(
    VehicleType? vehicleType,
    FuelType? fuelType,
  ) {
    return [
      const InspectionItem(
        id: 'td_1',
        category: 'Test Drive',
        title: 'Acceleration',
        description: 'Does the car accelerate smoothly?',
        helpText:
            'Car should accelerate without hesitation, jerks, or unusual sounds.',
        riskWeight: 7,
      ),
      const InspectionItem(
        id: 'td_2',
        category: 'Test Drive',
        title: 'Braking',
        description: 'Do brakes stop the car smoothly and straight?',
        helpText:
            'Test brakes at various speeds. Car should not pull to one side or vibrate.',
        riskWeight: 9,
      ),
      const InspectionItem(
        id: 'td_3',
        category: 'Test Drive',
        title: 'Steering Response',
        description: 'Does the steering respond properly?',
        helpText:
            'Steering should be smooth and responsive. Listen for power steering noise.',
        riskWeight: 6,
      ),
      const InspectionItem(
        id: 'td_4',
        category: 'Test Drive',
        title: 'Road Noise',
        description: 'Is the cabin reasonably quiet?',
        helpText:
            'Excessive road noise may indicate worn wheel bearings, tyres, or poor insulation.',
        riskWeight: 4,
      ),
      const InspectionItem(
        id: 'td_5',
        category: 'Test Drive',
        title: 'Vibrations',
        description: 'Is the car free from unusual vibrations?',
        helpText:
            'Vibrations may indicate wheel balance issues, worn drivetrain, or engine mounts.',
        riskWeight: 6,
      ),
      const InspectionItem(
        id: 'td_6',
        category: 'Test Drive',
        title: 'Over Speed Bumps',
        description: 'Does suspension handle bumps well?',
        helpText:
            'Car should absorb bumps without harsh jolts or clunking sounds.',
        riskWeight: 5,
      ),
    ];
  }

  static List<InspectionItem> _getDocumentItems(int? vehicleAge) {
    final items = <InspectionItem>[
      const InspectionItem(
        id: 'doc_1',
        category: 'Documents',
        title: 'Registration Document',
        description: 'Is the original registration available?',
        helpText:
            'Verify owner name, vehicle details, and check for any loans or liens.',
        riskWeight: 10,
      ),
      const InspectionItem(
        id: 'doc_2',
        category: 'Documents',
        title: 'Insurance',
        description: 'Is current insurance available?',
        helpText:
            'Check insurance validity and type. Full insurance history shows responsible ownership.',
        riskWeight: 5,
      ),
      const InspectionItem(
        id: 'doc_3',
        category: 'Documents',
        title: 'Service Records',
        description: 'Are service records available?',
        helpText:
            'Full service history indicates well-maintained vehicle. Verify mileage at each service.',
        riskWeight: 7,
      ),
      const InspectionItem(
        id: 'doc_4',
        category: 'Documents',
        title: 'Revenue License',
        description: 'Is the revenue license current?',
        helpText:
            'Expired license may indicate hidden issues or unpaid taxes.',
        riskWeight: 6,
      ),
      const InspectionItem(
        id: 'doc_5',
        category: 'Documents',
        title: 'Chassis Number Match',
        description: 'Does chassis number match documents?',
        helpText:
            'Check chassis number plate matches registration. Mismatch is a serious red flag.',
        riskWeight: 10,
      ),
    ];

    // Add emission test for older vehicles
    if (vehicleAge != null && vehicleAge > 5) {
      items.add(
        const InspectionItem(
          id: 'doc_6',
          category: 'Documents',
          title: 'Emission Test',
          description: 'Is the emission test current?',
          helpText:
              'Required for vehicles over 5 years. Check certificate validity.',
          riskWeight: 5,
        ),
      );
    }

    return items;
  }
}
