# PrivacyPharma: One-Minute Video Demonstration Script

**Zama Bounty Track - December 2025 Submission**

**Total Duration**: 60 seconds
**Format**: Screen recording with voice-over narration
**Target Audience**: FHEVM developers, blockchain security researchers, Zama bounty reviewers

---

## Scene Breakdown

### Scene 1: Opening & Problem Statement (0:00 - 0:10)

**Visual**:
- Display project title "PrivacyPharma" with FHEVM badge
- Show ASCII diagram of buyer-supplier-contract flow
- Quick flash of key problem points on screen

**Screen Elements**:
```
PrivacyPharma
Confidential Pharmaceutical Procurement

PROBLEM:
❌ Public blockchain exposes all bids
❌ Competitors see pricing strategies
❌ Buyers reveal sensitive needs
```

**Action**:
- Fade in title
- Animate flow diagram
- Highlight problem bullets

**Narration Reference**: See NARRATION.md lines 1-5

---

### Scene 2: FHEVM Solution Overview (0:10 - 0:20)

**Visual**:
- Split screen showing encrypted vs decrypted data
- Highlight FHE operations (FHE.le, FHE.ge, FHE.select)
- Show code snippet from contract

**Screen Elements**:
```solidity
// All comparisons on ENCRYPTED data
ebool canFulfill = FHE.ge(bid.quantity, order.quantity);
ebool withinBudget = FHE.le(bid.price, order.budget);
ebool isBestPrice = FHE.lt(bid.price, bestPrice);

// Result: Supplier B selected
// (Contract never saw actual prices!)
```

**Action**:
- Transition from problem to solution
- Code highlight with annotations
- Emphasize "ENCRYPTED" in red

**Narration Reference**: See NARRATION.md lines 6-10

---

### Scene 3: Live Demo - Order Creation (0:20 - 0:30)

**Visual**:
- Browser window with frontend application
- MetaMask wallet connection
- Form filling and transaction confirmation

**Screen Elements**:
```
Connect Wallet: [Connected ✓]

CREATE ORDER
─────────────
Drug ID:      42
Quantity:     100
Max Budget:   5000 wei

[Create Order] ← Click
```

**Action**:
- Show wallet connection
- Fill form fields quickly
- Submit transaction
- Show "Order Created" confirmation with Order ID #1

**Narration Reference**: See NARRATION.md lines 11-14

---

### Scene 4: Live Demo - Bid Submission (0:30 - 0:40)

**Visual**:
- Three separate browser windows (or tabs) for three suppliers
- Rapid bid submissions from Supplier A, B, C
- Transaction confirmations

**Screen Elements**:
```
SUPPLIER A               SUPPLIER B               SUPPLIER C
Order ID: 1              Order ID: 1              Order ID: 1
Price:    4500          Price:    4200 ← Best    Price:    4800
Quantity: 150           Quantity: 120            Quantity: 200

[Submit Bid]            [Submit Bid]             [Submit Bid]
```

**Action**:
- Quick cuts between three suppliers
- Show encrypted bid submissions
- Display "Bid Submitted" events
- Emphasize prices are encrypted (show lock icons)

**Narration Reference**: See NARRATION.md lines 15-18

---

### Scene 5: Live Demo - Order Matching (0:40 - 0:50)

**Visual**:
- Buyer clicks "Match Order"
- Show loading/processing animation
- Display FHE comparison visualization
- Show winning supplier selected

**Screen Elements**:
```
MATCHING ORDER #1...

FHE Computations:
✓ Checking quantities (encrypted)
✓ Validating budgets (encrypted)
✓ Finding lowest price (encrypted)

Result: Supplier B Selected!
```

**Action**:
- Click "Match Order" button
- Animate FHE operation checkmarks
- Show Supplier B highlighted as winner
- Display "Order Matched" event

**Narration Reference**: See NARRATION.md lines 19-22

---

### Scene 6: Live Demo - Fulfillment & Key Concepts (0:50 - 0:58)

**Visual**:
- Supplier B clicks "Fulfill Order"
- Show decryption request
- Display revealed order details
- Quick montage of code highlighting FHEVM concepts

**Screen Elements**:
```
FULFILL ORDER #1

Decryption Requested...
✓ Callback received

Revealed Details:
Drug ID:   42
Quantity:  100
Price:     4200

Order Fulfilled ✓
```

**Overlay Text**:
```
FHEVM Concepts Demonstrated:
✓ Encryption (euint32, euint64)
✓ Access Control (FHE.allow)
✓ Private Computation (FHE.le, FHE.ge)
✓ Public Decryption (async callback)
```

**Action**:
- Click "Fulfill Order"
- Show decryption animation
- Display decrypted values
- Rapid code snippet highlights

**Narration Reference**: See NARRATION.md lines 23-28

---

### Scene 7: Closing & Call to Action (0:58 - 1:00)

**Visual**:
- GitHub repository page
- README documentation preview
- Competition submission badge
- Contact information

**Screen Elements**:
```
PrivacyPharma
──────────────────────────────
✓ Complete FHEVM Example
✓ 1000+ Lines Documentation
✓ 15+ Test Cases
✓ Production Insights

Zama Bounty December 2025
GitHub: [Repository Link]

Built with ❤️ using FHEVM
```

**Action**:
- Quick scroll through README
- Show badges and documentation
- Display GitHub stars/forks
- Fade to submission badge

**Narration Reference**: See NARRATION.md lines 29-30

---

## Technical Production Notes

### Recording Settings

**Screen Resolution**: 1920x1080 (Full HD)
**Frame Rate**: 30 fps
**Audio**: 44.1 kHz, stereo

### Required Software

- **Screen Recorder**: OBS Studio or Camtasia
- **Video Editor**: DaVinci Resolve or Adobe Premiere
- **Browser**: Chrome with MetaMask extension
- **Code Editor**: VS Code with Solidity highlighting

### Pre-Recording Checklist

- [ ] Deploy contract to Sepolia testnet
- [ ] Verify all three supplier accounts with testnet ETH
- [ ] Prepare frontend with deployed contract address
- [ ] Test complete workflow once before recording
- [ ] Clear browser cache for clean demo
- [ ] Prepare code snippets in VS Code
- [ ] Set up screen recording software
- [ ] Test audio levels for narration

### Scene Transition Effects

- **0:00-0:10**: Fade in with title animation
- **0:10-0:20**: Slide transition to code view
- **0:20-0:30**: Zoom in to browser window
- **0:30-0:40**: Quick cuts between supplier windows
- **0:40-0:50**: Smooth pan to matching visualization
- **0:50-0:58**: Split screen code + demo
- **0:58-1:00**: Fade out to closing screen

### Visual Annotations

**Use Color Coding**:
- 🔒 Red: Encrypted data
- 🔓 Green: Decrypted data
- ⚡ Blue: FHE operations
- ✅ Purple: Completed actions

**Highlight Effects**:
- Yellow box around important code
- Arrow pointers for UI elements
- Pulse effect on transaction confirmations
- Lock/unlock icons for encryption status

### Audio Mixing

**Background Music**:
- Subtle, professional tech music
- Volume: 20% (don't overpower narration)
- Genre: Ambient electronic, modern tech
- Fade in at 0:00, fade out at 0:58

**Sound Effects**:
- Click sound for button presses (subtle)
- Success chime for transaction confirmations
- Whoosh for scene transitions

**Voice-over**:
- Primary audio at 100%
- Professional tone, clear enunciation
- Pacing: ~150 words per minute
- Sync precisely with visual actions

---

## Alternative 30-Second Version

For social media sharing, create a condensed 30-second version:

**Quick Cut Structure**:
1. Problem (3s): "Blockchain auctions lack privacy"
2. Solution (5s): "FHEVM enables encrypted bidding"
3. Demo (15s): Rapid order→bid→match→fulfill sequence
4. Result (5s): "Complete privacy, trustless execution"
5. CTA (2s): "Link in bio"

---

## B-Roll Footage Ideas

If extending to 90 seconds, include:

- Code walkthrough of key functions
- Test suite execution showing all passing tests
- Diagram animations explaining FHE concepts
- Comparison table: Traditional vs FHEVM approach
- Documentation scroll-through
- GitHub insights (commits, contributors)

---

## Accessibility Considerations

### Closed Captions

- Include full transcript as closed captions
- Sync timing to match narration precisely
- Use contrasting colors for visibility
- Include sound effect descriptions

### Visual Clarity

- High contrast for text overlays
- Large font sizes (min 24pt for code)
- Avoid rapid flashing (accessibility)
- Provide audio descriptions of visual elements

---

## Post-Production Checklist

- [ ] Video renders at 1080p
- [ ] Audio levels consistent throughout
- [ ] Captions synced perfectly
- [ ] No watermarks or branding conflicts
- [ ] File size under 100MB (for easy sharing)
- [ ] Export in MP4 format (H.264 codec)
- [ ] Upload to YouTube with detailed description
- [ ] Generate shareable link
- [ ] Create thumbnail image
- [ ] Add to competition submission

---

## Video Description Template (for YouTube)

```
PrivacyPharma: Confidential Pharmaceutical Procurement on FHEVM

Submitted for Zama Bounty Track - December 2025

This one-minute demonstration showcases a privacy-preserving pharmaceutical
procurement system built with Fully Homomorphic Encryption (FHEVM). Watch how
encrypted bidding, private computation, and selective decryption enable
trustless, confidential auctions on blockchain.

🔐 Key Features:
- Encrypted order creation (euint32, euint64)
- Private bid comparison using FHE operations
- Selective decryption for winning suppliers
- Complete workflow demonstration

📚 FHEVM Concepts:
✓ Encryption (chapter: encryption)
✓ Access Control (chapter: access-control)
✓ Private Computation (chapter: private-computation)
✓ Public Decryption (chapter: public-decryption)

🔗 Resources:
- GitHub Repository: [link]
- Full Documentation: [link]
- Live Demo: [link]
- Zama FHEVM Docs: https://docs.zama.ai/fhevm

🏆 Competition Submission:
This project demonstrates advanced FHEVM patterns including encrypted
reputation systems, batch decryption, and multi-criteria selection on
encrypted data.

Built with ❤️ using FHEVM | Zama Bounty December 2025

#FHEVM #Zama #Blockchain #Privacy #FHE #SmartContracts #Web3
```

---

## Screenshot Requirements

Capture high-resolution screenshots for:

1. **Thumbnail**: Eye-catching visual with "PrivacyPharma" title
2. **Documentation**: README sections for GitHub preview
3. **Demo**: Each stage of workflow for slides
4. **Code**: Key FHE operations highlighted
5. **Results**: Successful transaction confirmations

---

## Backup Plans

### If Live Demo Fails

- Have pre-recorded footage ready
- Keep screenshots of each step
- Prepare static diagram walkthrough
- Have testnet transaction links ready

### If Narration Recording Issues

- Use text overlays only (silent version)
- Add background music with text narration
- Record separately and sync in post-production

### If Time Runs Over

Priority cuts (in order):
1. Reduce opening title sequence (5s → 3s)
2. Speed up bid submission montage (10s → 7s)
3. Shorten closing CTA (3s → 2s)
4. Remove some code highlighting details

---

## Quality Assurance

### Before Final Export

- [ ] Watch entire video 3 times
- [ ] Check audio sync in all sections
- [ ] Verify all text is readable
- [ ] Confirm transitions are smooth
- [ ] Test on different devices (mobile, desktop)
- [ ] Get feedback from 2-3 reviewers
- [ ] Spell-check all text overlays
- [ ] Verify GitHub links work

### Final Deliverables

1. **Primary Video**: 1920x1080, MP4, 60 seconds
2. **Short Version**: 1920x1080, MP4, 30 seconds (for social)
3. **Thumbnail**: 1280x720, PNG, high contrast
4. **Transcript**: Plain text file with timestamps
5. **Narration Script**: Separate NARRATION.md file
6. **Screenshots**: 5-10 key frames in high resolution

---

**Production Timeline**

- Script finalization: 2 hours
- Setup & testing: 1 hour
- Recording (multiple takes): 2 hours
- Video editing: 3 hours
- Audio mixing: 1 hour
- Review & revisions: 2 hours
- Final export & upload: 1 hour

**Total**: ~12 hours

---

**Credits**

- **Project**: PrivacyPharma Team
- **Technology**: Zama FHEVM
- **Submission**: Zama Bounty December 2025
- **License**: MIT

---

End of Video Script
