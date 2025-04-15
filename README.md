# VeriFund

> **Funding with trust. Powered by Bitcoin. Built on Stacks.**

**VeriFund** is a decentralized crowdfunding protocol built on the [Stacks](https://stacks.co) blockchain. It introduces accountability and transparency to the fundraising process through milestone-based fund releases, empowering backers and reducing the risk of fund misuse.

---

## 🚀 Project Summary

VeriFund enables project creators to define structured crowdfunding campaigns with clear goals and milestones. Funds are held in escrow and released only when specific milestones are verified — making fundraising **trackable**, **transparent**, and **accountable**.

---

## 📦 Features

- ✍️ Create structured campaigns with multiple funding milestones
- 💸 Contribute to campaigns as a backer
- 🔐 Lock funds in contract until milestones are approved
- ✅ Milestone-based fund releases
- 🧾 Proposal links for campaign transparency
- 🔁 Refund logic for unfulfilled or canceled campaigns
- 🗳️ Milestone approval through decentralized voting

---

## ⚙️ Smart Contract Overview

### 🔢 Data Variables
- `campaign_count`: Keeps track of total campaigns

### 🗺️ Data Maps
- `campaigns`: Stores each campaign’s metadata, goal, milestones, and status
- `funders`: Tracks individual funders and their contributions
- `funders_by_campaign`: Lists funders per campaign
- `milestone_approvals`: Tracks milestone voting and approval status

### 📤 Public Functions
- `create_campaign`: Create a new campaign with a goal, milestones, and optional proposal link

(*More functions like `contribute`, `approve_milestone`, `claim_funds`, and `request_refund` are in development.*)

---

## 🛠️ Contract Snippet

```clarity
(define-map campaigns uint {
    name: (string-ascii 100),
    description: (string-ascii 500),
    goal: uint,
    amount_raised: uint,
    balance: uint,
    owner: principal,
    milestones: (list 10 {
        name: (string-ascii 100),
        amount: uint,
        completed: bool
    }),
    proposal_link: (optional (string-ascii 200))
})
```

---

## 📚 How It Works

1. **Project Creator** creates a campaign with a funding goal and a list of milestones.
2. **Backers** fund the campaign. Their funds are locked in the contract.
3. When a milestone is completed, backers vote to approve the release of funds.
4. If approved, only the amount for that milestone is released to the creator.
5. If the campaign fails or is canceled, backers can request refunds.

---

## 📦 Tech Stack

- **Clarity** (Smart Contracts)
- **Stacks Blockchain**
- Powered by Bitcoin's security through **Proof of Transfer (PoX)**

---

## ✨ Future Roadmap

- ✅ Contribution system
- ✅ Milestone voting & verification
- ✅ Partial fund release logic
- 🔜 Refund logic
- 🔜 UI Dashboard (Frontend)
- 🔜 DAO-based voting integration

---

## 🤝 Contributing

VeriFund is open to contributors passionate about Web3, transparency, and accountable crowdfunding. Pull requests are welcome!

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙌 Acknowledgements

Thanks to the Stacks Ascent program for supporting this journey and helping bring VeriFund to life.

---

## 🔗 Connect with the Creator

Built with 💜 by Muritadhor Arowolo