PROMPT — InDrive-Style Pricing & Negotiation System

═══════════════════════════════════════════════════
FLOW
═══════════════════════════════════════════════════

1. Client selects service + fills date/time/address
2. App shows available technicians (same category + same city)
3. Each technician card shows: name, rating, base price
4. Client sends booking request to a technician
5. Technician receives request → can ACCEPT base price or COUNTER with new price
6. Client sees counter price → can ACCEPT or REJECT
7. Negotiation continues until agreement
8. Once agreed: final_price = agreed_price, app_fee = 10%, tech_receives = 90%
9. App fee transferred to app's payment account

═══════════════════════════════════════════════════
FIRESTORE STRUCTURE
═══════════════════════════════════════════════════

booking_requests/{id}:
  clientId, techId, serviceId, category
  address, city, date, timeSlot
  basePrice (from service catalog)
  offers: [
    {from: "client", price: 200, timestamp},
    {from: "tech", price: 250, timestamp},
    {from: "client", price: 230, timestamp, accepted: true}
  ]
  agreedPrice: 230
  appFee: 23 (10%)
  techReceives: 207 (90%)
  status: pending/negotiating/agreed/inProgress/completed/cancelled

═══════════════════════════════════════════════════
SCREENS
═══════════════════════════════════════════════════

1. AvailableTechniciansScreen - shows techs for category+city
2. NegotiationScreen - price back-and-forth
3. Updated BookingFlow - integrates new system
