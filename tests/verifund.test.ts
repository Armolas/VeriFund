
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
        Cl.list(
          [
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
          ]
        ),
        Cl.none()
      ],
      deployer
    );

    const campaignId = result.result;
    expect(campaignId).toBeOk(Cl.uint(0))
  })

  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  // it("shows an example", () => {
  //   const { result } = simnet.callReadOnlyFn("counter", "get-counter", [], address1);
  //   expect(result).toBeUint(0);
  // });
});
