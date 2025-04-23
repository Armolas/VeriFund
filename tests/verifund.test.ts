
import {
  Cl,
  createStacksPrivateKey,
  cvToValue,
  signMessageHashRsv,
} from "@stacks/transactions";
import { beforeEach, describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const deployer = accounts.get("wallet_1")!;
const address2 = accounts.get("wallet_2")!;
const address3 = accounts.get("wallet_3")!;
const address4 = accounts.get("wallet_4")!;
const address5 = accounts.get("wallet_5")!;
const address6 = accounts.get("wallet_6")!;
const address7 = accounts.get("wallet_7")!;
const address8 = accounts.get("wallet_8")!;


/*
  The test below is an example. To learn more, read the testing documentation here:
  https://docs.hiro.so/stacks/clarinet-js-sdk
*/

describe("verifund tests", () => {
  beforeEach(() => {
    const result = simnet.callPublicFn(
      "verifund",
      "create_campaign",
      [
        Cl.stringAscii("Feed-A-Child"),
        Cl.stringAscii("A campaign dedicated to providing meals to underprivileged children, ensuring they have access to nutritious food for a healthier future."),
        Cl.uint(100000),
        Cl.list([
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_1"),
            amount: Cl.uint(20000),
          }),
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_2"),
            amount: Cl.uint(30000),
          }),
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_3"),
            amount: Cl.uint(50000),
          }),
        ]),
        Cl.none(),
      ],
      deployer
    );

    expect(result.result).toBeOk(Cl.uint(0));

    const campaign = simnet.getMapEntry("verifund", "campaigns", Cl.uint(0));
    expect(campaign).toBeSome(
      Cl.tuple({
        owner: Cl.principal(deployer),
        name: Cl.stringAscii("Feed-A-Child"),
        description: Cl.stringAscii(
          "A campaign dedicated to providing meals to underprivileged children, ensuring they have access to nutritious food for a healthier future."
        ),
        goal: Cl.uint(100000),
        amount_raised: Cl.uint(0),
        balance: Cl.uint(0),
        proposal_link: Cl.none(),
        milestones: Cl.list([
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_1"),
            amount: Cl.uint(20000),
          }),
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_2"),
            amount: Cl.uint(30000),
          }),
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_3"),
            amount: Cl.uint(50000),
          }),
        ]),
      })
    );
  });

  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  it("should allow contributors to fund a campaign", () => {
    const fund = simnet.callPublicFn(
      "verifund",
      "fund_campaign",
      [Cl.uint(0), Cl.uint(20000)],
      address2
    );

    expect(fund.events[0].event).toBe("stx_transfer_event");
    expect(fund.events[0].data.amount).toBe("20000");

    const campaign = simnet.getMapEntry("verifund", "campaigns", Cl.uint(0));
    expect(campaign).toBeSome(
      Cl.tuple({
        owner: Cl.principal(deployer),
        name: Cl.stringAscii("Feed-A-Child"),
        description: Cl.stringAscii(
          "A campaign dedicated to providing meals to underprivileged children, ensuring they have access to nutritious food for a healthier future."
        ),
        goal: Cl.uint(100000),
        amount_raised: Cl.uint(20000),
        balance: Cl.uint(20000),
        proposal_link: Cl.none(),
        milestones: Cl.list([
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_1"),
            amount: Cl.uint(20000),
          }),
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_2"),
            amount: Cl.uint(30000),
          }),
          Cl.tuple({
            name: Cl.stringAscii("MILESTONE_3"),
            amount: Cl.uint(50000),
          }),
        ]),
      })
    );
  });

  it("should not allow contributions to non-existent campaigns", () => {
    const result = simnet.callPublicFn(
      "verifund",
      "fund_campaign",
      [Cl.uint(999), Cl.uint(20000)], // Non-existent campaign ID
      address3
    );

    expect(result.result).toBeErr(Cl.uint(0));
  });
});
