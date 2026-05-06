import Foundation

enum CaseRepository {

    static let allCases: [CrimeCase] = [
        rooftopRobbery,
        closingShift,
        greenhouseTheft,
        pawnshopViolin,
        bakeryBreakIn,
        bookshopFirstEdition,
        tailorSilkBolt,
        arcadeCoinPusher,
        flowershopOrchid,
        laundromatCoinBox,
        recordshopPressing,
        bodegaLottery,
        cobblerGoldLeaf,
        midnightHeist,
        diamondVanish,
        masquerade
    ]

    static func first() -> CrimeCase { rooftopRobbery }

    static func byId(_ id: String) -> CrimeCase? {
        allCases.first { $0.id == id }
    }

    // MARK: - Case 1 · The Rooftop Robbery (rookie, free)

    static let rooftopRobbery = CrimeCase(
        id: "case-001-rooftop",
        title: "The Rooftop Robbery",
        blurb: "A penthouse safe was cracked at 2:14 AM. Doorman swears no one came in. The shadow on the security camera disagrees.",
        location: "Penthouse Apartment · West End",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Shadow",
            profileSilhouette: "person.fill.questionmark",
            known: "Tall. Quiet. Knows the building."
        ),
        sceneIcon: "house.lodge.fill",
        sceneTint: [0.16, 0.21, 0.42],
        evidence: [
            Evidence(
                id: "ev-001-fingerprint",
                type: .fingerprint,
                name: "Smudged Fingerprint",
                description: "Lifted off the safe dial. A clear partial — clean enough to enter into evidence.",
                isIncriminating: true,
                normalizedX: 0.72,
                normalizedY: 0.42,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Whorl pattern, right thumb. Smudge consistent with someone in a hurry.",
                    uvFinding: "Faint glycerin residue — suggests gloves were taken off, then put back on.",
                    labFinding: "AFIS run: 87% likelihood match against an unsolved 2024 jewelry-store break-in.",
                    forensicVerdict: .strong,
                    forensicNote: "This places someone at the safe. The bench will accept this without much pushback."
                ),
                surfaceIcon: "lock.fill",
                surfaceLabel: "THE WALL SAFE",
                judgeLine: "A thumbprint on the dial. The bench finds it persuasive."
            ),
            Evidence(
                id: "ev-001-note",
                type: .note,
                name: "Crumpled Note",
                description: "A torn page reads: \"meet me on the roof. 2 AM. bring the cutter.\"",
                isIncriminating: true,
                normalizedX: 0.28,
                normalizedY: 0.66,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Cheap ballpoint, written in haste. Top edge torn, not cut.",
                    uvFinding: "A second message was rubbed out under UV: an address — \"Larkspur, 4F\".",
                    labFinding: "Paper stock matches a notepad sold only at the Larkspur Hotel front desk.",
                    forensicVerdict: .strong,
                    forensicNote: "Premeditation, plus a place to look next. Solid exhibit."
                ),
                surfaceIcon: "trash.fill",
                surfaceLabel: "THE STUDY TRASH BIN",
                judgeLine: "Premeditation, in their own hand. Hard to argue with."
            ),
            Evidence(
                id: "ev-001-footprint",
                type: .footprint,
                name: "Boot Print",
                description: "Size 12 tread on the windowsill. Soil residue suggests rooftop access.",
                isIncriminating: true,
                normalizedX: 0.58,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Vibram sole, work boot. Heel worn unevenly — favors the right leg.",
                    uvFinding: "Trace algae streaks: roof-garden moss, not street grit.",
                    labFinding: "Moss strain matches the cultivar planted on this building's roof — only.",
                    forensicVerdict: .strong,
                    forensicNote: "Puts the suspect on the roof, not the lobby. The bench likes physical placement."
                ),
                surfaceIcon: "window.shade.open",
                surfaceLabel: "THE OPEN WINDOW",
                judgeLine: "Roof-garden moss on the boot. They were on the roof. The bench accepts."
            ),
            Evidence(
                id: "ev-001-receipt",
                type: .receipt,
                name: "Coffee Receipt",
                description: "From a cafe two blocks away. Dated three days ago. Probably the maid's.",
                isIncriminating: false,
                normalizedX: 0.18,
                normalizedY: 0.32,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard thermal print. Folded twice. Pocketed for a while.",
                    uvFinding: "No fluorescence. Nothing hidden.",
                    labFinding: "Handled by at least four people. Ink and paper unremarkable.",
                    forensicVerdict: .weak,
                    forensicNote: "Predates the incident by three days. Doesn't tie anyone to the safe. Probably the maid's."
                ),
                surfaceIcon: "door.left.hand.open",
                surfaceLabel: "THE FRONT DOORMAT",
                judgeLine: "Three days stale. Has nothing to do with the events of that morning."
            ),
            Evidence(
                id: "ev-001-hair",
                type: .hair,
                name: "Long Hair Strand",
                description: "Auburn. Doesn't match the homeowner. Could be the cleaner — could be nothing.",
                isIncriminating: false,
                normalizedX: 0.82,
                normalizedY: 0.20,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "18 cm. Cuticle intact — fell out, wasn't pulled.",
                    uvFinding: "Mild bleach residue. Recently dyed.",
                    labFinding: "DNA does not match the homeowner, the suspect, or any cleaning-staff sample on file.",
                    forensicVerdict: .inconclusive,
                    forensicNote: "Real hair, real person — but no link to the safe or the rooftop. Submitting this is a coin flip."
                ),
                surfaceIcon: "bed.double.fill",
                surfaceLabel: "THE BEDROOM PILLOW",
                judgeLine: "A hair from someone — but who? You haven't shown us. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 320,
        fineOnLoss: 120,
        unlockCost: 0,
        requiresCaseId: nil,
        truth: [
            "The doorman left his post for a smoke at 2:08 AM. The Shadow timed it.",
            "They climbed the fire escape on the east side, crossed the rooftop garden, and descended through the open window.",
            "They worked the safe with a cutter and patience, leaving a thumbprint on the dial.",
            "The torn note in the trash, written hours earlier, named the time and the tool. The boot print on the sill traced the moss back to the roof.",
            "By 2:30 AM, they were gone. The penthouse was empty for fifteen minutes before anyone noticed."
        ],
        suspectReveal: "The bench finds your suspect — \"The Shadow\" — guilty of grand larceny."
    )

    // MARK: - Case 2 · The Closing Shift (rookie, requires Rooftop)

    static let closingShift = CrimeCase(
        id: "case-001b-diner",
        title: "The Closing Shift",
        blurb: "11:47 PM. Sal's till is empty, the cook saw nothing, and the deep fryer is still warm. Whoever did this stayed for a slice of pie.",
        location: "Sal's All-Night Diner · Riverside",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Patron",
            profileSilhouette: "person.fill.questionmark",
            known: "Stayed for the pie. Took the till. Left the menu."
        ),
        sceneIcon: "fork.knife",
        sceneTint: [0.36, 0.10, 0.10],
        evidence: [
            Evidence(
                id: "ev-002-fingerprint",
                type: .fingerprint,
                name: "Greasy Fingerprint",
                description: "On the till's CASH-ENTER button. Whoever pressed it had cooking grease on their thumb.",
                isIncriminating: true,
                normalizedX: 0.68,
                normalizedY: 0.40,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb whorl. Grease pattern — burger oil, not fry oil. Not the cook's station.",
                    uvFinding: "Faint mustard streak — the suspect ate at the counter before the till was hit.",
                    labFinding: "Print matches a register of a parolee from a 2023 fast-food robbery. Within 50% confidence.",
                    forensicVerdict: .strong,
                    forensicNote: "The grease pattern places them in the dining room, not behind the counter. Bench will accept."
                ),
                surfaceIcon: "dollarsign.circle.fill",
                surfaceLabel: "THE TILL",
                judgeLine: "Burger grease on the till — they ate first, then stole. The bench is convinced."
            ),
            Evidence(
                id: "ev-002-receipt",
                type: .receipt,
                name: "Pie & Coffee Receipt",
                description: "Time-stamped 11:43 PM, paid in cash. Four minutes before the cashier was cracked over the head.",
                isIncriminating: true,
                normalizedX: 0.32,
                normalizedY: 0.55,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pie à la mode + coffee. Total $6.80. Folded once and dropped — not pocketed.",
                    uvFinding: "A handwritten phone number on the back of the receipt, in eyebrow pencil.",
                    labFinding: "Phone number traces to a payphone on Larkin & 9th — 800m from the diner.",
                    forensicVerdict: .strong,
                    forensicNote: "Places the suspect at a booth four minutes before the assault. Strong placement."
                ),
                surfaceIcon: "table.furniture.fill",
                surfaceLabel: "BOOTH 3",
                judgeLine: "11:43 PM. Four minutes before the assault. Indisputable timing."
            ),
            Evidence(
                id: "ev-002-note",
                type: .note,
                name: "Scribbled Menu",
                description: "A paper menu with three items underlined and the word \"till\" written in the margin.",
                isIncriminating: true,
                normalizedX: 0.50,
                normalizedY: 0.74,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Same eyebrow pencil as the receipt note. Underlined items: pie, coffee, milkshake.",
                    uvFinding: "An arrow drawn under UV light, pointing from \"milkshake\" to a small map of the counter area.",
                    labFinding: "Pencil residue on margin matches that of the same payphone call's note paper.",
                    forensicVerdict: .strong,
                    forensicNote: "A literal plan, in a literal margin. The bench will not need much convincing."
                ),
                surfaceIcon: "book.closed.fill",
                surfaceLabel: "ON THE TABLE",
                judgeLine: "The word \"till\" in the margin of a menu. Premeditation, in plain English."
            ),
            Evidence(
                id: "ev-002-footprint",
                type: .footprint,
                name: "Boot Scuff",
                description: "A black scuff mark by the back door. Could be from any kitchen worker hauling trash.",
                isIncriminating: false,
                normalizedX: 0.20,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Rubber sole, slip-resistant tread. Standard kitchen issue — boots that the cook owns.",
                    uvFinding: "Detergent residue. Recently mopped over.",
                    labFinding: "Soil sample matches the alley behind every restaurant on this block. Not distinctive.",
                    forensicVerdict: .weak,
                    forensicNote: "Doesn't tie to the suspect — just tells you someone took out the trash today."
                ),
                surfaceIcon: "door.right.hand.closed",
                surfaceLabel: "THE BACK DOOR",
                judgeLine: "The cook's boots. The cook is not on trial today."
            ),
            Evidence(
                id: "ev-002-hair",
                type: .hair,
                name: "Long Hair on Stool",
                description: "Bleach-blonde. The cashier's a brunette. Could be a customer from earlier.",
                isIncriminating: false,
                normalizedX: 0.82,
                normalizedY: 0.62,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "22 cm. Heavily processed. Looks like extensions, not natural hair.",
                    uvFinding: "Strong bleach residue. Recently treated.",
                    labFinding: "DNA traces to a regular customer, Mrs. Greene — comes in for the late-shift cobbler. No criminal record.",
                    forensicVerdict: .weak,
                    forensicNote: "Identified, harmless, regular. Not your suspect."
                ),
                surfaceIcon: "seal.fill",
                surfaceLabel: "STOOL #2",
                judgeLine: "Mrs. Greene, the regular. The bench is fond of Mrs. Greene. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 420,
        fineOnLoss: 160,
        unlockCost: 0,
        requiresCaseId: "case-001-rooftop",
        truth: [
            "At 11:30 PM, The Patron walked in and took booth 3. They ordered pie and coffee, paid in cash at 11:43.",
            "While they sat, they scribbled a plan in the margin of the menu — what to order, where the till was, when to move.",
            "At 11:47, with only the cashier left in the dining room, they walked to the counter and pressed CASH-ENTER with a greasy thumb.",
            "The cashier turned. The Patron clipped him on the head — once, controlled — and emptied the till in under thirty seconds.",
            "They walked out the front door, not the back. Their pie was still warm on the table."
        ],
        suspectReveal: "The bench finds your suspect — \"The Patron\" — guilty of armed robbery."
    )

    // MARK: - Case 3 · The Greenhouse Theft (rookie, requires Diner)

    static let greenhouseTheft = CrimeCase(
        id: "case-001c-greenhouse",
        title: "The Greenhouse Theft",
        blurb: "A rare ghost orchid, cut at 4:23 AM. The dog never barked. The motion lights never tripped. Either the thief flew in — or they had a key.",
        location: "Pemberton Estate · Hillside",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Gardener",
            profileSilhouette: "person.fill.questionmark",
            known: "Knew the locks. Knew the dog. Knew the orchid."
        ),
        sceneIcon: "leaf.fill",
        sceneTint: [0.12, 0.30, 0.18],
        evidence: [
            Evidence(
                id: "ev-003-weapon",
                type: .weapon,
                name: "Pruning Shears",
                description: "High-end Japanese steel, freshly chipped on the upper blade. Left on the potting bench.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.42,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "The chip is fresh. There's a green flake on the blade — orchid stem matter.",
                    uvFinding: "Orchid sap fluoresces. Cut was made within the past 6 hours.",
                    labFinding: "Brand: Tobisho. Sold at exactly two shops in the city. The estate doesn't own a pair.",
                    forensicVerdict: .strong,
                    forensicNote: "Murder weapon, basically. The bench does not love a thief who brings their own scissors."
                ),
                surfaceIcon: "wrench.adjustable.fill",
                surfaceLabel: "THE POTTING BENCH",
                judgeLine: "They brought their own shears. The chip matches the orchid. The bench accepts."
            ),
            Evidence(
                id: "ev-003-footprint",
                type: .footprint,
                name: "Boot Print in Mud",
                description: "Deep, near the orchid display. Not the gardener's tread — too narrow.",
                isIncriminating: true,
                normalizedX: 0.62,
                normalizedY: 0.72,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Hiking boot, women's size 8. Tread depth suggests carrying ~10kg of weight.",
                    uvFinding: "Phosphate fertilizer trace — only used in the rare-orchid section.",
                    labFinding: "Soil sample contains a perlite blend the estate stopped buying in 2022.",
                    forensicVerdict: .strong,
                    forensicNote: "This person knew which row to walk to. That's not a casual thief."
                ),
                surfaceIcon: "leaf.circle.fill",
                surfaceLabel: "THE ORCHID BED",
                judgeLine: "They walked straight to the rare-orchid row. They knew where to go."
            ),
            Evidence(
                id: "ev-003-fingerprint",
                type: .fingerprint,
                name: "Glass Door Print",
                description: "On the inside of the greenhouse glass. The door was unlocked from within.",
                isIncriminating: true,
                normalizedX: 0.50,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Index finger, partial. Pressed firmly — pushing the door, not pulling.",
                    uvFinding: "Hand cream residue. The same brand sold at the local horticultural club shop.",
                    labFinding: "Print on file: matches a former greenhouse-volunteer fired in 2024 for stealing seedlings.",
                    forensicVerdict: .strong,
                    forensicNote: "Identifiable suspect. The case writes itself."
                ),
                surfaceIcon: "door.sliding.left.hand.closed",
                surfaceLabel: "THE GLASS DOOR",
                judgeLine: "Print matches a former volunteer with a history of seedling theft. Accepted."
            ),
            Evidence(
                id: "ev-003-bloodstain",
                type: .bloodstain,
                name: "Muddy Paw Print",
                description: "On the path. Big paw, fresh tracks. The estate dog, probably.",
                isIncriminating: false,
                normalizedX: 0.18,
                normalizedY: 0.65,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "German Shepherd-sized print. Matches photos of the estate's dog, Rex.",
                    uvFinding: "No biological traces beyond canine.",
                    labFinding: "Soil from the kennel area — Rex always walks this path at dawn.",
                    forensicVerdict: .weak,
                    forensicNote: "Not your suspect. The dog walks here every morning."
                ),
                surfaceIcon: "pawprint.fill",
                surfaceLabel: "THE GARDEN PATH",
                judgeLine: "Rex's tracks. Counsel will note that Rex is a very good boy. Discarded."
            ),
            Evidence(
                id: "ev-003-receipt",
                type: .receipt,
                name: "Contractor's Card",
                description: "A business card for an irrigation contractor. Crumpled, found by the door.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard 350-gsm matte stock. Phone number, no address. \"Curtis Irrigation.\"",
                    uvFinding: "No hidden ink.",
                    labFinding: "Curtis was on the property two days ago, signed in by the gatehouse. Alibi for last night confirmed.",
                    forensicVerdict: .weak,
                    forensicNote: "Real visit, real business, real alibi. Don't waste the bench's time on this one."
                ),
                surfaceIcon: "key.fill",
                surfaceLabel: "BY THE TOOL SHED",
                judgeLine: "Curtis has an alibi. The bench is unmoved by his business card."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 540,
        fineOnLoss: 200,
        unlockCost: 0,
        requiresCaseId: "case-001b-diner",
        truth: [
            "The Gardener was a volunteer at the estate until 2024 — fired for taking seedlings home.",
            "They knew the gate code. They knew the dog's morning walk. They knew which row held the ghost orchid.",
            "At 4:23 AM they entered through the side gate, pushed the glass greenhouse door from the inside, and crossed to the rare-orchid bed.",
            "They cut the orchid in three minutes flat with their own Tobisho shears, leaving a fresh chip on the blade.",
            "Rex, the German Shepherd, watched. He recognized the smell. He did not bark."
        ],
        suspectReveal: "The bench finds your suspect — \"The Gardener\" — guilty of grand theft."
    )

    // MARK: - Case 4 · The Empty Case (rookie, requires Greenhouse)

    static let pawnshopViolin = CrimeCase(
        id: "case-001d-pawnshop",
        title: "The Empty Case",
        blurb: "Karpov's Pawn closed at 9. By midnight the Stradivarius copy was gone — and only the velvet impression in the case remained.",
        location: "Karpov's Pawn · Old Quarter",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Bow",
            profileSilhouette: "person.fill.questionmark",
            known: "Walked the shop twice last week. Asked about the violin both times. Bought nothing."
        ),
        sceneIcon: "music.note.house.fill",
        sceneTint: [0.32, 0.18, 0.10],
        evidence: [
            Evidence(
                id: "ev-004-fingerprint",
                type: .fingerprint,
                name: "Velvet Print",
                description: "A clean thumbprint pressed into the case's velvet lining where the violin once sat.",
                isIncriminating: true,
                normalizedX: 0.46,
                normalizedY: 0.48,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb. Loop pattern, central scar across the ridge — distinctive.",
                    uvFinding: "Trace rosin dust under the print. Whoever pressed here had handled a bow recently.",
                    labFinding: "Print does not match Karpov, his son, or any cataloged staff. Outsider.",
                    forensicVerdict: .strong,
                    forensicNote: "Places someone with rosin on their hand inside the empty case. Bench will accept."
                ),
                surfaceIcon: "case.fill",
                surfaceLabel: "THE OPEN VIOLIN CASE",
                judgeLine: "Rosin on the thumb, thumb on the velvet. The bench is satisfied."
            ),
            Evidence(
                id: "ev-004-photograph",
                type: .photograph,
                name: "Counter Photo",
                description: "Polaroid Karpov's wife snapped Tuesday — a customer leaning over the counter, eyeing the violin.",
                isIncriminating: true,
                normalizedX: 0.22,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Subject's face is in three-quarter profile. Distinctive scar on the right thumb, visible on the counter glass.",
                    uvFinding: "Date stamp confirms Tuesday — three days before the theft.",
                    labFinding: "Photo paper from the wife's instant camera. Authentic, not staged.",
                    forensicVerdict: .strong,
                    forensicNote: "Identifies the suspect by sight three days before the theft. Pairs with the velvet print."
                ),
                surfaceIcon: "camera.fill",
                surfaceLabel: "BEHIND THE REGISTER",
                judgeLine: "A face on the counter, a print in the velvet — same scar, same hand."
            ),
            Evidence(
                id: "ev-004-footprint",
                type: .footprint,
                name: "Rosin Trail",
                description: "Pale dust footprints leading from the case to the back service door.",
                isIncriminating: true,
                normalizedX: 0.62,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 11 dress shoe, smooth leather sole. Rosin embedded in the heel groove.",
                    uvFinding: "Trail goes only one way: from the case to the door. Came in clean, left dusted.",
                    labFinding: "Rosin is a Hidersine variant — same brand the missing violin came packed with.",
                    forensicVerdict: .strong,
                    forensicNote: "The rosin only existed inside the case. Whoever left these prints opened it."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "THE BACK CORRIDOR",
                judgeLine: "Rosin from the case, walking out the back door. The bench follows the trail."
            ),
            Evidence(
                id: "ev-004-receipt",
                type: .receipt,
                name: "Old Pawn Ticket",
                description: "A faded ticket from a customer who redeemed a pocket watch six weeks ago. Found behind the counter.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.55,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Tear pattern shows it was filed and forgotten, not dropped.",
                    uvFinding: "Karpov's countersign in pencil — cleared months ago.",
                    labFinding: "Customer redeemed and left. No connection to the violin or the back room.",
                    forensicVerdict: .weak,
                    forensicNote: "Six weeks stale. A previous transaction, not this one."
                ),
                surfaceIcon: "tray.fill",
                surfaceLabel: "THE COUNTER FILING TRAY",
                judgeLine: "Old paperwork. Not the night in question. Discarded."
            ),
            Evidence(
                id: "ev-004-hair",
                type: .hair,
                name: "White Hair",
                description: "A single white strand on the felt cloth used to wipe down instruments. Probably Karpov's.",
                isIncriminating: false,
                normalizedX: 0.34,
                normalizedY: 0.66,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "16 cm. Fine, gray-white. Cuticle natural, not bleached.",
                    uvFinding: "No fluorescence. Nothing chemical.",
                    labFinding: "Likely match to a man over 60. Karpov is 71. Cleaning rag, daily contact.",
                    forensicVerdict: .inconclusive,
                    forensicNote: "Probably the shopkeeper's. Could be anyone over 60. Doesn't tie to the theft."
                ),
                surfaceIcon: "swatchpalette.fill",
                surfaceLabel: "THE POLISHING CLOTH",
                judgeLine: "An old man's hair on a polishing rag. Could be the owner. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 360,
        fineOnLoss: 140,
        unlockCost: 0,
        requiresCaseId: "case-001c-greenhouse",
        truth: [
            "The Bow had been a session player — talented, blacklisted after a forgery scandal in 2022.",
            "Karpov's wife photographed them on Tuesday. They came back Friday at 9:30, a half hour after closing.",
            "They picked the back door's lock with a luthier's pin tool, walked straight to the display case, and lifted the violin in under ninety seconds.",
            "Rosin from the case dusted their shoes on the way out. The thumbprint they left in the velvet matched the scar in the photograph.",
            "The violin showed up at a Vienna auction six months later, but only after the case was already closed."
        ],
        suspectReveal: "The bench finds your suspect — \"The Bow\" — guilty of grand larceny."
    )

    // MARK: - Case 5 · The Pre-Dawn Crust (rookie, requires Pawnshop)

    static let bakeryBreakIn = CrimeCase(
        id: "case-001e-bakery",
        title: "The Pre-Dawn Crust",
        blurb: "Rosario's bakery opens at 5 AM. At 4:11, someone was already inside the till. The dough was still proofing.",
        location: "Rosario's Bakery · Riverside",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Baker's Dozen",
            profileSilhouette: "person.fill.questionmark",
            known: "Knew the schedule. Knew the alarm. Took only what fit in a coat pocket."
        ),
        sceneIcon: "birthday.cake.fill",
        sceneTint: [0.36, 0.24, 0.12],
        evidence: [
            Evidence(
                id: "ev-005-footprint",
                type: .footprint,
                name: "Floured Boot Print",
                description: "A clear tread mark in spilled flour by the prep table.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.72,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 10 work boot. Vibram sole. Heel scuffed deeply on the right side.",
                    uvFinding: "Flour residue is fresh — laid down within the last six hours.",
                    labFinding: "Tread doesn't match Rosario or his two morning bakers. Outside boot.",
                    forensicVerdict: .strong,
                    forensicNote: "Puts an outsider in the kitchen during the theft window."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "THE PREP TABLE FLOOR",
                judgeLine: "Fresh flour, fresh print, no match to staff. The bench accepts."
            ),
            Evidence(
                id: "ev-005-fingerprint",
                type: .fingerprint,
                name: "Greasy Cash Print",
                description: "On the till's release lever — buttery smear of a fingerprint.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.42,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Index finger, left hand. Loop pattern. Greased — not yeast, not olive oil — butter.",
                    uvFinding: "No flour residue under the grease. They wiped their hands on a towel before touching the lever.",
                    labFinding: "Print runs against AFIS — partial hit on a 2023 night-shift theft at a corner deli.",
                    forensicVerdict: .strong,
                    forensicNote: "Buttered hand, deliberate technique, prior pattern. Bench will read this as routine."
                ),
                surfaceIcon: "dollarsign.circle.fill",
                surfaceLabel: "THE TILL LEVER",
                judgeLine: "Butter on the till. Same hand, again. The bench is convinced."
            ),
            Evidence(
                id: "ev-005-note",
                type: .note,
                name: "Torn Schedule",
                description: "A fragment of Rosario's posted weekly schedule, found near the back door.",
                isIncriminating: true,
                normalizedX: 0.14,
                normalizedY: 0.28,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Tear edge consistent with someone yanking it off the wall in haste.",
                    uvFinding: "Pencil circles around the 4 AM \"alarm reset\" notation.",
                    labFinding: "Paper stock matches the bakery's office printer. Was on the wall yesterday.",
                    forensicVerdict: .strong,
                    forensicNote: "Premeditation: they studied the alarm reset window before walking in."
                ),
                surfaceIcon: "calendar",
                surfaceLabel: "BY THE BACK DOOR",
                judgeLine: "Circled the alarm window. Knew exactly when to come. Hard to argue with."
            ),
            Evidence(
                id: "ev-005-receipt",
                type: .receipt,
                name: "Butter Delivery Slip",
                description: "Yesterday's invoice from the dairy. Forty pounds of butter, signed for at 6 AM.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.62,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard carbon-copy slip. Signed in Rosario's hand.",
                    uvFinding: "Nothing hidden.",
                    labFinding: "Routine business document. Predates the theft by twenty-two hours.",
                    forensicVerdict: .weak,
                    forensicNote: "Yesterday's deliveries don't speak to tonight's theft."
                ),
                surfaceIcon: "tray.fill",
                surfaceLabel: "THE INVOICE SPIKE",
                judgeLine: "Yesterday's butter. Not tonight's problem. Discarded."
            ),
            Evidence(
                id: "ev-005-hair",
                type: .hair,
                name: "Apron Hair",
                description: "Brown strand caught in the strap of an apron hanging by the prep counter.",
                isIncriminating: false,
                normalizedX: 0.50,
                normalizedY: 0.55,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "20 cm, brown. Cuticle intact.",
                    uvFinding: "No chemical residue.",
                    labFinding: "DNA matches one of Rosario's bakers — Mara, employed two years.",
                    forensicVerdict: .weak,
                    forensicNote: "Belongs to staff. Apron contact, not theft contact."
                ),
                surfaceIcon: "tshirt.fill",
                surfaceLabel: "THE PREP APRON HOOK",
                judgeLine: "Mara's hair on Mara's apron. Routine. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 370,
        fineOnLoss: 145,
        unlockCost: 0,
        requiresCaseId: "case-001d-pawnshop",
        truth: [
            "The Baker's Dozen had worked night-shift kitchens up and down the river for years. They knew the rhythm.",
            "They yanked Rosario's posted schedule off the wall a week earlier, circled the 4 AM alarm-reset gap, and put it back.",
            "At 4:09 AM Friday, they let themselves in through the back service door with a key copied from a hired-and-fired dishwasher.",
            "They went straight for the till, leaving a buttered fingerprint on the release lever and a flour print by the prep table.",
            "By 4:24 they were gone with $812 in mixed bills. The dough rose unattended for another half hour."
        ],
        suspectReveal: "The bench finds your suspect — \"The Baker's Dozen\" — guilty of burglary."
    )

    // MARK: - Case 6 · A Missing First (rookie, requires Bakery)

    static let bookshopFirstEdition = CrimeCase(
        id: "case-001f-bookshop",
        title: "A Missing First",
        blurb: "Hawthorne Books closed Sunday. Monday morning, the locked rare-shelf case held everything but the 1929 first edition.",
        location: "Hawthorne Books · West End",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Reader",
            profileSilhouette: "person.fill.questionmark",
            known: "Browsed every Saturday for a month. Always asked about the same shelf."
        ),
        sceneIcon: "books.vertical.fill",
        sceneTint: [0.20, 0.14, 0.30],
        evidence: [
            Evidence(
                id: "ev-006-photograph",
                type: .photograph,
                name: "CCTV Still",
                description: "A printed frame from the shop's overhead camera, time-stamped Saturday at 5:47 PM.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.34,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Subject in trench coat, gloved, kneeling at the rare-books case. Distinctive lapel pin.",
                    uvFinding: "Time stamp authenticates — frame is genuine, not edited.",
                    labFinding: "Lapel pin is a Bibliographical Society of America badge. Membership is searchable.",
                    forensicVerdict: .strong,
                    forensicNote: "Places a specific person at the case during open hours, casing it."
                ),
                surfaceIcon: "video.fill",
                surfaceLabel: "THE OVERHEAD CAMERA",
                judgeLine: "A pin, a face, a date. The bench accepts."
            ),
            Evidence(
                id: "ev-006-note",
                type: .note,
                name: "Margin Note",
                description: "A scrap left inside an unrelated book on the rare shelf — a pencil number, \"PN6071.A4\".",
                isIncriminating: true,
                normalizedX: 0.62,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil, sharp 2H lead, written quickly. Standard library call number.",
                    uvFinding: "A second number erased beneath: \"1929 1st\" — the missing book's catalog identifier.",
                    labFinding: "Paper torn from a Moleskine pocket notebook. Not Hawthorne stock.",
                    forensicVerdict: .strong,
                    forensicNote: "Confirms the suspect specifically targeted the 1929 first edition, not a random grab."
                ),
                surfaceIcon: "book.fill",
                surfaceLabel: "TUCKED IN A NEARBY BOOK",
                judgeLine: "They wrote the call number down. Targeted theft, not opportunity. Accepted."
            ),
            Evidence(
                id: "ev-006-fingerprint",
                type: .fingerprint,
                name: "Glass Print",
                description: "Smudged thumbprint on the inside of the rare-shelf case, where the 1929 sat.",
                isIncriminating: true,
                normalizedX: 0.50,
                normalizedY: 0.62,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb, arched pattern. Smudge consistent with a glove being briefly removed.",
                    uvFinding: "Trace acid-free archival glove powder. Specialist's habit.",
                    labFinding: "AFIS hit: 79% match to a Bibliographical Society member with a 2021 stolen-book misdemeanor.",
                    forensicVerdict: .strong,
                    forensicNote: "The lapel pin in the photo and this fingerprint point to the same person."
                ),
                surfaceIcon: "lock.shield.fill",
                surfaceLabel: "THE RARE-SHELF CASE",
                judgeLine: "Inside the locked case. The bench accepts."
            ),
            Evidence(
                id: "ev-006-receipt",
                type: .receipt,
                name: "Café Receipt",
                description: "From the coffee shop across the street. Paid Sunday morning at 9:14.",
                isIncriminating: false,
                normalizedX: 0.16,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard thermal print. Cappuccino, scone, paid in cash.",
                    uvFinding: "No fluorescence.",
                    labFinding: "Sunday morning — twelve hours after the Saturday-night theft window.",
                    forensicVerdict: .weak,
                    forensicNote: "Wrong day, wrong time. Doesn't connect to the rare shelf."
                ),
                surfaceIcon: "cup.and.saucer.fill",
                surfaceLabel: "ON THE FRONT MAT",
                judgeLine: "Sunday's coffee. Not Saturday's theft. Discarded."
            ),
            Evidence(
                id: "ev-006-hair",
                type: .hair,
                name: "Lock Hair",
                description: "Single dark hair caught in the rare-shelf case lock.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.40,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Short, 4 cm, dark brown. Possibly a beard hair.",
                    uvFinding: "No chemical residue.",
                    labFinding: "DNA matches Hawthorne — the shop owner who unlocks the case daily.",
                    forensicVerdict: .weak,
                    forensicNote: "The owner unlocks this case every day. Routine contact."
                ),
                surfaceIcon: "lock.fill",
                surfaceLabel: "THE LOCK MECHANISM",
                judgeLine: "The owner's beard hair on the owner's lock. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 390,
        fineOnLoss: 155,
        unlockCost: 0,
        requiresCaseId: "case-001e-bakery",
        truth: [
            "The Reader was a Bibliographical Society member with a quiet sideline in moving stolen rarities.",
            "They cased Hawthorne for four straight Saturdays, always lingering at the rare-books shelf.",
            "On the fifth Saturday they stayed past the lunch crowd, picked the case lock at 5:47 PM while the owner was on a cigarette break, and walked out with the 1929 first under their coat.",
            "They left the call number scrawled in pencil — a habit, not carelessness — and a thumbprint where the glove came off briefly.",
            "The book reappeared at a private auction in Geneva eleven months later. The pin in the photograph identified them on the second pass through the membership directory."
        ],
        suspectReveal: "The bench finds your suspect — \"The Reader\" — guilty of grand larceny."
    )

    // MARK: - Case 7 · The Cut Pattern (rookie, requires Bookshop)

    static let tailorSilkBolt = CrimeCase(
        id: "case-001g-tailor",
        title: "The Cut Pattern",
        blurb: "Berenger & Sons keeps a single bolt of midnight silk for one client a year. Tonight's cutting was set for Tuesday. The bolt is gone.",
        location: "Berenger & Sons Tailors · Garment District",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Mannequin",
            profileSilhouette: "person.fill.questionmark",
            known: "Came in for measurements once. Cancelled the order. Never paid the deposit."
        ),
        sceneIcon: "tshirt.fill",
        sceneTint: [0.10, 0.12, 0.30],
        evidence: [
            Evidence(
                id: "ev-007-fingerprint",
                type: .fingerprint,
                name: "Chalk-Dust Print",
                description: "On the cutting table's brass measuring rule, partly buried in tailor's chalk.",
                isIncriminating: true,
                normalizedX: 0.40,
                normalizedY: 0.46,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right index, whorl pattern. Chalk preserved the print like a cast.",
                    uvFinding: "Chalk fluoresces blue under UV — only one print, dead center on the rule.",
                    labFinding: "Print does not match the Berengers, father or son. Outside hand.",
                    forensicVerdict: .strong,
                    forensicNote: "The cutting table is a tailor's altar — outsiders don't end up there by accident."
                ),
                surfaceIcon: "ruler.fill",
                surfaceLabel: "THE CUTTING TABLE RULE",
                judgeLine: "Chalk preserved a clean print. Outsider on the master's table. Accepted."
            ),
            Evidence(
                id: "ev-007-note",
                type: .note,
                name: "Pattern Margin",
                description: "A pattern book on the side table, with measurements scribbled in margin that match no client on file.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil, 4B lead — soft. Measurements written hurriedly.",
                    uvFinding: "Sketch of a coat lining underneath, erased — same coat the missing silk was meant to line.",
                    labFinding: "Measurements correspond to a man 6'1\", 38\" chest. Berenger's books have no such client.",
                    forensicVerdict: .strong,
                    forensicNote: "They were planning the suit they would have made. Premeditation, dressed up as research."
                ),
                surfaceIcon: "book.pages.fill",
                surfaceLabel: "THE PATTERN BOOK",
                judgeLine: "Their own measurements in the master's book. Brazen. Accepted."
            ),
            Evidence(
                id: "ev-007-footprint",
                type: .footprint,
                name: "Chalk Sole",
                description: "Faint chalk-dust print across the workshop floor, leading toward the bolt rack.",
                isIncriminating: true,
                normalizedX: 0.24,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 12 dress shoe. Smooth leather sole, narrow toe. A gentleman's shoe.",
                    uvFinding: "Chalk picks up cleanly under UV: the trail crosses the cutting room and stops at the silk rack.",
                    labFinding: "Sole pattern matches a Crockett & Jones model sold only at a single shop on Sloane Street.",
                    forensicVerdict: .strong,
                    forensicNote: "Tracks the suspect from the table to the missing bolt, in chalk."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "THE WORKSHOP FLOOR",
                judgeLine: "Chalk under their soles, leading right to the missing bolt. Accepted."
            ),
            Evidence(
                id: "ev-007-hair",
                type: .hair,
                name: "Suit Lapel Hair",
                description: "Long blonde strand on the sleeve of a finished suit awaiting Friday pickup.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.52,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "30 cm, blonde, bleached at the tip.",
                    uvFinding: "Hair-product residue.",
                    labFinding: "Doesn't match the suit's owner (a man) — likely his wife at fitting last week.",
                    forensicVerdict: .weak,
                    forensicNote: "Wife's hair on her husband's suit. Routine fitting contact."
                ),
                surfaceIcon: "person.fill",
                surfaceLabel: "THE PICKUP RACK",
                judgeLine: "His wife's hair on his suit. Domestic, not criminal. Discarded."
            ),
            Evidence(
                id: "ev-007-receipt",
                type: .receipt,
                name: "Ribbon Order",
                description: "An invoice for buttonhole ribbon, dated last week. Filed neatly behind the counter.",
                isIncriminating: false,
                normalizedX: 0.50,
                normalizedY: 0.72,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Routine supply order. Two yards of black silk ribbon.",
                    uvFinding: "Nothing hidden.",
                    labFinding: "Ordinary business document. Pre-dates the theft by six days.",
                    forensicVerdict: .weak,
                    forensicNote: "Tailoring supplies. Doesn't speak to the missing bolt."
                ),
                surfaceIcon: "tray.fill",
                surfaceLabel: "THE INVOICE FILE",
                judgeLine: "An old supply order. Nothing to do with the silk. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 400,
        fineOnLoss: 160,
        unlockCost: 0,
        requiresCaseId: "case-001f-bookshop",
        truth: [
            "The Mannequin was a Mayfair junior partner with the right shoes and the wrong wallet.",
            "They booked a fitting in October, took their measurements, and cancelled the deposit.",
            "Three months later, on a Sunday night, they slipped in through the rear courtyard with a copied key from a fired apprentice.",
            "They studied the master's pattern book, sketched their own coat lining in pencil, and then walked the bolt of midnight silk out under their own coat.",
            "The chalk on their dress shoes drew a clean line from the cutting table to the rack — and back to them, when the bench tied the print to the man who'd cancelled his deposit."
        ],
        suspectReveal: "The bench finds your suspect — \"The Mannequin\" — guilty of burglary and grand larceny."
    )

    // MARK: - Case 8 · Tilt (rookie, requires Tailor)

    static let arcadeCoinPusher = CrimeCase(
        id: "case-001h-arcade",
        title: "Tilt",
        blurb: "The lights at Sparky's flickered for forty seconds at 1:14 AM. By the time the breakers reset, the coin-pusher cabinet was half its weight.",
        location: "Sparky's Arcade · Boardwalk",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Player",
            profileSilhouette: "person.fill.questionmark",
            known: "Hung around the arcade after closing twice last month. Owner shooed them off."
        ),
        sceneIcon: "gamecontroller.fill",
        sceneTint: [0.40, 0.14, 0.40],
        evidence: [
            Evidence(
                id: "ev-008-footprint",
                type: .footprint,
                name: "Sneaker Print",
                description: "Tread mark behind the breaker panel access door, in dust kicked off a wire bundle.",
                isIncriminating: true,
                normalizedX: 0.18,
                normalizedY: 0.62,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 9 athletic sneaker. Distinctive star tread on the heel.",
                    uvFinding: "Dust trail leads from the breaker panel to the coin-pusher cabinet.",
                    labFinding: "Tread matches a model sold only at one shop on the boardwalk.",
                    forensicVerdict: .strong,
                    forensicNote: "Behind the breaker panel during a forty-second outage. Not coincidence."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "BEHIND THE BREAKER PANEL",
                judgeLine: "They were behind the breakers when the lights went out. Accepted."
            ),
            Evidence(
                id: "ev-008-fingerprint",
                type: .fingerprint,
                name: "Mains Print",
                description: "Greasy print on the main breaker switch, found by an electrician at 8 AM.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.40,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right index. Whorl pattern. Grease pattern matches funnel-cake oil from the boardwalk.",
                    uvFinding: "Single press — they flipped the breaker once, deliberately.",
                    labFinding: "Print is fresh, laid down within twelve hours.",
                    forensicVerdict: .strong,
                    forensicNote: "Whoever caused the outage left their print on the switch. Direct cause."
                ),
                surfaceIcon: "powerplug.fill",
                surfaceLabel: "THE MAIN BREAKER",
                judgeLine: "Their print on the switch that killed the lights. Accepted."
            ),
            Evidence(
                id: "ev-008-photograph",
                type: .photograph,
                name: "Inside the Cabinet",
                description: "A Polaroid found taped inside the coin-pusher cabinet — a hand on the lever, mid-pour.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Hand has a wristwatch with a unique starfish-shaped face. Distinctive.",
                    uvFinding: "Photo printed on Polaroid 600 stock — same camera the suspect was seen carrying last month.",
                    labFinding: "Background includes the cabinet's interior schematic, taped to the back wall — visible only when the cabinet is opened.",
                    forensicVerdict: .strong,
                    forensicNote: "A trophy shot, probably for their own bragging rights. Identifies the watch."
                ),
                surfaceIcon: "camera.fill",
                surfaceLabel: "TAPED INSIDE THE CABINET",
                judgeLine: "They photographed themselves in the act. The bench finds it persuasive."
            ),
            Evidence(
                id: "ev-008-receipt",
                type: .receipt,
                name: "Token Receipt",
                description: "Yesterday afternoon's token purchase — $20 in arcade tokens, paid by a kid in a baseball cap.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.74,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard token-machine slip. 80 tokens.",
                    uvFinding: "No fluorescence.",
                    labFinding: "Patron paid cash, played for two hours, left at 7 PM. Long before the outage.",
                    forensicVerdict: .weak,
                    forensicNote: "An afternoon patron. Wrong window."
                ),
                surfaceIcon: "ticket.fill",
                surfaceLabel: "BY THE TOKEN MACHINE",
                judgeLine: "An afternoon player. Wrong night. Discarded."
            ),
            Evidence(
                id: "ev-008-hair",
                type: .hair,
                name: "Claw Machine Hair",
                description: "A tuft of fine hair caught on the joystick of the claw machine.",
                isIncriminating: false,
                normalizedX: 0.50,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Short, fine, blonde. Child's hair.",
                    uvFinding: "Trace cotton-candy residue.",
                    labFinding: "Sticky-fingered nine-year-old, by the look of it. Doesn't connect to the cabinet.",
                    forensicVerdict: .weak,
                    forensicNote: "A child's hair on the claw machine. Routine arcade contact."
                ),
                surfaceIcon: "figure.child",
                surfaceLabel: "THE CLAW MACHINE",
                judgeLine: "A child played the claw machine. Not our suspect. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 410,
        fineOnLoss: 165,
        unlockCost: 0,
        requiresCaseId: "case-001g-tailor",
        truth: [
            "The Player had been kicked out of Sparky's twice for trying to lever open the coin-pusher cabinet.",
            "They came back at 1 AM with a flashlight and a screwdriver, slipped in through the broken side window the owner had been meaning to fix.",
            "They flipped the main breaker — forty seconds, no security cameras — and used the dark to crack the cabinet.",
            "Their funnel-cake-greased finger left a print on the breaker. Their starfish-watch hand made it into a Polaroid they couldn't resist.",
            "By the time the lights came back on, they were two cabinets lighter and gone."
        ],
        suspectReveal: "The bench finds your suspect — \"The Player\" — guilty of burglary."
    )

    // MARK: - Case 9 · Hothouse (rookie, requires Arcade)

    static let flowershopOrchid = CrimeCase(
        id: "case-001i-flowershop",
        title: "Hothouse",
        blurb: "La Belle Fleur kept one rare orchid in the cooler for the Saturday wedding. The cooler is open. The orchid isn't there.",
        location: "La Belle Fleur · Garden District",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Florist",
            profileSilhouette: "person.fill.questionmark",
            known: "Worked here last spring. Was let go after the till came up short two Fridays in a row."
        ),
        sceneIcon: "leaf.fill",
        sceneTint: [0.10, 0.36, 0.20],
        evidence: [
            Evidence(
                id: "ev-009-footprint",
                type: .footprint,
                name: "Soil Print",
                description: "Damp soil tracked on the cooler floor — a clear partial boot print.",
                isIncriminating: true,
                normalizedX: 0.40,
                normalizedY: 0.74,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 8 women's hiking boot. Aggressive lug tread.",
                    uvFinding: "Soil contains potassium dust — this shop's specific fertilizer blend.",
                    labFinding: "Whoever stepped here had been in the back potting room first.",
                    forensicVerdict: .strong,
                    forensicNote: "Connects the back room to the cooler. Insider knowledge."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "THE COOLER FLOOR",
                judgeLine: "Their soil, their cooler, their print. Accepted."
            ),
            Evidence(
                id: "ev-009-note",
                type: .note,
                name: "Delivery Slip",
                description: "An old delivery slip on the back room desk, with a name and address scrawled in pencil.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.34,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil, freshly sharpened. Address is for a private collector who buys rare orchids cash-only.",
                    uvFinding: "Underneath the address, an erased phone number — a 503 area code.",
                    labFinding: "Handwriting matches the former employee's signature on file from her hire paperwork.",
                    forensicVerdict: .strong,
                    forensicNote: "Buyer lined up before the theft. Premeditation, with the writer's hand on file."
                ),
                surfaceIcon: "doc.text.fill",
                surfaceLabel: "THE BACK-ROOM DESK",
                judgeLine: "Buyer named, in their own handwriting. Accepted."
            ),
            Evidence(
                id: "ev-009-fingerprint",
                type: .fingerprint,
                name: "Cooler Glass",
                description: "Smudged thumbprint on the cooler door's interior pull-handle.",
                isIncriminating: true,
                normalizedX: 0.28,
                normalizedY: 0.42,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb, loop pattern. Pulled hard from the inside — they were leaving.",
                    uvFinding: "Trace orchid pollen on the print. The exact orchid that's missing.",
                    labFinding: "Print matches the former employee's prints on file from her hire paperwork.",
                    forensicVerdict: .strong,
                    forensicNote: "Inside the cooler, with the missing orchid's pollen on her thumb."
                ),
                surfaceIcon: "snowflake",
                surfaceLabel: "THE COOLER PULL-HANDLE",
                judgeLine: "Pollen of the missing flower on the suspect's thumb. The bench is convinced."
            ),
            Evidence(
                id: "ev-009-hair",
                type: .hair,
                name: "Tropical Leaf Hair",
                description: "Hair caught on a wide leaf of the bird-of-paradise display — bleached blonde.",
                isIncriminating: false,
                normalizedX: 0.18,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "25 cm, bleached blonde.",
                    uvFinding: "Heavy dye residue.",
                    labFinding: "Matches the cleaner who comes in Wednesdays — she's been working here for years.",
                    forensicVerdict: .weak,
                    forensicNote: "The cleaner brushes against this display every week."
                ),
                surfaceIcon: "leaf.fill",
                surfaceLabel: "THE BIRD-OF-PARADISE DISPLAY",
                judgeLine: "The cleaner's hair on a plant the cleaner dusts. Discarded."
            ),
            Evidence(
                id: "ev-009-receipt",
                type: .receipt,
                name: "Wedding Order",
                description: "A receipt for the Saturday wedding's bouquet — picked up Friday morning, fully paid.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.62,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard order slip. Saturday wedding. Bride's bouquet, three centerpieces.",
                    uvFinding: "Nothing hidden.",
                    labFinding: "Customer in good standing. Picked up morning, theft happened evening.",
                    forensicVerdict: .weak,
                    forensicNote: "Innocent customer, wrong time of day."
                ),
                surfaceIcon: "scroll.fill",
                surfaceLabel: "THE COUNTER ORDER BOOK",
                judgeLine: "A morning pickup. Wrong window. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 420,
        fineOnLoss: 170,
        unlockCost: 0,
        requiresCaseId: "case-001h-arcade",
        truth: [
            "The Florist was let go in April for short tills. She kept her copy of the back-door key.",
            "She lined up a buyer in Portland — cash, no questions — for any rare orchid she could pull.",
            "Friday at 9 PM she came in through the alley, walked through the potting room (picking up fertilizer dust), and went straight to the cooler.",
            "The orchid's pollen settled on her thumb when she pulled the door closed behind her on the way out.",
            "She left her handwriting on the buyer's address on a delivery slip she meant to take with her — and didn't."
        ],
        suspectReveal: "The bench finds your suspect — \"The Florist\" — guilty of grand theft."
    )

    // MARK: - Case 10 · Spin Cycle (rookie, requires Flowershop)

    static let laundromatCoinBox = CrimeCase(
        id: "case-001j-laundromat",
        title: "Spin Cycle",
        blurb: "Wishy Washy runs 24 hours. At 3:08 AM the cameras failed for nine minutes. The coin box was pried clean.",
        location: "Wishy Washy Laundromat · East Side",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Quarter",
            profileSilhouette: "person.fill.questionmark",
            known: "Hung around the laundromat without doing laundry. Three times this week."
        ),
        sceneIcon: "washer.fill",
        sceneTint: [0.20, 0.30, 0.40],
        evidence: [
            Evidence(
                id: "ev-010-footprint",
                type: .footprint,
                name: "Detergent Print",
                description: "Powdered detergent spilled near the coin box, with a clear footprint pressed into it.",
                isIncriminating: true,
                normalizedX: 0.38,
                normalizedY: 0.72,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 11 work boot. Heel logo: 'Carhartt'.",
                    uvFinding: "Detergent fluoresces — the print is clean and complete.",
                    labFinding: "Tread doesn't match any of the regular customers cataloged on this week's cameras.",
                    forensicVerdict: .strong,
                    forensicNote: "Boot print in fresh-spilled detergent right at the coin box. Direct placement."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "BY THE COIN BOX",
                judgeLine: "Detergent took the print like wet cement. Accepted."
            ),
            Evidence(
                id: "ev-010-fingerprint",
                type: .fingerprint,
                name: "Pry Bar Print",
                description: "A small pry bar wedged behind the dryer, with a thumb-print on the grip.",
                isIncriminating: true,
                normalizedX: 0.62,
                normalizedY: 0.40,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb. Bent shaft consistent with a single hard pull on a stuck box lid.",
                    uvFinding: "Sweat residue — the bar was used recently.",
                    labFinding: "Print matches a partial from a 2024 vending-machine theft three blocks east.",
                    forensicVerdict: .strong,
                    forensicNote: "Same hand as a prior coin-box theft. Pattern."
                ),
                surfaceIcon: "wrench.fill",
                surfaceLabel: "BEHIND DRYER #4",
                judgeLine: "Their print, their pry bar, their pattern. Accepted."
            ),
            Evidence(
                id: "ev-010-weapon",
                type: .weapon,
                name: "Bent Pry Bar",
                description: "A 14-inch crowbar, bent slightly mid-shaft. Found wedged behind a dryer.",
                isIncriminating: true,
                normalizedX: 0.50,
                normalizedY: 0.56,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Steel, painted black. Bend is 32 degrees, mid-shaft — consistent with prying a stuck lid.",
                    uvFinding: "Paint scratches match the coin box's metal.",
                    labFinding: "Steel composition matches a bar sold at the boardwalk hardware store, two blocks away.",
                    forensicVerdict: .strong,
                    forensicNote: "The tool itself, with paint from the coin box on it."
                ),
                surfaceIcon: "wrench.adjustable.fill",
                surfaceLabel: "WEDGED BEHIND THE DRYER",
                judgeLine: "The tool, with paint from the box on it. Accepted."
            ),
            Evidence(
                id: "ev-010-receipt",
                type: .receipt,
                name: "Late-Night Detergent",
                description: "A receipt from the bodega next door — a small box of detergent, paid 2:14 AM.",
                isIncriminating: false,
                normalizedX: 0.16,
                normalizedY: 0.34,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard cash slip. One Tide pod box, $4.99.",
                    uvFinding: "No fluorescence.",
                    labFinding: "Customer was a Tuesday-night regular per the bodega's clerk.",
                    forensicVerdict: .weak,
                    forensicNote: "A real customer doing real laundry. Not our suspect."
                ),
                surfaceIcon: "scroll.fill",
                surfaceLabel: "ON A FOLDING TABLE",
                judgeLine: "A late-night patron, doing laundry. Not the thief. Discarded."
            ),
            Evidence(
                id: "ev-010-hair",
                type: .hair,
                name: "Sock Hair",
                description: "A short hair stuck to a stray sock left in dryer #7.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.22,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "5 cm, gray, fine.",
                    uvFinding: "Mild deodorant residue.",
                    labFinding: "Likely the sock owner's. Tuesday regular, late shift at the deli.",
                    forensicVerdict: .weak,
                    forensicNote: "A regular customer's hair on his own sock."
                ),
                surfaceIcon: "tshirt.fill",
                surfaceLabel: "DRYER #7",
                judgeLine: "A regular's sock hair. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 430,
        fineOnLoss: 175,
        unlockCost: 0,
        requiresCaseId: "case-001i-flowershop",
        truth: [
            "The Quarter had hit two coin-pushers and a vending machine in this neighborhood already.",
            "They cased Wishy Washy by leaning on a folding table for forty minutes a night, three nights running, mapping the camera coverage.",
            "At 3:08 AM Thursday they spliced the camera feed — nine minutes of static — and worked the coin box with their pry bar.",
            "The lid was stuck. They pulled hard enough to bend the bar. Their thumb left a print on the grip and their boot left a tread in spilled detergent.",
            "They wedged the bar behind a dryer on the way out, expecting nobody would look. They were almost right."
        ],
        suspectReveal: "The bench finds your suspect — \"The Quarter\" — guilty of burglary."
    )

    // MARK: - Case 11 · B-Side (rookie, requires Laundromat)

    static let recordshopPressing = CrimeCase(
        id: "case-001k-recordshop",
        title: "B-Side",
        blurb: "Vinyl Underground keeps a signed pressing of a 1971 record under glass. Closing tonight: still there. Opening tomorrow: gone.",
        location: "Vinyl Underground · Lower East Side",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Collector",
            profileSilhouette: "person.fill.questionmark",
            known: "Made an offer twice. Came back a third time without offering."
        ),
        sceneIcon: "music.note.list",
        sceneTint: [0.30, 0.20, 0.10],
        evidence: [
            Evidence(
                id: "ev-011-photograph",
                type: .photograph,
                name: "Camera Frame",
                description: "Security footage still — overhead, 11:42 PM. A figure at the display case.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.34,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Subject in a leather jacket. Distinctive band patch on the back: an obscure Australian psych group.",
                    uvFinding: "Time-stamp authentic. Frame is unedited.",
                    labFinding: "The same band patch appeared on the suspect during their two prior visits.",
                    forensicVerdict: .strong,
                    forensicNote: "Same patch as the regular collector. Pattern of presence."
                ),
                surfaceIcon: "video.fill",
                surfaceLabel: "OVERHEAD CAMERA",
                judgeLine: "Same patch, same patron, same case. Accepted."
            ),
            Evidence(
                id: "ev-011-fingerprint",
                type: .fingerprint,
                name: "Empty Sleeve",
                description: "The record's empty paper sleeve, found on the counter — with a thumbprint on the cardboard.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb. Whorl. Pressed firmly against the cardboard — not casual handling.",
                    uvFinding: "Trace acetate residue from the missing record's plastic inner sleeve.",
                    labFinding: "Print matches a partial from a 2022 estate-sale theft of a signed pressing.",
                    forensicVerdict: .strong,
                    forensicNote: "Same thumb, same kind of theft, two years apart."
                ),
                surfaceIcon: "music.note",
                surfaceLabel: "ON THE COUNTER",
                judgeLine: "Two stolen pressings, two years apart, one thumb. Accepted."
            ),
            Evidence(
                id: "ev-011-note",
                type: .note,
                name: "Door Slip",
                description: "A torn note slid under the front door three days before the theft.",
                isIncriminating: true,
                normalizedX: 0.18,
                normalizedY: 0.66,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil, hurried. \"If you don't sell it, I'll take it. Last offer.\"",
                    uvFinding: "Pencil pressure pattern matches the note left at the prior 2022 estate-sale theft.",
                    labFinding: "Paper torn from a Field Notes reporter's pad — specific, traceable.",
                    forensicVerdict: .strong,
                    forensicNote: "Threat in writing, with paper traceable to a small batch of a brand. Connects the dots."
                ),
                surfaceIcon: "envelope.fill",
                surfaceLabel: "INSIDE THE FRONT DOOR",
                judgeLine: "They threatened in writing, then followed through. Accepted."
            ),
            Evidence(
                id: "ev-011-hair",
                type: .hair,
                name: "Booth Hair",
                description: "Hair caught in the velvet curtain of the listening booth — long, blonde, dyed.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.42,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "30 cm, bleached blonde.",
                    uvFinding: "Heavy bleach residue.",
                    labFinding: "Doesn't match the suspect (the camera shows a man with short brown hair).",
                    forensicVerdict: .weak,
                    forensicNote: "Different person, different shift. Probably an afternoon listener."
                ),
                surfaceIcon: "headphones",
                surfaceLabel: "THE LISTENING BOOTH",
                judgeLine: "Wrong head of hair entirely. Discarded."
            ),
            Evidence(
                id: "ev-011-receipt",
                type: .receipt,
                name: "Other Customer Slip",
                description: "A receipt for an unrelated $15 7-inch single — paid earlier the same evening.",
                isIncriminating: false,
                normalizedX: 0.50,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard register slip. One 7\" single, $15.",
                    uvFinding: "Nothing hidden.",
                    labFinding: "Cash customer. Bought, browsed, left at 7 PM. Hours before the theft.",
                    forensicVerdict: .weak,
                    forensicNote: "An evening customer. Wrong window."
                ),
                surfaceIcon: "scroll.fill",
                surfaceLabel: "THE COUNTER FILE",
                judgeLine: "A 7 PM customer. Theft was at 11:42. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 440,
        fineOnLoss: 180,
        unlockCost: 0,
        requiresCaseId: "case-001j-laundromat",
        truth: [
            "The Collector had a documented obsession with this exact pressing — they'd offered cash, then a trade, then nothing.",
            "Three days before the theft they slid a threatening note under the door — same pencil pressure as a 2022 note tied to an estate-sale theft.",
            "They came in at 11:42 PM as the owner was closing up, casually distracted him with a question about a 1968 Argentinian psych record, and walked out the moment his back was turned.",
            "They left the empty paper sleeve on the counter — a deliberate flourish, with their thumbprint on it.",
            "The record showed up on a private message board four days later, listed as 'unverifiable provenance' for $12,000."
        ],
        suspectReveal: "The bench finds your suspect — \"The Collector\" — guilty of grand larceny."
    )

    // MARK: - Case 12 · Lottery (rookie, requires Recordshop)

    static let bodegaLottery = CrimeCase(
        id: "case-001l-bodega",
        title: "Lottery",
        blurb: "Padilla's bodega closes at 11. By 11:35 the lotto-ticket box was prying on the floor, rolls scattered, a fortune in printed numbers gone.",
        location: "Padilla's Bodega · Sunset Park",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Ticket",
            profileSilhouette: "person.fill.questionmark",
            known: "A regular. Played the same numbers every week. Lost every week."
        ),
        sceneIcon: "ticket.fill",
        sceneTint: [0.36, 0.16, 0.10],
        evidence: [
            Evidence(
                id: "ev-012-fingerprint",
                type: .fingerprint,
                name: "Till Print",
                description: "Print on the till's NO-SALE button, just inches from the empty lotto box.",
                isIncriminating: true,
                normalizedX: 0.40,
                normalizedY: 0.42,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right thumb. Loop pattern. Soda residue around the print.",
                    uvFinding: "The soda is grape — Padilla doesn't sell that brand. They brought it in.",
                    labFinding: "Print is fresh, laid down within four hours.",
                    forensicVerdict: .strong,
                    forensicNote: "Sticky soda from outside the store, on the till. Outsider in the wrong place."
                ),
                surfaceIcon: "dollarsign.circle.fill",
                surfaceLabel: "THE TILL",
                judgeLine: "Their soda, their thumb, the wrong button. Accepted."
            ),
            Evidence(
                id: "ev-012-footprint",
                type: .footprint,
                name: "Sticky Print",
                description: "Footprint in spilled grape soda, leading from the cooler to the lotto box.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.74,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 9 sneaker. Cheap rubber sole. Tread shows skateboard wear.",
                    uvFinding: "Soda fluoresces — print is recent and complete.",
                    labFinding: "Sneaker model is sold at every corner shoe store. Generic.",
                    forensicVerdict: .strong,
                    forensicNote: "Lays out the path from cooler to lotto box. The thief stopped to grab a soda first."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "THE COOLER AISLE",
                judgeLine: "Soda-print path from cooler to box. Accepted."
            ),
            Evidence(
                id: "ev-012-note",
                type: .note,
                name: "Crossed Numbers",
                description: "A torn lotto ticket in the trash with seven numbers, all crossed out in a neat hand.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.66,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Suspect's regular numbers — visible from Padilla's customer log of weekly tickets.",
                    uvFinding: "Pen pressure matches the suspect's signature on a check-cashing slip from last Tuesday.",
                    labFinding: "Same handwriting style across the crossed numbers and the bodega's customer log.",
                    forensicVerdict: .strong,
                    forensicNote: "They lost again this week. Crossed out their own numbers, then took it out on the box."
                ),
                surfaceIcon: "trash.fill",
                surfaceLabel: "THE TRASH BIN",
                judgeLine: "Their regular numbers, crossed out, then the box gone. Motive in their own hand."
            ),
            Evidence(
                id: "ev-012-receipt",
                type: .receipt,
                name: "Stranger's Slip",
                description: "A receipt for a sandwich and chips, paid by another customer at 10:45 PM.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.34,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Routine purchase. $7.50.",
                    uvFinding: "Nothing hidden.",
                    labFinding: "Customer is a regular per Padilla's recognition.",
                    forensicVerdict: .weak,
                    forensicNote: "A regular customer just before close. Not the thief."
                ),
                surfaceIcon: "scroll.fill",
                surfaceLabel: "ON THE COUNTER",
                judgeLine: "Pre-close patron. Wrong person. Discarded."
            ),
            Evidence(
                id: "ev-012-hair",
                type: .hair,
                name: "Gum Hair",
                description: "Short hair on a pack of gum on a low shelf near the counter.",
                isIncriminating: false,
                normalizedX: 0.18,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "10 cm, dark brown, fine.",
                    uvFinding: "No residue.",
                    labFinding: "Probably a passing customer who pawed at the gum and put it back.",
                    forensicVerdict: .weak,
                    forensicNote: "Random retail contact. Not connected to the lotto box."
                ),
                surfaceIcon: "cart.fill",
                surfaceLabel: "THE GUM SHELF",
                judgeLine: "A passerby's hair on a pack of gum. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 450,
        fineOnLoss: 185,
        unlockCost: 0,
        requiresCaseId: "case-001k-recordshop",
        truth: [
            "The Ticket had played the same seven numbers every week for two years. Never won. Stopped sleeping over it.",
            "Tuesday they came in at 11:25 PM with a grape soda, lost again on their weekly draw, and snapped.",
            "They watched Padilla disappear into the back to count the night's drawer, then pried the lotto-ticket box off the counter mounting in under thirty seconds.",
            "They tracked grape-soda footprints from the cooler to the box and back. Their thumb left soda residue on the till.",
            "The crumpled losing ticket in the trash was their last week's draw — crossed out in the same hand the bodega already had on file."
        ],
        suspectReveal: "The bench finds your suspect — \"The Ticket\" — guilty of burglary."
    )

    // MARK: - Case 13 · Last Heel (rookie, requires Bodega)

    static let cobblerGoldLeaf = CrimeCase(
        id: "case-001m-cobbler",
        title: "Last Heel",
        blurb: "Lasater's cobbler shop kept gold-leaf inlay tools and one finished oxford waiting for its owner. Both gone before sunrise.",
        location: "Lasater's Cobbler · Diamond District",
        difficulty: .rookie,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Patron",
            profileSilhouette: "person.fill.questionmark",
            known: "Came in once for a fitting. Cancelled. Never picked up the deposit refund."
        ),
        sceneIcon: "shoe.2.fill",
        sceneTint: [0.30, 0.22, 0.12],
        evidence: [
            Evidence(
                id: "ev-013-fingerprint",
                type: .fingerprint,
                name: "Bench Print",
                description: "On the leather punch handle on the workbench — pressed deep into wood-darkening sweat.",
                isIncriminating: true,
                normalizedX: 0.38,
                normalizedY: 0.46,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right index. Whorl pattern. Pressed hard — the punch was actively used, not just touched.",
                    uvFinding: "Trace gold-leaf flake on the print. The exact gold leaf taken from the supply drawer.",
                    labFinding: "Print does not match Lasater or his apprentice. Outside hand.",
                    forensicVerdict: .strong,
                    forensicNote: "Used the punch with the missing gold leaf on their finger. Direct."
                ),
                surfaceIcon: "hammer.fill",
                surfaceLabel: "THE LEATHER PUNCH",
                judgeLine: "Their finger, the missing gold leaf, the master's tool. Accepted."
            ),
            Evidence(
                id: "ev-013-footprint",
                type: .footprint,
                name: "Polish Print",
                description: "A clear print in spilled shoe polish near the finished-pair shelf.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.74,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Size 10 dress shoe, narrow last. Bespoke construction — uneven welt stitching.",
                    uvFinding: "Polish is fresh — laid down tonight.",
                    labFinding: "Welt stitching pattern matches the shop's own house style. They walked in wearing a Lasater pair.",
                    forensicVerdict: .strong,
                    forensicNote: "Wearing a Lasater shoe to rob a Lasater shop. Audacious. Identifiable."
                ),
                surfaceIcon: "shoeprints.fill",
                surfaceLabel: "THE FINISHED-PAIR SHELF",
                judgeLine: "Wearing the master's work to rob the master. Accepted."
            ),
            Evidence(
                id: "ev-013-note",
                type: .note,
                name: "False Order Ticket",
                description: "A handwritten ticket on the workbench reserving the missing oxford for a Tuesday pickup that doesn't exist.",
                isIncriminating: true,
                normalizedX: 0.18,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil, neat hand. \"Hold for Mr. Davies, Tuesday 4 PM.\"",
                    uvFinding: "Cancelled deposit-refund slip from three months ago is in the desk drawer — same hand, same pencil.",
                    labFinding: "Lasater has no client named Davies, present or past.",
                    forensicVerdict: .strong,
                    forensicNote: "Forged a hold ticket to cover the theft. Same handwriting as the cancelled deposit."
                ),
                surfaceIcon: "doc.text.fill",
                surfaceLabel: "THE WORKBENCH",
                judgeLine: "A fake order in their own hand. Accepted."
            ),
            Evidence(
                id: "ev-013-hair",
                type: .hair,
                name: "Curtain Hair",
                description: "Hair caught in the velvet curtain dividing the workshop from the front room.",
                isIncriminating: false,
                normalizedX: 0.50,
                normalizedY: 0.22,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "8 cm, gray.",
                    uvFinding: "No chemical residue.",
                    labFinding: "Matches Lasater's own hair sample on file.",
                    forensicVerdict: .weak,
                    forensicNote: "Master's own hair on his own curtain. Daily contact."
                ),
                surfaceIcon: "rectangle.split.2x1.fill",
                surfaceLabel: "THE WORKSHOP CURTAIN",
                judgeLine: "Master's hair on master's curtain. Discarded."
            ),
            Evidence(
                id: "ev-013-receipt",
                type: .receipt,
                name: "Leather Supplier",
                description: "Last month's invoice from a leather supplier in Naples.",
                isIncriminating: false,
                normalizedX: 0.78,
                normalizedY: 0.58,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Italian invoice. Twelve hides of black calf, paid via wire.",
                    uvFinding: "Nothing hidden.",
                    labFinding: "Routine business. Pre-dates the theft by a month.",
                    forensicVerdict: .weak,
                    forensicNote: "Foreign supplier, monthly transaction. Not material."
                ),
                surfaceIcon: "tray.fill",
                surfaceLabel: "THE INVOICE FILE",
                judgeLine: "Last month's leather. Not tonight's theft. Discarded."
            )
        ],
        minIncriminatingToWin: 2,
        reward: 460,
        fineOnLoss: 190,
        unlockCost: 0,
        requiresCaseId: "case-001l-bodega",
        truth: [
            "The Patron had ordered a custom oxford in October. They cancelled, never picked up the refund — but kept the bespoke shoes Lasater had already made for them.",
            "Three months later they came back at 4 AM with the master's last apprentice key, copied during the original fitting.",
            "They wrote a forged hold ticket — \"Mr. Davies, Tuesday 4 PM\" — in the same neat hand as their cancelled deposit slip, hoping it would buy a few days of confusion.",
            "They used the master's leather punch to extract the heel inlay screws on the finished oxford waiting on the shelf, picking up gold-leaf flake in the process.",
            "By 4:30 AM they were gone with the gold-leaf tools, the finished pair, and the audacity of having walked in wearing Lasater's own work."
        ],
        suspectReveal: "The bench finds your suspect — \"The Patron\" — guilty of burglary and grand larceny."
    )

    // MARK: - Locked teaser cases (chained progression)

    static let midnightHeist = CrimeCase(
        id: "case-002-midnight",
        title: "The Midnight Heist",
        blurb: "A museum gala. A missing emerald. Forty guests, three hidden corridors, and a curator who isn't telling everything.",
        location: "Halloran Museum · Old Quarter",
        difficulty: .detective,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Curator's Friend",
            profileSilhouette: "person.fill.questionmark",
            known: "Wore a green tie. Vanished before the toast."
        ),
        sceneIcon: "building.columns.fill",
        sceneTint: [0.08, 0.30, 0.34],
        evidence: [
            Evidence(
                id: "ev-002-fingerprint",
                type: .fingerprint,
                name: "Champagne Glass Print",
                description: "On a flute left atop the emerald's display case. Lipstick traces — but the print isn't the curator's.",
                isIncriminating: true,
                normalizedX: 0.62,
                normalizedY: 0.36,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Right index finger. Pressed hard, as if leaning over the case.",
                    uvFinding: "Champagne residue confirms the flute was used at the gala — not staged after.",
                    labFinding: "Print matches a guest signed in as 'M. Halloran' — but Halloran's a fake name. The signer used a borrowed ID.",
                    forensicVerdict: .strong,
                    forensicNote: "A guest with a fake ID, leaning over the emerald case. The bench will follow this thread."
                ),
                surfaceIcon: "diamond.fill",
                surfaceLabel: "THE EMERALD CASE",
                judgeLine: "A fake-ID guest, leaning over the case where the emerald sat. Accepted."
            ),
            Evidence(
                id: "ev-002-thread",
                type: .hair,
                name: "Green Silk Thread",
                description: "Caught in the case's hinge mechanism. Forest green, matches the gala invitation tie color.",
                isIncriminating: true,
                normalizedX: 0.40,
                normalizedY: 0.62,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Hand-stitched silk, not factory. From a couture tie — uncommon make.",
                    uvFinding: "Sweat residue on the fibers — worn for hours, then snagged.",
                    labFinding: "Thread composition matches a single tailor in the city. Their records have a buyer with a green-tie order.",
                    forensicVerdict: .strong,
                    forensicNote: "Trips an identifiable buyer and places them at the case. Strong physical link."
                ),
                surfaceIcon: "scissors",
                surfaceLabel: "THE CASE HINGE",
                judgeLine: "Couture green silk caught in the hinge. The tailor knows your suspect. Accepted."
            ),
            Evidence(
                id: "ev-002-floorplan",
                type: .note,
                name: "Torn Floor Plan",
                description: "A page from a docent's binder, torn out. Hidden corridors are circled in pencil.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil pressure points show a route through the service corridor — not the public floor.",
                    uvFinding: "A second route was sketched and erased: an alternate exit through the loading dock.",
                    labFinding: "Pencil graphite contains a pigment used by the museum's restoration team — the binder is a docent's.",
                    forensicVerdict: .strong,
                    forensicNote: "Premeditation, with insider docent access. The plan was studied. Accepted."
                ),
                surfaceIcon: "map.fill",
                surfaceLabel: "THE DOCENT'S DESK",
                judgeLine: "An insider's floor plan with the route circled. Premeditation is plain. Accepted."
            ),
            Evidence(
                id: "ev-002-coatcheck",
                type: .receipt,
                name: "Coat-Check Ticket #47",
                description: "Dropped near the service corridor entrance. Number 47 was claimed at 11:41 — eight minutes before the alarm.",
                isIncriminating: true,
                normalizedX: 0.78,
                normalizedY: 0.72,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard cardstock, embossed. Crease pattern shows it was folded into a tie pocket.",
                    uvFinding: "A faint coat-check stamp matches the cloakroom register at 7:42 PM — they checked in early.",
                    labFinding: "The cloakroom's coat #47 was retrieved at 11:41 PM, eight minutes before the alarm. The owner has not returned for it.",
                    forensicVerdict: .strong,
                    forensicNote: "Times the suspect to the corridor four minutes before the theft. Accepted."
                ),
                surfaceIcon: "tag.fill",
                surfaceLabel: "BY THE SERVICE CORRIDOR",
                judgeLine: "Coat #47, claimed at 11:41 — and never picked up. The bench notes the timing."
            ),
            Evidence(
                id: "ev-002-radio",
                type: .photograph,
                name: "Catering Earpiece",
                description: "A staff radio earpiece on the floor by the bar. The catering crew worked all night — could be anyone's.",
                isIncriminating: false,
                normalizedX: 0.16,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard catering issue. Battery still warm.",
                    uvFinding: "Cleaning solvent residue. Replaced earpiece, not the original wearer's.",
                    labFinding: "Logs show the unit was checked out by Marcus, the bar lead, who served champagne all night. Cleared.",
                    forensicVerdict: .weak,
                    forensicNote: "Belongs to staff with a confirmed alibi and the bar log to back it up. Don't bother."
                ),
                surfaceIcon: "earbuds",
                surfaceLabel: "THE BAR FLOOR",
                judgeLine: "The bar lead's earpiece. He's on the bar log all night. Discarded."
            ),
            Evidence(
                id: "ev-002-lipstick",
                type: .bloodstain,
                name: "Lipstick on a Glass",
                description: "A wine glass on the second floor. Crimson lipstick, distinct shade. Doesn't match the suspect's silhouette.",
                isIncriminating: false,
                normalizedX: 0.86,
                normalizedY: 0.20,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Heavy application. Recently re-applied. Not a smudge from accidental contact.",
                    uvFinding: "DNA fluoresces — a guest, not staff.",
                    labFinding: "Matches Mrs. Velazquez, a confirmed gala attendee with diplomatic alibi. Has not left her booth all evening.",
                    forensicVerdict: .weak,
                    forensicNote: "Identified, photographed at her booth at the time of the theft. Not material."
                ),
                surfaceIcon: "wineglass.fill",
                surfaceLabel: "THE SECOND FLOOR LOUNGE",
                judgeLine: "Mrs. Velazquez's lipstick. She was in her booth on three witnesses' testimony. Discarded."
            )
        ],
        minIncriminatingToWin: 3,
        reward: 720,
        fineOnLoss: 280,
        unlockCost: 800,
        requiresCaseId: "case-001m-cobbler",
        truth: [
            "The Curator's Friend bought a forgery's worth of access — a borrowed ID, a couture green tie, a docent's floor plan slipped from a binder.",
            "They arrived early, checked their coat at 7:42 PM, and waited through the speeches.",
            "At 11:35, they slipped through the service corridor — the route circled in their stolen plan.",
            "By 11:41 they retrieved their coat from #47 and walked back into the gala carrying the emerald in an inside pocket.",
            "The alarm hit at 11:49. By then they were three blocks away in a borrowed cab. The coat was never picked up because they wore it out, and #47's owner had given it to them at the cloakroom by mistake."
        ],
        suspectReveal: "The bench finds your suspect — \"The Curator's Friend\" — guilty of grand larceny and forgery."
    )

    static let diamondVanish = CrimeCase(
        id: "case-003-diamond",
        title: "The Diamond Vanish",
        blurb: "A jeweler's vault. No signs of entry. The diamonds are gone, and the security tapes show only static.",
        location: "Stellar Jewelers · Financial District",
        difficulty: .veteran,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Static Ghost",
            profileSilhouette: "person.fill.questionmark",
            known: "Knew the camera schedule. Knew the codes."
        ),
        sceneIcon: "diamond.fill",
        sceneTint: [0.12, 0.10, 0.32],
        evidence: [
            Evidence(
                id: "ev-003v-jammer",
                type: .weapon,
                name: "Jammer Residue",
                description: "Burnt copper traces on the camera vent. Someone fed RF into the security feed — that's why the tape is static.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.22,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Burnt copper coil pattern. Hand-wound, not factory — homemade jammer.",
                    uvFinding: "Solder residue from a portable soldering iron. The device was assembled on-site.",
                    labFinding: "Copper alloy traces match a hardware-store batch sold to one buyer this month — paid cash.",
                    forensicVerdict: .strong,
                    forensicNote: "Homemade jammer. The static on the tapes is no accident. Strongly material."
                ),
                surfaceIcon: "antenna.radiowaves.left.and.right",
                surfaceLabel: "THE CAMERA VENT",
                judgeLine: "A homemade jammer. The static on the tapes was your suspect's design. Accepted."
            ),
            Evidence(
                id: "ev-003v-mug",
                type: .receipt,
                name: "Personalized Coffee Mug",
                description: "On the security desk. Inscription: \"World's Best Uncle.\" Half-full, still warm at 3:14 AM.",
                isIncriminating: true,
                normalizedX: 0.66,
                normalizedY: 0.38,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Lipstick-free rim. Coffee residue confirms it was sipped, not staged.",
                    uvFinding: "Saliva trace fluoresces. Recent — within the last hour.",
                    labFinding: "DNA is on file: belongs to Larry, the night security guard who claims he was on his lunch break in the breakroom.",
                    forensicVerdict: .strong,
                    forensicNote: "Larry was at his desk while claiming he wasn't. Inside-job timeline confirmed."
                ),
                surfaceIcon: "cup.and.saucer.fill",
                surfaceLabel: "THE SECURITY DESK",
                judgeLine: "Larry's mug, drunk fresh. He says he wasn't at his desk. He was. Accepted."
            ),
            Evidence(
                id: "ev-003v-card",
                type: .photograph,
                name: "Cloned Access Card",
                description: "Found behind the planter. Magnetic strip is reverse-engineered, but the card has no name.",
                isIncriminating: true,
                normalizedX: 0.50,
                normalizedY: 0.78,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Strip is hand-burned, not factory-imprinted. Industrial-strength card-cloner work.",
                    uvFinding: "A signature was wiped under UV — first letter looks like 'L'.",
                    labFinding: "Card's encoded credentials match the access pattern of Larry's badge — but used at vault times Larry says he was away.",
                    forensicVerdict: .strong,
                    forensicNote: "Larry's clone. The card opened the vault. Larry's testimony unravels here."
                ),
                surfaceIcon: "creditcard.fill",
                surfaceLabel: "BEHIND THE PLANTER",
                judgeLine: "A clone of Larry's badge — opening the vault when Larry says he wasn't here. Accepted."
            ),
            Evidence(
                id: "ev-003v-keypad",
                type: .fingerprint,
                name: "Smudged Keypad Print",
                description: "On the vault keypad. Pattern of smudges shows the four most-pressed digits.",
                isIncriminating: true,
                normalizedX: 0.84,
                normalizedY: 0.55,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Repeated press wear on 2, 4, 7, 9 — the suspect knew the digits, just not the order.",
                    uvFinding: "Glove residue. Latex powder, freshly applied.",
                    labFinding: "Two-of-three print fragments match Larry. The third matches a known print-cloning service in the city.",
                    forensicVerdict: .strong,
                    forensicNote: "Larry's vault code, used by gloved hands. Either Larry himself or someone he handed the code to."
                ),
                surfaceIcon: "lock.rectangle.stack.fill",
                surfaceLabel: "THE VAULT KEYPAD",
                judgeLine: "Larry's vault code, in gloved hands. Inside-job is now beyond reasonable doubt. Accepted."
            ),
            Evidence(
                id: "ev-003v-ledger",
                type: .note,
                name: "Insurance Ledger Page",
                description: "A torn ledger sheet listing the missing diamonds — and four others not yet reported missing.",
                isIncriminating: true,
                normalizedX: 0.20,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Pencil annotations beside each diamond — re-sale prices in another country's currency.",
                    uvFinding: "A phone number was sketched and erased — international code, dialed twice this week.",
                    labFinding: "The four \"unreported\" diamonds are missing too — Larry quietly logged them as on-site for a different audit window.",
                    forensicVerdict: .strong,
                    forensicNote: "Premeditated multi-stone theft, with a fence already lined up. Slam dunk."
                ),
                surfaceIcon: "book.pages.fill",
                surfaceLabel: "THE LEDGER DESK",
                judgeLine: "A pre-priced fence list with international resale figures. Premeditation is documented."
            ),
            Evidence(
                id: "ev-003v-clipboard",
                type: .receipt,
                name: "Cleaning Crew Clipboard",
                description: "Yesterday's cleaning checklist, signed off in three places. Could be from any of the cleaners.",
                isIncriminating: false,
                normalizedX: 0.44,
                normalizedY: 0.32,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard janitorial checklist. Three different signatures — three crew members.",
                    uvFinding: "No fluorescence. Nothing hidden in the paper.",
                    labFinding: "Times match the cleaning logs. All three crew members have alibis verified by the lobby cameras.",
                    forensicVerdict: .weak,
                    forensicNote: "Routine. Three confirmed alibis. Don't bother."
                ),
                surfaceIcon: "list.clipboard.fill",
                surfaceLabel: "THE JANITOR'S CLOSET",
                judgeLine: "Three cleaners, three alibis, three lobby-camera confirmations. Discarded."
            ),
            Evidence(
                id: "ev-003v-visitor",
                type: .photograph,
                name: "Visitor Badge",
                description: "Dropped in the lobby. Issued to a courier at 4:50 PM yesterday.",
                isIncriminating: false,
                normalizedX: 0.12,
                normalizedY: 0.84,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Time stamp confirms a 4:50 PM check-in. Badge was returned at 4:58 PM per the log.",
                    uvFinding: "No biological traces beyond the courier's.",
                    labFinding: "Courier is on file. Their delivery (jewelry samples) was logged and signed by Maria, the floor manager.",
                    forensicVerdict: .weak,
                    forensicNote: "A documented, alibi'd courier. The badge was simply dropped on exit."
                ),
                surfaceIcon: "person.text.rectangle.fill",
                surfaceLabel: "THE LOBBY FLOOR",
                judgeLine: "A documented courier with a signed delivery log. Discarded."
            )
        ],
        minIncriminatingToWin: 4,
        reward: 1450,
        fineOnLoss: 520,
        unlockCost: 2200,
        requiresCaseId: "case-002-midnight",
        truth: [
            "The Static Ghost was Larry, the night guard — and he had help. He'd been planning for six months.",
            "He cloned his own badge with help from a print-cloning shop, then handed the clone (and the vault code) to an outside partner.",
            "At 2:55 AM Larry built a homemade jammer at the camera vent — that's why the tapes are static, not corrupt.",
            "He went to \"lunch\" at 3:00 AM, leaving his coffee at the desk — still warm when we arrived.",
            "His partner walked in with the cloned card, opened the vault with the keypad code, and took five diamonds — four of which Larry had quietly delisted from this audit cycle. The vault was empty by 3:18 AM."
        ],
        suspectReveal: "The bench finds your suspect — \"The Static Ghost\" (Larry Kovacs) — guilty of conspiracy to commit grand theft."
    )

    static let masquerade = CrimeCase(
        id: "case-004-masquerade",
        title: "The Masquerade Murder",
        blurb: "A senator. A masked ball. A single shot in the conservatory. Everyone has a mask. Only one has a motive.",
        location: "Larkspur Estate · Hilltop",
        difficulty: .master,
        suspect: Suspect(
            name: "Unknown",
            alias: "The Velvet Mask",
            profileSilhouette: "person.fill.questionmark",
            known: "A whisper. A smile. A perfect alibi."
        ),
        sceneIcon: "theatermasks.fill",
        sceneTint: [0.30, 0.10, 0.18],
        evidence: [
            Evidence(
                id: "ev-004m-mask",
                type: .photograph,
                name: "Velvet Mask Fragment",
                description: "A torn corner of black velvet, snagged on the conservatory door latch. Hand-stitched gold filigree.",
                isIncriminating: true,
                normalizedX: 0.40,
                normalizedY: 0.30,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Velvet weave is rare — Lyon mill, distributed to two designers in the city.",
                    uvFinding: "Fluoresces faintly: cologne traces. Distinctive bergamot blend, custom-blended.",
                    labFinding: "Filigree thread matches a single bespoke piece commissioned six weeks ago — the buyer used a numbered account.",
                    forensicVerdict: .strong,
                    forensicNote: "Bespoke mask, custom cologne, numbered buyer. We can find them. Strongly material."
                ),
                surfaceIcon: "theatermasks.fill",
                surfaceLabel: "THE CONSERVATORY DOOR",
                judgeLine: "Bespoke velvet, bespoke cologne. The mask was made for one buyer. Accepted."
            ),
            Evidence(
                id: "ev-004m-casing",
                type: .weapon,
                name: ".38 Brass Casing",
                description: "Under an upturned chair. Single shot, recently fired. The senator was hit once, cleanly.",
                isIncriminating: true,
                normalizedX: 0.62,
                normalizedY: 0.66,
                analysis: EvidenceAnalysis(
                    magnifierFinding: ".38 Special, hand-loaded. Crimp pattern is custom — not a factory cartridge.",
                    uvFinding: "Powder residue suggests a suppressed barrel. Almost no one heard the shot.",
                    labFinding: "Crimp matches a known reloader on the city's east side. They sell to four customers — three are cops.",
                    forensicVerdict: .strong,
                    forensicNote: "Suppressed, custom load, traceable reloader. The bench will follow this."
                ),
                surfaceIcon: "scope",
                surfaceLabel: "UNDER THE CHAIR",
                judgeLine: "A custom-loaded, suppressed shot. The reloader has four buyers. We are narrowing it. Accepted."
            ),
            Evidence(
                id: "ev-004m-glass",
                type: .bloodstain,
                name: "Burnt Glass Residue",
                description: "Champagne glass on the windowsill. Faint scorch marks — gunpowder bloomed on it.",
                isIncriminating: true,
                normalizedX: 0.78,
                normalizedY: 0.40,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Soot pattern is asymmetric — the shooter held the glass in their off-hand while firing.",
                    uvFinding: "Lipstick and saliva residue: a partial DNA profile. Not the senator's.",
                    labFinding: "DNA partial-matches a guest known to the social register. Not on the official guest list — they came in on someone else's invitation.",
                    forensicVerdict: .strong,
                    forensicNote: "The shooter held this glass while firing. DNA narrows the suspect pool to the social register."
                ),
                surfaceIcon: "wineglass.fill",
                surfaceLabel: "THE WINDOWSILL",
                judgeLine: "Gunpowder bloom on the champagne flute they held while firing. DNA narrows the field. Accepted."
            ),
            Evidence(
                id: "ev-004m-invitation",
                type: .note,
                name: "Forged Invitation",
                description: "A gala invitation with a senator's signature — but the signature is a clean forgery.",
                isIncriminating: true,
                normalizedX: 0.20,
                normalizedY: 0.50,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Signature is too consistent — real signatures vary. This was practiced.",
                    uvFinding: "Watermark is slightly off-position — a counterfeit blank, not a stolen original.",
                    labFinding: "Ink composition matches a forger known to law enforcement. The forger remembers the buyer: a woman with a numbered account.",
                    forensicVerdict: .strong,
                    forensicNote: "The same numbered-account buyer who commissioned the mask. The case writes itself."
                ),
                surfaceIcon: "envelope.open.fill",
                surfaceLabel: "BY THE FOYER TABLE",
                judgeLine: "Forged invitation by a known forger. Same numbered-account buyer as the mask. Accepted."
            ),
            Evidence(
                id: "ev-004m-footprint",
                type: .footprint,
                name: "Print on Rose Petals",
                description: "A heel print on scattered rose petals near the senator's body. Narrow, women's, stiletto.",
                isIncriminating: true,
                normalizedX: 0.50,
                normalizedY: 0.82,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Stiletto, women's size 7. Pressure pattern — they paused over the body, then turned away.",
                    uvFinding: "Petal-juice on the heel: mostly red rose, but a streak of greenhouse phosphate.",
                    labFinding: "Phosphate matches the estate's own greenhouse — the suspect crossed it on the way in.",
                    forensicVerdict: .strong,
                    forensicNote: "Places them at the body, with a route that proves entry through the greenhouse — a route that was supposedly locked."
                ),
                surfaceIcon: "leaf.fill",
                surfaceLabel: "ON THE ROSE PETALS",
                judgeLine: "Stiletto in the petals, with greenhouse phosphate in the tread. They walked past a locked door. Accepted."
            ),
            Evidence(
                id: "ev-004m-hair",
                type: .hair,
                name: "Hairpin",
                description: "An ornate gold hairpin near the entrance. Could belong to any of forty guests.",
                isIncriminating: true,
                normalizedX: 0.30,
                normalizedY: 0.18,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Bespoke goldwork, signed by a single jeweler. Engraved monogram: \"V. M.\"",
                    uvFinding: "A polishing oil unique to that jeweler's shop.",
                    labFinding: "Jeweler's records: the pin was made for a private buyer who used the same numbered account as the mask and invitation.",
                    forensicVerdict: .strong,
                    forensicNote: "Three pieces of bespoke evidence, three same-buyer records. The bench has a name."
                ),
                surfaceIcon: "scissors.badge.ellipsis",
                surfaceLabel: "BY THE ENTRANCE",
                judgeLine: "A monogrammed hairpin from the same numbered-account buyer. The pattern is undeniable. Accepted."
            ),
            Evidence(
                id: "ev-004m-glove",
                type: .photograph,
                name: "Discarded Glove",
                description: "A man's white evening glove, dropped in the foyer. Not a match for the conservatory scene.",
                isIncriminating: false,
                normalizedX: 0.86,
                normalizedY: 0.18,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Standard white silk evening glove. Right hand. No tearing.",
                    uvFinding: "No biological surprises — the wearer's own sweat, nothing else.",
                    labFinding: "Belongs to Mr. Ferreira, the senator's chief of staff, who confirmed dropping it while greeting guests at 8 PM. Multiple witnesses.",
                    forensicVerdict: .weak,
                    forensicNote: "Three witnesses, no suspicious traces. Not your shooter."
                ),
                surfaceIcon: "hand.raised.fill",
                surfaceLabel: "THE FOYER FLOOR",
                judgeLine: "Mr. Ferreira's glove, lost at 8 PM with three witnesses. Discarded."
            ),
            Evidence(
                id: "ev-004m-spill",
                type: .bloodstain,
                name: "Spilled Drink",
                description: "A tipped wine glass, red wine pooling. Five feet from the body. Could be from the panic.",
                isIncriminating: false,
                normalizedX: 0.16,
                normalizedY: 0.66,
                analysis: EvidenceAnalysis(
                    magnifierFinding: "Splash pattern shows the glass fell from a height — it was knocked over, not staged.",
                    uvFinding: "DNA on the rim: belongs to a server, who collapsed when she found the body.",
                    labFinding: "Camera footage shows the server fainting at 11:51 PM, dropping her tray. Innocent.",
                    forensicVerdict: .weak,
                    forensicNote: "A fainted server's tray. The bench has empathy. Discarded."
                ),
                surfaceIcon: "drop.fill",
                surfaceLabel: "FIVE FEET FROM THE BODY",
                judgeLine: "The server fainted on discovery. We have her on tape. Discarded."
            )
        ],
        minIncriminatingToWin: 5,
        reward: 3200,
        fineOnLoss: 1100,
        unlockCost: 5000,
        requiresCaseId: "case-003-diamond",
        truth: [
            "The Velvet Mask is Vivienne Marais — old money, social register, and the senator's cousin by marriage.",
            "She held a grudge for fifteen years over a contested estate. The masquerade was her opportunity, and her style.",
            "She commissioned the mask, the hairpin, and the gala invitation through a single numbered account — confident no one would assemble all three.",
            "She crossed the locked greenhouse with a stolen key, picked up rose petals on her heels, and slipped into the conservatory at 11:47 PM with a hand-loaded .38 in her clutch.",
            "She fired once, suppressed. The senator went down. She left her champagne flute on the windowsill (gunpowder bloom and all), tore her mask on the door, dropped a hairpin in the foyer rush, and walked out the front door before the alarm rose. She is, in every way, the case her own evidence makes."
        ],
        suspectReveal: "The bench finds your suspect — \"The Velvet Mask\" (Vivienne Marais) — guilty of murder in the first degree."
    )
}
