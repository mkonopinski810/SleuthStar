import Foundation

enum CaseRepository {

    static let allCases: [CrimeCase] = [
        rooftopRobbery,
        closingShift,
        greenhouseTheft,
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
        requiresCaseId: "case-001c-greenhouse",
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
